#import "SIMAPIManager.h"
#import "NSString+Simplify.h"

typedef enum {
    SIMAPIManagerModeLive,
    SIMAPIManagerModeSandbox,
    SIMAPIManagerModeInvalid,
}SIMAPIManagerMode;

#define SIMAPIManagerPrefixLive @"lvpb_"
#define SIMAPIManagerPrefixSandbox @"sbpb_"

#define SIMAPIManagerErrorDomain @"com.mastercard.simplify.errordomain"

static NSString *prodAPILiveURL = @"https://api.simplify.com/v1/api";
static NSString *prodAPISandboxURL = @"https://sandbox.simplify.com/v1/api";

@interface SIMAPIManager () <NSURLSessionDelegate>

@property (nonatomic) BOOL isLiveMode;

@property (nonatomic) NSString *publicApiKey;
@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic) NSURL *currentAPIURL;

@end

@implementation SIMAPIManager

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    self.request = request;
    return [self initWithPublicApiKey:publicApiKey error:error urlRequest:request];
}

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **)error urlRequest:(NSMutableURLRequest *)request{
    self = [super init];
    
    if (self) {
        
        self.isLiveMode = [self isAPIKeyLiveMode:publicApiKey error:error];
        
        if (error) {
            return nil;
        } else {
            self.publicApiKey = publicApiKey;
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
        error = nil;
    } else if ([apiKey hasPrefix:SIMAPIManagerPrefixSandbox]){
        isLive = NO;
        error = nil;
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

    NSError *jsonSerializationError;
	NSURL *url = [self.currentAPIURL URLByAppendingPathComponent:@"payment/cardToken"];
    
    NSMutableDictionary *cardData = [NSMutableDictionary dictionaryWithDictionary:@{@"number":[NSString urlEncodedString:cardNumber], @"expMonth":[NSString urlEncodedString:expirationMonth], @"expYear": [NSString urlEncodedString:expirationYear], @"cvc": [NSString urlEncodedString:cvc]}];
    
    NSDictionary *tokenData = @{@"key": [NSString urlEncodedString:self.publicApiKey], @"card":cardData};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tokenData options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {

        self.request.HTTPBody = jsonData;
        [self.request setURL:url];

        
        [NSURLConnection sendAsynchronousRequest:self.request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;

            if (httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode < 300) {
                NSError *jsonDeserializationError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDeserializationError];
                
                cardTokenCompletionHandler([self cardTokenFromDictionary:json], nil);
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"Bad HTTP Response: %d.", httpURLResponse.statusCode];
                NSError *responseError = [NSError errorWithDomain:SIMAPIManagerErrorDomain code:SIMAPIManagerErrorCodeCardTokenResponseError userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                
                cardTokenCompletionHandler(nil, responseError);
            }
        }];

    } else {
        cardTokenCompletionHandler(nil, jsonSerializationError);
    }
    
}

- (NSString *)cardTokenFromDictionary:(NSDictionary *)jsonResponse {
    return jsonResponse[@"id"];
}

@end
