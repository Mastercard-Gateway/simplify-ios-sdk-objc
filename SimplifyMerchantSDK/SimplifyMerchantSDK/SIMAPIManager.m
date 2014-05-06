#import "SIMAPIManager.h"
#import "NSString+Simplify.h"

typedef enum {
    SIMAPIManagerModeLive,
    SIMAPIManagerModeSandbox,
    SIMAPIManagerModeInvalid,
}SIMAPIManagerMode;

#define SIMAPIManagerPrefixLive @"lv"
#define SIMAPIManagerPrefixSandbox @"sb"

#define SIMAPIManagerErrorDomain @"com.mastercard.simplify.errordomain"

static NSString *prodAPILiveURL = @"https://api.simplify.com/v1/analytics";
static NSString *prodAPISandboxURL = @"https://sandbox.simplify.com/v1/analytics";

@interface SIMAPIManager () <NSURLSessionDelegate>

@property (nonatomic) BOOL isLiveMode;

@property (nonatomic) NSString *publicApiKey;
@property (nonatomic) NSURLSession *urlSession;
@property (nonatomic) NSURL *currentAPIURL;

@end

@implementation SIMAPIManager

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSDictionary *httpHeaders = @{@"Content-Type":@"application/json",@"Accept":@"application/json"};
    [sessionConfig setHTTPAdditionalHeaders:httpHeaders];
    [sessionConfig setRequestCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    return [self initWithPublicApiKey:publicApiKey error:error urlSession:session];
}

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error urlSession:(NSURLSession *)urlSession{
    self = [super init];
    
    if (self) {

        self.isLiveMode = [self isAPIKeyLiveMode:publicApiKey error:error];
        
        if (error) {
            return nil;
        } else {

            self.publicApiKey = publicApiKey;
            self.urlSession = urlSession;
            NSString *apiURLString = (self.isLiveMode) ? prodAPILiveURL : prodAPISandboxURL;
            self.currentAPIURL = [NSURL URLWithString:apiURLString];

        }
        
    }

    return self;
}

-(BOOL)isAPIKeyLiveMode:(NSString *)apiKey error:(NSError **) error{

    BOOL isLive;
    
    if ([apiKey hasPrefix:SIMAPIManagerPrefixLive]) {
        isLive = YES;
    } else if ([apiKey hasPrefix:SIMAPIManagerPrefixSandbox]){
        isLive = NO;
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not create API Manager: Invalid API Key."};
        
        *error = [NSError errorWithDomain:SIMAPIManagerErrorDomain code:SIMAPIManagerErrorCodeInvalidAPIKey userInfo:userInfo];
    }
    
    return isLive;
    
}


- (void)createCardTokenWithExpirationMonth:(NSString *)expirationMonth
                                  expirationYear:(NSString *)expirationYear
                                      cardNumber:(NSString *)cardNumber
                                             cvc:(NSString *)cvc
                                completionHander:(CardTokenCompletionHandler)cardTokenCompletionHandler {

    NSError *jsonError;
	NSURL *url = [self.currentAPIURL URLByAppendingPathComponent:@"payment/cardToken"];
    
    NSMutableDictionary *cardData = [NSMutableDictionary dictionaryWithDictionary:@{@"number":[NSString urlEncodedString:cardNumber], @"expMonth":[NSString urlEncodedString:expirationMonth], @"expYear": [NSString urlEncodedString:expirationYear], @"cvc": [NSString urlEncodedString:cvc]}];
    
    NSDictionary *tokenData = @{@"key": [NSString urlEncodedString:self.publicApiKey], @"card":cardData};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tokenData options:0 error:&jsonError];
    
    if (!jsonError) {

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        request.HTTPBody = jsonData;
        
        [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (!error) {
                NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
                if (httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode < 300) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    
                    cardTokenCompletionHandler([self cardTokenFromDictionary:json], nil);
                } else {
                    NSString *errorMessage = [NSString stringWithFormat:@"Bad Response: %d.", httpURLResponse.statusCode];
                    NSError *responseError = [NSError errorWithDomain:@"com.mastercard.simplify" code:SIMAPIManagerErrorCodeCardTokenResponseError userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                    error = responseError;
                    
                    cardTokenCompletionHandler(nil, &responseError);
                }
            }
        }];
    } else {
        cardTokenCompletionHandler(nil, &jsonError);
    }
    
}

- (NSString *)cardTokenFromDictionary:(NSDictionary *)jsonResponse {
    return jsonResponse[@"id"];
}

@end
