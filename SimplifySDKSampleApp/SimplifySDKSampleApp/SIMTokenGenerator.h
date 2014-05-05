#import <Foundation/Foundation.h>

@interface SIMTokenGenerator : NSObject

- (NSString *)createCardTokenWithCardNumber:(NSString *)cardNumber
                            expirationMonth:(NSString *)expirationMonth
                             expirationYear:(NSString *)expirationYear
                                        cvc:(NSString *)cvc
                                      error:(NSError **)error;
@end
