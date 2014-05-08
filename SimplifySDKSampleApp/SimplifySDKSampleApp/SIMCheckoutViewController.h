#import <Simplify/SIMCreditCardToken.h>

@protocol SIMCheckoutViewControllerDelegate

-(void)checkoutCancelled;
-(void)requestedCreditCardToken:(SIMCreditCardToken *)token withError:(NSError *)error;
-(void)requestedPaymentProcess:(NSString *)paymentID withError:(NSError *)error;

@end

@interface SIMCheckoutViewController : UIViewController

@property (nonatomic, weak) id <SIMCheckoutViewControllerDelegate> delegate;

@end
