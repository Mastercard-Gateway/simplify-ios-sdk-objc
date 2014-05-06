typedef enum {
    SIMAPIManagerErrorCodeCardTokenResponseError,
    SIMAPIManagerErrorCodeInvalidAPIKey
} SIMAPIManagerErrorCode;

@interface SIMAPIManager : NSObject

typedef void (^ CardTokenCompletionHandler)(NSString *cardToken, NSError **error);

@property (nonatomic, readonly) BOOL isLiveMode;

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error;

- (void)createCardTokenWithExpirationMonth:(NSString *)expirationMonth
                                  expirationYear:(NSString *)expirationYear
                                      cardNumber:(NSString *)cardNumber
                                             cvc:(NSString *)cvc
                                completionHander:(CardTokenCompletionHandler)cardTokenCompletionHandler;
@end
