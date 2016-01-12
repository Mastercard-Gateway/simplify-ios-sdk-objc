#import "SIMChargeCardViewController.h"
#import "SIMChargeCardModel.h"
#import "UIColor+Simplify.h"
#import "UIImage+Simplify.h"
#import "NSBundle+Simplify.h"
#import "NSString+Simplify.h"
#import "SIMResponseViewController.h"

@interface SIMChargeCardViewController () <SIMChargeCardModelDelegate, UITextFieldDelegate, PKPaymentAuthorizationViewControllerDelegate>
@property (strong, nonatomic) SIMChargeCardModel *chargeCardModel;
@property (strong, nonatomic) NSString *publicKey;
@property (strong, nonatomic) NSError *modelError;
@property (strong, nonatomic) PKPaymentRequest *paymentRequest;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *submitPaymentButton;
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
@property (weak, nonatomic) IBOutlet UIImageView *zipImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *applePayViewHolderHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zipCodeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expirationDateViewCVCCodeViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    self.cardNumberField.tintColor = self.primaryColor;
    self.expirationField.tintColor = self.primaryColor;
    self.cvcField.tintColor = self.primaryColor;
    self.zipField.tintColor = self.primaryColor;
    
    NSError *error;
    self.chargeCardModel = [[SIMChargeCardModel alloc] initWithPublicKey:self.publicKey error:&error];
    self.chargeCardModel.isZipRequired = self.isZipRequired;
    self.chargeCardModel.isCVCRequired = self.isCVCRequired;
    self.chargeCardModel.paymentRequest = self.paymentRequest;
    
    [self.submitPaymentButton setTitle:self.paymentButtonNormalTitle forState:UIControlStateNormal];
    [self.submitPaymentButton setTitle:self.paymentButtonDisabledTitle forState:UIControlStateDisabled];
    [self.submitPaymentButton setTitleColor:self.paymentButtonNormalTitleColor forState:UIControlStateNormal];
    [self.submitPaymentButton setTitleColor:self.paymentButtonDisabledTitleColor forState:UIControlStateDisabled];
    self.headerTitleLabel.text = self.headerTitle;
    self.headerTitleLabel.textColor = self.headerTitleColor;
    [self.cancelButton setTitleColor:self.headerTitleColor forState:UIControlStateNormal];
    self.headerView.backgroundColor = self.headerViewBackgroundColor;
    
    self.cardEntryView.layer.cornerRadius = 4.0;
    self.cardEntryView.layer.borderColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:1.0].CGColor;
    self.cardEntryView.layer.borderWidth = 1.0;
    self.cardEntryView.clipsToBounds = YES;
    
    if (error) {
        self.modelError = error;
    } else {
        self.chargeCardModel.delegate = self;

        [self setCardTypeImage];
        [self.submitPaymentButton setBackgroundColor:[UIColor buttonBackgroundColorDisabled]];
        [self.cardNumberField becomeFirstResponder];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64.0);
    
    //Collapse the Apple Pay button if there is no PKPaymentRequest or if the device is not capable of doing Apple Pay
    if (![self.chargeCardModel isApplePayAvailable]) {
        self.applePayViewHolderHeightConstraint.constant = 0.0;
    }
    
    if (!self.isCVCRequired) {
        [self.view removeConstraint:self.expirationDateViewCVCCodeViewWidthConstraint];
        [self.cvcCodeView removeFromSuperview];
    }
    
    if (!self.isZipRequired) {
        self.zipCodeViewHeightConstraint.constant = 0.0;
    }

    [self displayPaymentValidity];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    if (self.modelError) {
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:NO title:@"Failure" description:@"There was a problem with your Public Key.\n\nPlease double-check your Public Key and try again." iconImage:nil backgroundImage:nil tintColor:[UIColor redColor]];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat proposedBottomSpacing = self.view.frame.size.height - keyboardFrame.origin.y;
    if (proposedBottomSpacing == 0.0) {
        self.scrollViewBottomConstraint.constant = proposedBottomSpacing;
    }
}

-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat proposedBottomSpacing = self.view.frame.size.height - keyboardFrame.origin.y;
    if (proposedBottomSpacing > 0.0) {
        self.scrollViewBottomConstraint.constant = self.view.frame.size.height - keyboardFrame.origin.y;
    }
}

-(NSString *)paymentButtonNormalTitle{
    return _paymentButtonNormalTitle.length ? _paymentButtonNormalTitle :[self defaultTitle];
}

-(NSString *)paymentButtonDisabledTitle{
    return _paymentButtonDisabledTitle.length ? _paymentButtonDisabledTitle : [self defaultTitle];
}

-(UIColor *)paymentButtonNormalTitleColor{
   return _paymentButtonNormalTitleColor ? _paymentButtonNormalTitleColor : [UIColor whiteColor];
}

-(UIColor *)paymentButtonDisabledTitleColor{
    return _paymentButtonDisabledTitleColor ? _paymentButtonDisabledTitleColor : [UIColor whiteColor];
}

-(NSString *)defaultTitle{
    return [NSString stringWithFormat:@"Pay $%@", [NSString amountStringFromNumber:self.amount]];
}

-(UIColor *)paymentButtonColor{
    if (self.submitPaymentButton.isEnabled) {
        return _paymentButtonNormalColor ? _paymentButtonNormalColor : [UIColor buttonBackgroundColorEnabled];
    }else{
        return self.paymentButtonDisabledColor ? self.paymentButtonDisabledColor : [UIColor buttonBackgroundColorDisabled];
    }
}

