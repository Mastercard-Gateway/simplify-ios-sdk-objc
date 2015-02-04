#import "SIMProductViewController.h"
#import <PassKit/PassKit.h>
#import <Simplify/SIMSimplify.h>
#import <Simplify/SIMChargeCardViewController.h>
#import <Simplify/SIMButton.h>
#import <Simplify/UIImage+Simplify.h>
#import <Simplify/UIColor+Simplify.h>
#import <Simplify/SIMResponseViewController.h>
#import <Simplify/SIMTokenProcessor.h>

//1. Sign up to be a SIMChargeViewControllerDelegate so that you get the callback that gives you a token
@interface SIMProductViewController ()<SIMChargeCardViewControllerDelegate>
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (strong, nonatomic) IBOutlet SIMButton *buyButton;
@property (strong, nonatomic) IBOutlet UIView *productView;
@property (strong, nonatomic) IBOutlet UIView *buyButtonView;
@property (strong, nonatomic) UIColor *primaryColor;
@end

@implementation SIMProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.primaryColor = [UIColor colorWithRed:241.0/255.0 green:100.0/255.0 blue:33.0/255.0 alpha:1.0];
    self.buyButton.primaryColor = self.primaryColor;
    [[self.buyButton layer] setCornerRadius:8.0];
    [[self.productView layer] setCornerRadius:8.0];
    [[self.buyButtonView layer] setCornerRadius:8.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Navigation
- (IBAction)buySimplifyButton:(id)sender {
    
        PKPaymentSummaryItem *mposButtons = [[PKPaymentSummaryItem alloc] init];
        mposButtons.label = @"mPOS Buttons";
        mposButtons.amount = [[NSDecimalNumber alloc] initWithString:@"10.00"];
        
        PKPaymentRequest* paymentRequest = [[PKPaymentRequest alloc] init];
        paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        paymentRequest.countryCode = @"US";
        paymentRequest.currencyCode = @"USD";

        //2. SDKDemo.entitlements needs to be updated to use the new merchant id
        paymentRequest.merchantIdentifier = @"<#Your merchant id#>";
        paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
        paymentRequest.paymentSummaryItems = @[mposButtons];
        paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
        paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;

        //3. Create a SIMChargeViewController with your public api key
        SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithPublicKey:@"lvpb_<#INSERT_YOUR_PUBLIC_KEY_HERE#>" paymentRequest:paymentRequest primaryColor:self.primaryColor];
    
        //4. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
        chargeController.delegate = self;
        self.chargeController = chargeController;

        //5. Add SIMChargeViewController to your view hierarchy
        [self presentViewController:self.chargeController animated:YES completion:nil];
    
}

#pragma mark - SIMChargeViewController Protocol
-(void)chargeCardCancelled {
    //User cancelled the SIMChargeCardViewController
    
    [self.chargeController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"User Cancelled");
}

-(void)creditCardTokenFailedWithError:(NSError *)error {

    //There was a problem generating the token

    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);
    UIImageView *blurredView = [UIImage blurImage:self.view.layer];
    SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:self.primaryColor title:@"Failure." description:@"There was a problem with the payment.\nPlease try again."];
    [self presentViewController:viewController animated:YES completion:nil];
}

//6. This method will be called on your class whenever the user presses the Charge Card button and tokenization succeeds
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    //Token was generated successfully, now you must use it
    
    NSURL *url= [NSURL URLWithString:@"https://Your_server/charge.rb"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"simplifyToken=";
    
    postString = [postString stringByAppendingString:token.token];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    
    //Process Request on your own server
    //See https://github.com/simplifycom/simplify-php-server for a sample implementation.
    
    if (error) {
        NSLog(@"error:%@", error);
        UIImageView *blurredView = [UIImage blurImage:self.view.layer];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:self.primaryColor title:@"Failure." description:@"There was a problem with the payment.\nPlease try again."];
        [self presentViewController:viewController animated:YES completion:nil];

    } else {
        
        UIImageView *blurredView = [UIImage blurImage:self.view.layer];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:self.primaryColor title:@"Success!" description:@"You purchased a pack of buttons!"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

@end
