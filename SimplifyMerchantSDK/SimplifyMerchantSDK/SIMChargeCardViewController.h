#import <UIKit/UIKit.h>
#import "SIMCreditCardToken.h"

@protocol SIMChargeCardViewControllerDelegate

-(void)chargeCardCancelled;
-(void)creditCardTokenFailedWithError:(NSError *)error;
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token;

@end

/**
 View Controller that has a SIMChargeCardModel that validates the three fields: credit card number, expiration date, and CVC code
 */
@interface SIMChargeCardViewController : UIViewController

-(instancetype)initWithApiKey:(NSString *)apiKey;

@property (nonatomic, weak) id <SIMChargeCardViewControllerDelegate> delegate; /**< Delegate for SIMChargeCardModelDelegate */

@end
