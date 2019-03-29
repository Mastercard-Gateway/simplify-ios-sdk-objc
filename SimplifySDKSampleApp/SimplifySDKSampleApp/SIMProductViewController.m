#import "SIMProductViewController.h"
#import <PassKit/PassKit.h>
#import <Simplify/SIMSimplify.h>
#import <Simplify/SIMChargeCardViewController.h>
#import <Simplify/UIImage+Simplify.h>
#import <Simplify/UIColor+Simplify.h>
#import <Simplify/SIMResponseViewController.h>
#import <Simplify/SIMTokenProcessor.h>
#import <Simplify/SIMWaitingView.h>
#import <Simplify/SIM3DSWebViewController.h>

//1. Sign up to be a SIMChargeViewControllerDelegate so that you get the callback that gives you a token
@interface SIMProductViewController ()<SIMChargeCardViewControllerDelegate, SIM3DSWebViewControllerDelegate>
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) SIMCreditCardToken *secure3DCardToken;
@property (strong, nonatomic) SIMWaitingView *waitingView;

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
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkDiscover, PKPaymentNetworkMasterCard, PKPaymentNetworkPrivateLabel, PKPaymentNetworkVisa];
    paymentRequest.countryCode = @"US";
    paymentRequest.currencyCode = @"USD";

    //2. SDKDemo.entitlements needs to be updated to use the new merchant id
    paymentRequest.merchantIdentifier = @"<#INSERT_YOUR_APPLE_MERCHANT_ID_HERE#>";

    paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
    paymentRequest.paymentSummaryItems = @[icedCoffee];
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;

    //3. Create a SIMChargeViewController with your public api key

    //TODO: Put back & comment out the new 3DS 1.0 flow
    
//    SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithPublicKey:@"lvpb_<#INSERT_YOUR_PUBLIC_KEY_HERE#>" paymentRequest:paymentRequest primaryColor:self.primaryColor];
    
    //To use process 3DS 1.0 transactions use
    SIM3DSecureRequestData *threeDSRequest = [[SIM3DSecureRequestData alloc] initWithAmount:[NSDecimalNumber decimalNumberWithString:@"200.00"] currency:@"AUD" description:@"Test"];
    SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithPublicKey:@"lvpb_YmMzMzUyNGQtMzczNy00MDNhLWEyZmItZDcyZGYwODc4NmQw" threeDSecureRequest:threeDSRequest primaryColor:self.primaryColor];
    
    //4. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    
    chargeController.delegate = self;
    chargeController.amount = icedCoffee.amount;
    
    //5. Specify requirements
    
    chargeController.isCVCRequired = YES;
    chargeController.isZipRequired = NO;

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
    //viewController = [[SIMResponseViewController alloc]initWithSuccess:NO tintColor:[UIColor redColor]];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//6. This method will be called on your class whenever the user presses the Charge Card button and tokenization succeeds
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    [self presentLoading];
    if (token.threeDSecureData && token.threeDSecureData.isEnrolled) {
        
        //Keep reference to token for after auth
        self.secure3DCardToken = token;
        
        SIM3DSWebViewController *webview = [[SIM3DSWebViewController alloc] initWithNibName:nil bundle:nil];
        webview.delegate = self;
        [self presentViewController:webview animated:YES completion:nil];
        [webview authenticateCardHolderWithSecureData:token.threeDSecureData];
    } else {
        //Token was generated successfully, now you must use it to
        //Process Request on your own server
        //See https://github.com/simplifycom/simplify-php-server for a sample implementation.
        [self createTransactionWithCardToken:token];
    }
}

#pragma mark - SIM3DSWebViewController delegate

- (void)acsAuthCanceled {
    self.secure3DCardToken = nil;
    [self presentFailure];
}

- (void)acsAuthError:(NSError *)error {
    self.secure3DCardToken = nil;
     [self presentFailure];
}

- (void)acsAuthResult:(NSString *)acsResult {
    //Proceed with creating transaction with Card Token
    [self createTransactionWithCardToken:self.secure3DCardToken];
    self.secure3DCardToken = nil;
}

#pragma mark - Token submission to process payment
-(void)createTransactionWithCardToken:(SIMCreditCardToken *)cardToken {
//    NSURL *url= [NSURL URLWithString:@"<#INSERT_YOUR_SIMPLIFY_SERVER_HERE#>"];
    NSURL *url= [NSURL URLWithString:@"https://young-chamber-23463.herokuapp.com/charge.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"simplifyToken=%@&amount=1500", cardToken.token];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *paymentTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
            if (data) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                    if (error || ![responseObject[@"status"] isEqualToString:@"APPROVED"]) {
            
                            NSLog(@"Response Error:%@", error);
                            [self presentFailure];
                        } else {
                            [self presentSuccess];
                        }
            } else {
                NSLog(@"Other Error:%@", error);
                [self presentFailure];
            }
        }];
    
        [paymentTask resume];
}


#pragma mark - Present Screens
-(void)presentLoading {
    if (!self.waitingView) {
        self.waitingView = [[SIMWaitingView alloc] initWithFrame:self.view.frame];
        [self.view addSubview: self.waitingView];
    }
}

-(void)removeLoading {
    if (self.waitingView) {
        [self.waitingView removeFromSuperview];
    }
}

-(void)presentSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeLoading];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:YES title:@"Cheers!" description:@"Thanks for your order.  While you wait, check out our famous \"Nickel Scones.\"" iconImage:nil backgroundImage:[UIImage imageNamed:@"coffeeCupFullBG" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] tintColor:nil];
        viewController.buttonColor = [UIColor buttonBackgroundColorEnabled];
        viewController.buttonText = @"Done";
        viewController.buttonTextColor = [UIColor whiteColor];
        
        //Example of a simpler response view controller
        //viewController = [[SIMResponseViewController alloc]initWithSuccess:YES tintColor:[UIColor orangeColor]];
        
        [self presentViewController:viewController animated:YES completion:nil];
    });
}

-(void)presentFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeLoading];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:NO title:@"Uh oh." description:@"Something went wrong with your order. If you really want to spend a bunch of money, go ahead and try that again." iconImage:nil backgroundImage:[UIImage imageNamed:@"coffeeCupEmptyFullBG" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] tintColor:nil];
        viewController.buttonColor = [UIColor buttonBackgroundColorEnabled];
        viewController.buttonText = @"Try again";
        viewController.buttonTextColor = [UIColor whiteColor];
        [self presentViewController:viewController animated:YES completion:nil];
    });
}

@end
