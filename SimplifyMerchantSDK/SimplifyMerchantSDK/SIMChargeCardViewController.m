#import "SIMChargeCardViewController.h"
#import "SIMChargeCardModel.h"
#import "UIColor+Simplify.h"
#import "UIImage+Simplify.h"
#import "NSBundle+Simplify.h"
#import "SIMResponseViewController.h"

@interface SIMChargeCardViewController () <SIMChargeCardModelDelegate, UITextFieldDelegate, PKPaymentAuthorizationViewControllerDelegate>
@property (strong, nonatomic) SIMChargeCardModel *chargeCardModel;
@property (strong, nonatomic) NSString *publicKey;
@property (strong, nonatomic) NSError *modelError;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *chargeCardButton;
@property (strong, nonatomic) IBOutlet UITextField *cardNumberField;
@property (strong, nonatomic) IBOutlet UITextField *expirationField;
@property (strong, nonatomic) IBOutlet UITextField *cvcField;
@property (strong, nonatomic) IBOutlet UITextField *zipField;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (strong, nonatomic) IBOutlet UIView *cvcCodeView;
@property (strong, nonatomic) IBOutlet UIView *cardNumberView;
@property (strong, nonatomic) IBOutlet UIView *expirationDateView;
@property (strong, nonatomic) IBOutlet UIView *applePayViewHolder;
@property (strong, nonatomic) IBOutlet UIView *cardEntryView;
@property (strong, nonatomic) IBOutlet UIView *zipCodeView;
@property (strong, nonatomic) PKPaymentRequest *paymentRequest;

@end

@implementation SIMChargeCardViewController

