#import <PassKit/PassKit.h>
#import "SIMCreditCardToken.h"
#import "SIMSimplify.h"

@interface SIMTokenProcessor : NSObject

+(NSData *) formatDataForRequestWithKey:(NSString *)publicKey withPayment:(PKPayment *)payment error:(NSError *)error;

@end