#import <PassKit/PassKit.h>
#import "SIMCreditCardToken.h"

@interface SIMTokenProcessor : NSObject

-(void) convertToSimplifyToken:(PKPaymentToken *) paymentToken withKey:(NSString *) publicKey completiion:(void (^)(SIMCreditCardToken *creditCardToken)) response;

@end