-(instancetype)initWithPublicKey:(NSString *)publicKey {
    return [self initWithPublicKey:publicKey primaryColor:nil];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey primaryColor:(UIColor *)primaryColor {
    return [self initWithPublicKey:publicKey paymentRequest:nil primaryColor:primaryColor];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey paymentRequest:(PKPaymentRequest *)paymentRequest {
    return [self initWithPublicKey:publicKey paymentRequest:paymentRequest primaryColor:nil];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey paymentRequest:(PKPaymentRequest *)paymentRequest primaryColor:(UIColor *)primaryColor {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        self.publicKey = publicKey;
        self.primaryColor = primaryColor ? primaryColor : [UIColor buttonBackgroundColorEnabled];
        self.paymentRequest = paymentRequest;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return  self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
 
    self.cardNumberField.delegate = self;
    self.expirationField.delegate = self;
    self.cvcField.delegate = self;
    self.zipField.delegate = self;
    
    self.cardNumberField.tintColor = self.primaryColor;
    self.expirationField.tintColor = self.primaryColor;
    self.cvcField.tintColor = self.primaryColor;
    self.zipField.tintColor = self.primaryColor;
    
    NSError *error;
    self.chargeCardModel = [[SIMChargeCardModel alloc] initWithPublicKey:self.publicKey error:&error];
    self.chargeCardModel.isZipRequired = YES;
    self.chargeCardModel.isCVCRequired = YES;
    
    if (error) {
        self.modelError = error;
    } else {
        self.chargeCardModel.delegate = self;

        [self setCardTypeImage];
        [self buttonEnabled];
        [self.cardNumberField becomeFirstResponder];
    }
    
    //Remove the Apple Pay button if there is no PKPaymentRequest or if the device is not capable of doing Apple Pay
    if (!self.paymentRequest || ![PKPaymentAuthorizationViewController canMakePayments]) {
        self.applePayViewHolder.hidden = YES;
        [self.applePayViewHolder removeFromSuperview];
    }

}

-(void)viewDidAppear:(BOOL)animated {
    if (self.modelError) {

        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:nil primaryColor:self.primaryColor title:@"Failure." description:@"\n\nThere was a problem with your Public Key.\n\nPlease double-check your Public Key and try again."];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)buttonEnabled {
    
    UIColor *cardBackgroundColor = [UIColor whiteColor];
    UIColor *dateBackgroundColor = [UIColor whiteColor];
    UIColor *cvcBackgroundColor = [UIColor whiteColor];
    UIColor *zipBackgroundColor = [UIColor whiteColor];
    
    if (self.chargeCardModel.cardNumber.length > 0) {
        if ([self.chargeCardModel isCardNumberValid]) {
            cardBackgroundColor = [UIColor fieldBackgroundColorValid];
            
//            if (![self.chargeCardModel isExpirationDateValid]) {
//                [self.expirationField becomeFirstResponder];
//            }
            
        } else {
            cardBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    if (self.chargeCardModel.expirationDate.length > 0) {
        if ([self.chargeCardModel isExpirationDateValid]) {
            dateBackgroundColor = [UIColor fieldBackgroundColorValid];

//            if (![self.chargeCardModel isCVCCodeValid]) {
//                [self.cvcCodeView becomeFirstResponder];
//            }
            
        } else {
            dateBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    if (self.chargeCardModel.cvcCode.length > 0) {
        if ([self.chargeCardModel isCVCCodeValid]) {
            cvcBackgroundColor = [UIColor fieldBackgroundColorValid];

//            if (![self.chargeCardModel isZipCodeValid]) {
//                [self.zipField becomeFirstResponder];
//            }
            
        } else {
            cvcBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    if (self.chargeCardModel.zipCode.length > 0) {
        if ([self.chargeCardModel isZipCodeValid]) {
            zipBackgroundColor = [UIColor fieldBackgroundColorValid];
        } else {
            zipBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    self.cardNumberView.backgroundColor = cardBackgroundColor;
    self.expirationDateView.backgroundColor = dateBackgroundColor;
    self.cvcCodeView.backgroundColor = cvcBackgroundColor;
    self.zipCodeView.backgroundColor = zipBackgroundColor;
    BOOL isEnabled = [self.chargeCardModel isCardChargePossible];
    [self.chargeCardButton setEnabled:isEnabled];
    
    if (isEnabled) {
        [self.chargeCardButton setBackgroundColor:self.primaryColor ? self.primaryColor : [UIColor buttonBackgroundColorEnabled]];
    } else {
        [self.chargeCardButton setBackgroundColor:[UIColor buttonBackgroundColorDisabled]];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.cardNumberField) {
        if (string.length == 0) {
            [self.chargeCardModel deleteCharacterInCardNumber];
        } else {
            [self.chargeCardModel updateCardNumberWithString:newString];
        }
        self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
        [self setCardTypeImage];
    }
    
    else if (textField == self.cvcField) {
        [self.chargeCardModel updateCVCNumberWithString:newString];
        self.cvcField.text = self.chargeCardModel.cvcCode;
    }
    
    else if (textField == self.expirationField) {
        if (string.length == 0) {
            [self.chargeCardModel deleteCharacterInExpiration];
        } else {
            [self.chargeCardModel updateExpirationDateWithString:newString];
        }
        self.expirationField.text = self.chargeCardModel.formattedExpirationDate;
    } else if (textField == self.zipField) {
        [self.chargeCardModel updateZipCodeWithString:newString];
        self.zipField.text = self.chargeCardModel.zipCode;
    }
    
    [self buttonEnabled];

    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == self.cardNumberField) {
        [self.chargeCardModel updateCardNumberWithString:@""];
        [self setCardTypeImage];
    }
    
    else if (textField == self.cvcField) {
        [self.chargeCardModel updateCVCNumberWithString:@""];
    }
    
    else if (textField == self.expirationField) {
        [self.chargeCardModel updateExpirationDateWithString:@""];
    }
    
    [self buttonEnabled];
    
    return YES;
}

-(void)setCardTypeImage {
    
    UIImage *cardImage = [UIImage imageNamed:self.chargeCardModel.cardTypeString inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil];
    [self.cardTypeImage setImage:cardImage];
}

- (IBAction)cancelTokenRequest:(id)sender {
    [self clearTextFields];

    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate chargeCardCancelled];
    }];
}

-(IBAction)retrieveToken:(id)sender {
    [self.chargeCardModel retrieveToken];
}

-(IBAction)retriveApplePayToken:(id)sender {
    if (self.paymentRequest) {
        PKPaymentAuthorizationViewController *pavc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:self.paymentRequest];
        pavc.delegate = self;
        [self presentViewController:pavc animated:YES completion:nil];
    }
}

-(void) clearTextFields {
    [self.chargeCardModel updateCardNumberWithString:@""];
    [self.chargeCardModel updateCVCNumberWithString:@""];
    [self.chargeCardModel updateExpirationDateWithString:@""];
    self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
    self.cvcField.text = self.chargeCardModel.cvcCode;
    self.expirationField.text = self.chargeCardModel.formattedExpirationDate;
    [self setCardTypeImage];
    [self buttonEnabled];
}

- (void) dismissKeyboard {
    [self.cardNumberField resignFirstResponder];
    [self.expirationField resignFirstResponder];
    [self.cvcField resignFirstResponder];
}

#pragma mark SIMChargeCardModelDelegate callback methods
- (void)tokenFailedWithError:(NSError *)error {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self clearTextFields];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate creditCardTokenFailedWithError:error];
            
        }];
        
    });

}

-(void)tokenProcessed:(SIMCreditCardToken *)token {

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self clearTextFields];
            [self dismissKeyboard];
            [self dismissViewControllerAnimated:YES completion:^{
                
                [self.delegate creditCardTokenProcessed:token];
            }];
            
        });
}

#pragma mark PKPaymentAuthorizationViewControllerDelegate
-(void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    SIMSimplify* simplify = [[SIMSimplify alloc] initWithPublicKey:self.publicKey error:nil];
    [simplify createCardTokenWithPayment:payment completionHandler:^(SIMCreditCardToken *cardToken, NSError *error)
     {
         completion(PKPaymentAuthorizationStatusSuccess);
         [controller dismissViewControllerAnimated:YES completion:nil];
         [self dismissViewControllerAnimated:YES completion:^{
             [self.delegate creditCardTokenProcessed:cardToken];
         }];
     }];
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
