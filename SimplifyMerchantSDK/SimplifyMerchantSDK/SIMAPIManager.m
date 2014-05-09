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

typedef void (^PrinterBlock)(NSString*);

typedef void (^SimplifyApiCompletionHandler)(NSDictionary *jsonResponse, NSError *error);

@property (nonatomic) BOOL isLiveMode;

@property (nonatomic) NSString *publicApiKey;
@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic) NSURL *currentAPIURL;

@end

@implementation SIMAPIManager

-(id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **)error{
    self = [super init];
    
    if (self) {
        
        NSError *modeError;
        self.isLiveMode = [self isAPIKeyLiveMode:publicApiKey error:&modeError];
        
        if (modeError) {
            if(error != NULL) *error = modeError;
            return nil;
        } else {
            self.publicApiKey = publicApiKey;
            NSString *apiURLString = (self.isLiveMode) ? prodAPILiveURL : prodAPISandboxURL;
            self.currentAPIURL = [NSURL URLWithString:apiURLString];
            [self.request setURL:self.currentAPIURL];
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
        if(error != NULL) *error = [NSError errorWithDomain:SIMAPIManagerErrorDomain code:SIMAPIManagerErrorCodeInvalidAPIKey userInfo:userInfo];
    }
    
    return isLive;
    
}

-(void)createCardTokenWithExpirationMonth:(NSString *)expirationMonth expirationYear:(NSString *)expirationYear
                                cardNumber:(NSString *)cardNumber cvc:(NSString *)cvc address:(SIMAddress *)address completionHander:(CardTokenCompletionHandler)cardTokenCompletionHandler {

    NSError *jsonSerializationError;
	NSURL *url = [self.currentAPIURL URLByAppendingPathComponent:@"payment/cardToken"];
    
    NSString *safeCardNumber = cardNumber ? cardNumber : @"";
    NSString *safeExpMonth = expirationMonth ? expirationMonth : @"";
    NSString *safeExpYear = expirationYear ? expirationYear : @"";
    NSString *safeCvc = cvc ? cvc : @"";
    
    NSMutableDictionary *cardData = [NSMutableDictionary dictionaryWithDictionary:@{@"number":[NSString urlEncodedString:safeCardNumber], @"expMonth":[NSString urlEncodedString:safeExpMonth], @"expYear": [NSString urlEncodedString:safeExpYear], @"cvc": [NSString urlEncodedString:safeCvc]}];
    
    if (address.name.length) {
        cardData[@"name"] = address.name;
	}
	if (address.addressLine1.length) {
        cardData[@"addressLine1"] = address.addressLine1;
	}
	if (address.addressLine2.length) {
        cardData[@"addressLine2"] = address.addressLine2;
	}
	if (address.city.length) {
        cardData[@"addressCity"] = address.city;
	}
	if (address.state.length) {
        cardData[@"addressState"] = address.state;
    }
	if (address.zip.length) {
        cardData[@"addressZip"] = address.zip;
	}
	if (address.country.length) {
        cardData[@"addressCountry"] = address.country;
	}
    
    NSDictionary *tokenData = @{@"key": [NSString urlEncodedString:self.publicApiKey], @"card":cardData};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tokenData options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        
        SimplifyApiCompletionHandler apiCompletionHander = ^(NSDictionary *jsonResponse, NSError *error) {
            
            cardTokenCompletionHandler([SIMCreditCardToken cardTokenFromDictionary:jsonResponse], nil);
        };
        
        [self performRequestWithData:jsonData url:url completionHander:apiCompletionHander];

    } else {
        cardTokenCompletionHandler(nil, jsonSerializationError);
    }
    
}

-(void)performRequestWithData:(NSData *)jsonData url:(NSURL *)url completionHander:(SimplifyApiCompletionHandler)apiCompletionHandler{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    self.request = request;
    
    self.request.HTTPBody = jsonData;
    [self.request setURL:url];
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        
        if (httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode < 300) {
            NSError *jsonDeserializationError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDeserializationError];
            
            apiCompletionHandler(json, nil);
            
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"Bad HTTP Response: %d.", httpURLResponse.statusCode];
            NSError *responseError = [NSError errorWithDomain:SIMAPIManagerErrorDomain code:SIMAPIManagerErrorCodeCardTokenResponseError userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
            
            apiCompletionHandler(nil, responseError);
        }
    }];
}


@end
