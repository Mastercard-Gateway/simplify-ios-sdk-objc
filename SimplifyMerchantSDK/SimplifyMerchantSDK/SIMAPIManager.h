#import "SIMCreditCardToken.h"

typedef enum {
    SIMAPIManagerErrorCodeCardTokenResponseError,
    SIMAPIManagerErrorCodeInvalidAPIKey
} SIMAPIManagerErrorCode;

@interface SIMAPIManager : NSObject

typedef void (^CardTokenCompletionHandler)(SIMCreditCardToken *cardToken, NSError *error);

@property (nonatomic, readonly) BOOL isLiveMode;

- (instancetype)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error;

- (void)createCardTokenWithExpirationMonth:(NSString *)expirationMonth
                                  expirationYear:(NSString *)expirationYear
                                      cardNumber:(NSString *)cardNumber
                                             cvc:(NSString *)cvc
                                completionHander:(CardTokenCompletionHandler)cardTokenCompletionHandler;
@end
