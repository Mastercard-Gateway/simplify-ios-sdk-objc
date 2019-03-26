#import "SIMSimplify.h"
#import "NSString+Simplify.h"
#import "NSBundle+Simplify.h"
#import <UIKit/UIKit.h>
#import "SIMTokenProcessor.h"
#import "SIM3DSecureRequestData.h"

typedef enum {
    SIMSimplifyModeLive,
    SIMSimplifyModeSandbox,
    SIMSimplifyModeInvalid,
}SIMSimplifyMode;

#define SIMSimplifyPrefixLive @"lvpb_"
#define SIMSimplifyPrefixSandbox @"sbpb_"
#define SIMSimplifyErrorDescription @"Simplify SDK Error - "

#define SIMSimplifyErrorDomain [NSString stringWithFormat:@"%@.errordomain", [[NSBundle frameworkBundle] bundleIdentifier]]

static NSString *prodAPILiveURL = @"https://api.simplify.com/v1/api";
static NSString *prodAPISandboxURL = @"https://sandbox.simplify.com/v1/api";
static NSString *endpointCardToken = @"payment/cardToken";

@interface SIMSimplify ()

typedef void (^SimplifyApiCompletionHandler)(NSDictionary *jsonResponse, NSError *error);

@property (nonatomic) BOOL isLiveMode;

@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic) NSURL *currentAPIURL;

@end

@implementation SIMSimplify

-(instancetype)initWithPublicKey:(NSString *)publicKey error:(NSError **)error{
    self = [super init];
    
    if (self) {
        
        NSError *modeError;
        self.isLiveMode = [self isPublicKeyLiveMode:publicKey error:&modeError];
        
        if (modeError) {
            if(error != NULL) *error = modeError;
            return nil;
        } else {
            self.publicKey = publicKey;
            NSString *apiURLString = (self.isLiveMode) ? prodAPILiveURL : prodAPISandboxURL;
            //TODO: Put back to: self.currentAPIURL = [NSURL URLWithString:apiURLString];
            self.currentAPIURL = [NSURL URLWithString:@"https://api.uat.simplify.com/v1/api"];
            [self.request setURL:self.currentAPIURL];
        }
                
    }

    return self;
}

-(BOOL)isPublicKeyLiveMode:(NSString *)publicKey error:(NSError **) error{

    BOOL isLive = YES;
    
    if ([publicKey hasPrefix:SIMSimplifyPrefixLive]) {
        isLive = YES;
    } else if ([publicKey hasPrefix:SIMSimplifyPrefixSandbox]){
        isLive = NO;
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not create Simplify: Invalid Public Key."};
        if(error != NULL) {
            *error = [NSError errorWithDomain:SIMSimplifyErrorDomain code:SIMSimplifyErrorCodeInvalidPublicKey userInfo:userInfo];
            NSLog(@"%@%@", SIMSimplifyErrorDescription, *error);
        }
    }
    
    return isLive;
    
}

-(void)createCardTokenWithExpirationMonth:(NSString *)expirationMonth expirationYear:(NSString *)expirationYear
                               cardNumber:(NSString *)cardNumber cvc:(NSString *)cvc address:(SIMAddress *)address threeDSData:(SIM3DSecureRequestData *)threeDSData completionHander:(CardTokenCompletionHandler)cardTokenCompletionHandler {

    NSError *jsonSerializationError;
	NSURL *url = [self.currentAPIURL URLByAppendingPathComponent:endpointCardToken];
    
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
    
    NSMutableDictionary *threeDSRequest = [NSMutableDictionary dictionaryWithDictionary:@{}];
    if (threeDSData.amount) {
        threeDSRequest[@"amount"] = threeDSData.amount;
    }

    if (threeDSData.descriptionMessage.length) {
        threeDSRequest[@"description"] = threeDSData.descriptionMessage;
    }

    if (threeDSData.currency.length) {
        threeDSRequest[@"currency"] = threeDSData.currency;
    }
    
    NSMutableDictionary *tokenData = [NSMutableDictionary dictionaryWithDictionary:@{@"key": [NSString urlEncodedString:self.publicKey], @"card":cardData}];
    if (threeDSRequest.allKeys.count) {
        tokenData[@"secure3DRequestData"] = threeDSRequest;
    }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tokenData options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        
        SimplifyApiCompletionHandler apiCompletionHander = ^(NSDictionary *jsonResponse, NSError *error) {
            
            cardTokenCompletionHandler([SIMCreditCardToken cardTokenFromDictionary:jsonResponse], error);
        };
        
        [self performRequestWithData:jsonData url:url completionHander:apiCompletionHander];

    } else {
        cardTokenCompletionHandler(nil, jsonSerializationError);
    }
    
}

-(void)createCardTokenWithPayment:(PKPayment *)payment completionHandler:(CardTokenCompletionHandler)cardTokenCompletionHandler {
    NSError *jsonSerializationError;
    NSURL *url = [self.currentAPIURL URLByAppendingPathComponent:endpointCardToken];
    NSData* jsonData = [SIMTokenProcessor formatDataForRequestWithKey:self.publicKey withPayment:payment error:jsonSerializationError];
    if (!jsonSerializationError) {
        
        SimplifyApiCompletionHandler apiCompletionHander = ^(NSDictionary *jsonResponse, NSError *error) {
            
            cardTokenCompletionHandler([SIMCreditCardToken cardTokenFromDictionary:jsonResponse], error);
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
    
    NSString *currentVersion = [[[NSBundle frameworkBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *userAgent = [NSString stringWithFormat:@"iOS-SDK/%@", currentVersion];
    [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    self.request = request;
    
    self.request.HTTPBody = jsonData;
    [self.request setURL:url];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
                   
    [NSURLConnection sendAsynchronousRequest:self.request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        
        if (httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode < 300) {
            NSError *jsonDeserializationError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDeserializationError];
            
            apiCompletionHandler(json, nil);
            
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"Bad HTTP Response: %ld.", (long)httpURLResponse.statusCode];
            NSError *responseError = [NSError errorWithDomain:SIMSimplifyErrorDomain code:SIMSimplifyErrorCodeCardTokenResponseError userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
            
            NSLog(@"%@%@", SIMSimplifyErrorDescription, responseError);
            
            apiCompletionHandler(nil, responseError);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });

    }];
}


@end
