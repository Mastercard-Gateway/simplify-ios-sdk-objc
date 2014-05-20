#import <UIKit/UIKit.h>
#import "SIMCreditCardToken.h"

/**
 Public Protocol for communicating success or failure of the token generation.
 */

@protocol SIMChargeCardViewControllerDelegate

/**
 Token cancel Callback. The User has elected to cancel the token generation workflow.
 */
-(void)chargeCardCancelled;

/**
 Token failure Callback. If token generation fails, this will be called back and an error will be provided with a localizedDescription and code.
 */
-(void)creditCardTokenFailedWithError:(NSError *)error;

/**
 Token success Callback. If token generation succeeds, this will be called back and the fully hydrated credit card token.
 */
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token;

@end

/**
 View Controller that has a SIMChargeCardModel that validates the three fields: credit card number, expiration date, and CVC code
 */
@interface SIMChargeCardViewController : UIViewController

-(instancetype)initWithPublicKey:(NSString *)publicKey;
-(instancetype)initWithPublicKey:(NSString *)publicKey primaryColor:(UIColor *)primaryColor;

@property (nonatomic, weak) id <SIMChargeCardViewControllerDelegate> delegate; /**< Delegate for SIMChargeCardModelDelegate */

@end
