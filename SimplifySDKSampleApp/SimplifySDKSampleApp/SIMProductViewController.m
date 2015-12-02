#import "SIMProductViewController.h"
#import <PassKit/PassKit.h>
#import <Simplify/SIMSimplify.h>
#import <Simplify/SIMChargeCardViewController.h>
#import <Simplify/UIImage+Simplify.h>
#import <Simplify/UIColor+Simplify.h>
#import <Simplify/SIMResponseViewController.h>
#import <Simplify/SIMTokenProcessor.h>
#import <Simplify/SIMWaitingView.h>

//1. Sign up to be a SIMChargeViewControllerDelegate so that you get the callback that gives you a token
@interface SIMProductViewController ()<SIMChargeCardViewControllerDelegate>
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) UIColor *primaryColor;

@end

@implementation SIMProductViewController

#pragma mark - View lifeycycle

- (void)viewDidLoad{
    [super viewDidLoad];
    self.buyButton.backgroundColor = [UIColor buttonBackgroundColorEnabled];
    self.headerView.backgroundColor = [UIColor buttonBackgroundColorEnabled];
}

#pragma mark - UI setup

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)buySimplifyButton:(id)sender {
    
    PKPaymentSummaryItem *icedCoffee = [[PKPaymentSummaryItem alloc] init];
    icedCoffee.label = @"Iced Coffee";
    icedCoffee.amount = [NSDecimalNumber decimalNumberWithString:@"15.00"];
    
    PKPaymentRequest* paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    paymentRequest.countryCode = @"US";
    paymentRequest.currencyCode = @"USD";

    //2. SDKDemo.entitlements needs to be updated to use the new merchant id
    paymentRequest.merchantIdentifier = @"<#INSERT_YOUR_MERCHANT_ID_HERE#>";

    paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
    paymentRequest.paymentSummaryItems = @[icedCoffee];
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;

    //3. Create a SIMChargeViewController with your public api key

    SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithPublicKey:@"lvpb_<#INSERT_YOUR_PUBLIC_KEY_HERE#>" paymentRequest:paymentRequest primaryColor:self.primaryColor];
    
    //4. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    
    chargeController.delegate = self;
    chargeController.amount = icedCoffee.amount;
    
    //5. Specify requirements
    
    chargeController.isCVCRequired = YES;
    chargeController.isZipRequired = YES;

    //6.  Customize your charge card view controller interface colors and text
    
    //chargeController.paymentButtonNormalTitle = @"YOUR CUSTOM BUTTON TITLE";
    //chargeController.paymentButtonDisabledTitle = @"YOUR CUSTOM BUTTON TITLE";
    //chargeController.headerTitle = @"YOUR CUSTOM HEADER TITLE";
    //chargeController.headerTitleColor;
    //chargeController.headerViewBackgroundColor;
    //chargeController.paymentButtonDisabledColor;
    //chargeController.paymentButtonNormalColor;
    //chargeController.paymentButtonNormalTitleColor;
    //chargeController.paymentButtonDisabledTitleColor;

    //7. Add SIMChargeViewController to your view hierarchy
    
    self.chargeController = chargeController;
    [self presentViewController:self.chargeController animated:YES completion:nil];
}

#pragma mark - SIMChargeViewController delegate

-(void)chargeCardCancelled {
    
    //User cancelled the SIMChargeCardViewController
    [self.chargeController dismissViewControllerAnimated:YES completion:nil];
}

-(void)creditCardTokenFailedWithError:(NSError *)error {

    //There was a problem generating the token
    NSLog(@"Card Token Generation failed with error:%@", error);
    
    SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:NO title:@"Uh oh." description:@"Something went wrong with your order. If you really want to spend a bunch of money, go ahead and try that again." iconImage:nil backgroundImage:[UIImage imageNamed:@"coffeeCupEmptyFullBG" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]  tintColor:nil];
    viewController.buttonColor = [UIColor buttonBackgroundColorEnabled];
    viewController.buttonText = @"Try again";
    viewController.buttonTextColor = [UIColor whiteColor];
    
    //Further customize your response view controller interface colors and text
    //viewController.titleMessageColor;
    //viewController.titleDescriptionColor;
    
    //Example of a simpler response view controller
    viewController = [[SIMResponseViewController alloc]initWithSuccess:NO tintColor:[UIColor redColor]];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//6. This method will be called on your class whenever the user presses the Charge Card button and tokenization succeeds
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    //Token was generated successfully, now you must use it
    //Process Request on your own server
    //See https://github.com/simplifycom/simplify-php-server for a sample implementation.

    NSURL *url= [NSURL URLWithString:@"<#INSERT_YOUR_SIMPLIFY_SERVER_HERE#>"];
    
    SIMWaitingView *waitingView = [[SIMWaitingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:waitingView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"simplifyToken=%@&amount=1500", token.token];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *paymentTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [waitingView removeFromSuperview];
            
            if (error || ![responseObject[@"status"] isEqualToString:@"APPROVED"]) {

                NSLog(@"error:%@", error);
                
                SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:NO title:@"Uh oh." description:@"Something went wrong with your order. If you really want to spend a bunch of money, go ahead and try that again." iconImage:nil backgroundImage:[UIImage imageNamed:@"coffeeCupEmptyFullBG" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] tintColor:nil];
                viewController.buttonColor = [UIColor buttonBackgroundColorEnabled];
                viewController.buttonText = @"Try again";
                viewController.buttonTextColor = [UIColor whiteColor];
                [self presentViewController:viewController animated:YES completion:nil];
            } else {            
                SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:YES title:@"Cheers!" description:@"Thanks for your order.  While you wait, check out our famous \"Nickel Scones.\"" iconImage:nil backgroundImage:[UIImage imageNamed:@"coffeeCupFullBG" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] tintColor:nil];
                viewController.buttonColor = [UIColor buttonBackgroundColorEnabled];
                viewController.buttonText = @"Done";
                viewController.buttonTextColor = [UIColor whiteColor];
                
                //Example of a simpler response view controller
                //viewController = [[SIMResponseViewController alloc]initWithSuccess:YES tintColor:[UIColor orangeColor]];
                
                [self presentViewController:viewController animated:YES completion:nil];
            }
        });
    }];
    
    [paymentTask resume];
}

@end
