#import "SIMAddress.h"
#import "SIMCreditCardToken.h"

/**
 Enum for the error code if it is a card toke response error or a invalid API key error
 */
typedef enum {
    SIMAPIManagerErrorCodeCardTokenResponseError,
    SIMAPIManagerErrorCodeInvalidAPIKey
} SIMAPIManagerErrorCode;

/**
 Class that manages the API keys and the card token generation
 */
@interface SIMAPIManager : NSObject

/**
 Block that handles what to do with a card token and all errors
 @param cardToken If there is a JSON response, then the card token is created and sent from that
 @param error If there is an error, it is sent here so that it can be handled elsewhere
 */
typedef void (^CardTokenCompletionHandler)(SIMCreditCardToken *cardToken, NSError *error);

@property (nonatomic, readonly) BOOL isLiveMode;  /**< No if in sandbox mode, determined by publicApiKey */

/**
 Creates an instance of the SIMAPIManager class
 @param publicApiKey is the public API key from the Simplify Commerce account
 @param error is the mode error if the API key was invalid
 */
-(instancetype)initWithApiKey:(NSString *)apiKey error:(NSError **) error;

/**
 Creates a token from credit card details and a completion handler
 @param expirationMonth is expiration month of the card. Format is MM.
 @param expirationYear is expiration year of the card. Format is YY. Example: 2013 = 13
 @param cardNumber is the card number string that should only be digits
 @param cvc is the 3-4 digit CVC code on the back of the card
 @param address is a SIMAddress object with address information of the cardholder
 @param completionHandler is a block that is excuted after the create token call is made.  It can deal with an error or deal with a token if it has one.
 */
-(void)createCardTokenWithExpirationMonth:(NSString *)expirationMonth expirationYear:(NSString *)expirationYear
        cardNumber:(NSString *)cardNumber cvc:(NSString *)cvc address:(SIMAddress *)address completionHander:(CardTokenCompletionHandler)cardTokenCompletionHandler;
@end
