#import <Simplify/SIMCreditCardToken.h>

@protocol SIMChargeCardViewControllerDelegate

-(void)chargeCardCancelled;
-(void)requestedCreditCardToken:(SIMCreditCardToken *)token withError:(NSError *)error;
-(void)requestedPaymentProcess:(NSString *)paymentID withError:(NSError *)error;

@end

@interface SIMChargeCardViewController : UIViewController

@property (nonatomic, weak) id <SIMChargeCardViewControllerDelegate> delegate;

@end
