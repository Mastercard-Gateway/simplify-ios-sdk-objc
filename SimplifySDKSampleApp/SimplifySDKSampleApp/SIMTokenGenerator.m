#import "SIMTokenGenerator.h"
@interface  SIMTokenGenerator ()
@property (nonatomic, strong) NSString *publicApiToken;
@end

@implementation SIMTokenGenerator

-(instancetype)init {
    if (self) {
        self.publicApiToken = @"sbpb_NjA4YmFkZGYtYjE0NC00YTNiLTlhNjMtYjNiNTlhYTVjMGYy";
    }
    return self;
}

- (NSString *)createCardTokenWithCardNumber:(NSString *)cardNumber
                            expirationMonth:(NSString *)expirationMonth
                             expirationYear:(NSString *)expirationYear
                                        cvc:(NSString *)cvc
                                      error:(NSError **)error {
	NSString *cardToken = nil;
    
	NSURL *url = [[[NSURL alloc] initWithString:@"https://sandbox.simplify.com/v1/api/"] URLByAppendingPathComponent:@"payment/cardToken"];
    
    NSMutableDictionary *addressData = [NSMutableDictionary dictionaryWithDictionary:@{@"number":cardNumber, @"expMonth":expirationMonth, @"expYear": expirationYear, @"cvc": cvc}];
    
    NSDictionary *cardData = @{@"key": self.publicApiToken, @"card":addressData};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:cardData options:0 error:error];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = jsonData;
    
	request.HTTPMethod = @"POST";
    
//	if (!*error) {
//		NSHTTPURLResponse *response = nil;
//		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
//		if (!*error) {
//			if (response.statusCode >= 200 && response.statusCode < 300) {
//                NSLog(@"response: %@", [[NSString alloc] initWithData:data
//                                                             encoding:NSUTF8StringEncoding]);
//				NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
//				cardToken = [SIMCreditCardToken cardTokenFromDictionary:json];
//			} else {
//				NSString *errorMessage = [NSString stringWithFormat:@"Received bad status code of: %d. Expected between 200-299", response.statusCode];
//				NSError *newError = [NSError errorWithDomain:@"com.simplify.simplifysdksampleapp" code:1 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
//				*error = newError;
//			}
//		}
//	}
	return cardToken;
}
@end