-(NSString *)headerTitle{
    return _headerTitle.length ? _headerTitle : @"Checkout";
}

-(UIColor *)headerTitleColor{
    return _headerTitleColor ? _headerTitleColor : [UIColor whiteColor];
}

-(UIColor *)headerViewBackgroundColor{
    return _headerViewBackgroundColor ? _headerViewBackgroundColor : [UIColor buttonBackgroundColorEnabled];
}

-(void)setAmount:(NSDecimalNumber *)amount {
    _amount = amount;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)displayPaymentValidity {
    
    [self configureView:self.cardNumberView forValidity:(self.chargeCardModel.isCardNumberValid || self.chargeCardModel.cardNumber.length == 0)];
    [self configureView:self.expirationDateView forValidity:(self.chargeCardModel.isExpirationDateValid || self.chargeCardModel.expirationDate.length == 0)];
    [self configureView:self.cvcCodeView forValidity:(self.chargeCardModel.isCVCCodeValid || self.chargeCardModel.cvcCode.length == 0)];
    [self configureView:self.zipCodeView forValidity:(self.chargeCardModel.isZipCodeValid || self.chargeCardModel.zipCode.length == 0)];
    
    BOOL isEnabled = [self.chargeCardModel isCardChargePossible];
    [self.submitPaymentButton setEnabled:isEnabled];
    [self.submitPaymentButton setBackgroundColor:self.paymentButtonColor];
}

-(void)configureView:(UIView *)view forValidity:(BOOL)valid{
    view.layer.borderWidth = 1.0;
    if (valid) {
        view.layer.borderColor =  [UIColor viewBorderColorValid].CGColor;
    }else{
        view.layer.borderColor =  [UIColor viewBorderColorInvalid].CGColor;
        [self.cardEntryView bringSubviewToFront:view];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.cardNumberField] && [textField.text containsString:[NSString stringWithFormat:@"%C", 0x2022]]) {
        textField.text = self.chargeCardModel.formattedCardNumberNotObfuscated;
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.cardNumberField] && [textField.text containsString:[NSString stringWithFormat:@"%C", 0x2022]]) {
        textField.text = self.chargeCardModel.formattedCardNumber;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger fieldLength = string.length;
    
    if (textField == self.cardNumberField) {

        if (fieldLength) {
            [self.chargeCardModel updateCardNumberWithString:newString];

            if ([self.chargeCardModel isCardNumberValid]) {
                [self.expirationField becomeFirstResponder];
            }
            
        } else {
            [self.chargeCardModel deleteCharacterInCardNumber];
        }

        self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
        [self setCardTypeImage];
        
    } else if (textField == self.expirationField) {
        
        if (fieldLength) {
            [self.chargeCardModel updateExpirationDateWithString:newString];
        } else {
            [self.chargeCardModel deleteCharacterInExpiration];
        }

        self.expirationField.text = self.chargeCardModel.formattedExpirationDate;
        
        if ([self.chargeCardModel isExpirationDateValid]) {
            if (self.isCVCRequired) {
                [self.cvcField becomeFirstResponder];
            }else if (self.isZipRequired){
                [self.zipField becomeFirstResponder];
            }
        }

    } else if (textField == self.cvcField) {

        [self.chargeCardModel updateCVCNumberWithString:newString];
        self.cvcField.text = self.chargeCardModel.cvcCode;
        
        if ([self.chargeCardModel isCVCCodeValid] && self.isZipRequired) {
            [self.zipField becomeFirstResponder];
        }
        
    } else if (textField == self.zipField) {

        [self.chargeCardModel updateZipCodeWithString:newString];
        self.zipField.text = self.chargeCardModel.zipCode;
    }
    
    [self displayPaymentValidity];

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
    
    [self displayPaymentValidity];
    
    return YES;
}

-(void)setCardTypeImage {
    
    UIImage *cardImage = [UIImage imageNamed:self.chargeCardModel.cardTypeString inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil];
    [self.cardTypeImage setImage:cardImage];
}

- (IBAction)cancelTokenRequest:(id)sender {
    [self clearTextFields];
    [self dismissKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate chargeCardCancelled];
    }];
}

-(IBAction)retrieveToken:(id)sender {
    [self.chargeCardModel retrieveToken];
}

-(IBAction)retriveApplePayToken:(id)sender {
    if (self.chargeCardModel.paymentRequest) {
        PKPaymentAuthorizationViewController *pavc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:self.chargeCardModel.paymentRequest];
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
    [self displayPaymentValidity];
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
    NSError *error = nil;
    SIMSimplify* simplify = [[SIMSimplify alloc] initWithPublicKey:self.publicKey error:&error];

    if (error) {
        completion(PKPaymentAuthorizationStatusFailure);
    } else {
        
        [simplify createCardTokenWithPayment:payment completionHandler:^(SIMCreditCardToken *cardToken, NSError *error)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [controller dismissViewControllerAnimated:YES completion:^{
                     
                     [self dismissViewControllerAnimated:YES completion:^{
                         if (error) {
                             completion(PKPaymentAuthorizationStatusFailure);
                             [self.delegate creditCardTokenFailedWithError:error];
                         } else {
                             completion(PKPaymentAuthorizationStatusSuccess);
                             [self.delegate creditCardTokenProcessed:cardToken];
                         }
                     }];
                 }];
             });
         }];
    }
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
