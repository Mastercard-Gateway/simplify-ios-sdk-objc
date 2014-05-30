#import "SIMChargeCardViewController.h"
#import "SIMChargeCardModel.h"
#import "SIMButton.h"
#import "UIColor+Simplify.h"
#import "UIImage+Simplify.h"
#import "NSBundle+Simplify.h"
#import "SIMResponseViewController.h"

@interface SIMChargeCardViewController () <SIMChargeCardModelDelegate, UITextFieldDelegate>
@property (strong, nonatomic) SIMChargeCardModel *chargeCardModel;
@property (strong, nonatomic) NSString *publicKey;
@property (strong, nonatomic) IBOutlet UILabel *cvcLabel;
@property (strong, nonatomic) NSError *modelError;

@property (strong, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet SIMButton *chargeCardButton;
@property (strong, nonatomic) IBOutlet UITextField *cardNumberField;
@property (strong, nonatomic) IBOutlet UITextField *expirationField;
@property (strong, nonatomic) IBOutlet UITextField *cvcField;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (strong, nonatomic) IBOutlet UIView *cvcCodeView;
@property (strong, nonatomic) IBOutlet UIView *cardNumberView;
@property (strong, nonatomic) IBOutlet UIView *expirationDateView;

@end

@implementation SIMChargeCardViewController

-(instancetype)initWithPublicKey:(NSString *)publicKey {
    return [self initWithPublicKey:publicKey primaryColor:nil];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey primaryColor:(UIColor *)primaryColor {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        self.publicKey = publicKey;
        self.primaryColor = primaryColor ? primaryColor : [UIColor buttonBackgroundColorEnabled];
    }
    
    return  self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.cardNumberField.delegate = self;
    self.expirationField.delegate = self;
    self.cvcField.delegate = self;
    
    self.cardNumberField.tintColor = self.primaryColor;
    self.expirationField.tintColor = self.primaryColor;
    self.cvcField.tintColor = self.primaryColor;
    NSError *error;
    self.chargeCardModel = [[SIMChargeCardModel alloc] initWithPublicKey:self.publicKey error:&error];
    
    if (error) {
        self.modelError = error;
    } else {
        self.chargeCardModel.delegate = self;

        [self setCardTypeImage];
        [self buttonsEnabled];
        [self.cardNumberField becomeFirstResponder];
    }

}

-(void)viewDidAppear:(BOOL)animated {
    if (self.modelError) {
        UIImageView *blurredView = [UIImage blurImage:self.view.layer];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:self.primaryColor title:@"Failure." description:@"\n\nThere was a problem with your Public Key.\n\nPlease double-check your Public Key and try again."];
        [self presentViewController:viewController animated:YES completion:nil];

    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)buttonsEnabled {
    
    UIColor *cardBackgroundColor = [UIColor whiteColor];
    UIColor *dateBackgroundColor = [UIColor whiteColor];
    UIColor *cvcBackgroundColor = [UIColor whiteColor];
    
    if (self.chargeCardModel.cardNumber.length > 0) {
        if ([self.chargeCardModel isCardNumberValid]) {
            cardBackgroundColor = [UIColor fieldBackgroundColorValid];
        } else {
            cardBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    if (self.chargeCardModel.expirationDate.length > 0) {
        if ([self.chargeCardModel isExpirationDateValid]) {
            dateBackgroundColor = [UIColor fieldBackgroundColorValid];
        } else {
            dateBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    if (self.chargeCardModel.cvcCode.length > 0) {
        if ([self.chargeCardModel isCVCCodeValid]) {
            cvcBackgroundColor = [UIColor fieldBackgroundColorValid];
        } else {
            cvcBackgroundColor = [UIColor fieldBackgroundColorInvalid];
        }
    }
    
    self.cardNumberView.backgroundColor = cardBackgroundColor;
    self.expirationDateView.backgroundColor = dateBackgroundColor;
    self.cvcCodeView.backgroundColor = cvcBackgroundColor;
    BOOL isEnabled = [self.chargeCardModel isCardChargePossible];
    [self.chargeCardButton setEnabled:isEnabled];
    self.chargeCardButton.primaryColor = self.primaryColor;
    self.cvcLabel.textColor = self.primaryColor;
    self.expLabel.textColor = self.primaryColor;
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
    }
    
    [self buttonsEnabled];

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
    
    [self buttonsEnabled];
    
    return YES;
}

-(void)setCardTypeImage {
    UIImage *cardImage = [UIImage imageNamedFromFramework:self.chargeCardModel.cardTypeString];
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

-(void) clearTextFields {
    [self.chargeCardModel updateCardNumberWithString:@""];
    [self.chargeCardModel updateCVCNumberWithString:@""];
    [self.chargeCardModel updateExpirationDateWithString:@""];
    self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
    self.cvcField.text = self.chargeCardModel.cvcCode;
    self.expirationField.text = self.chargeCardModel.formattedExpirationDate;
    [self setCardTypeImage];
    [self buttonsEnabled];
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

@end
