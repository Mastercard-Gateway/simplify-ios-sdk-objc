#import <Simplify/SIMSDKHelper.h>
#import "SIMCheckoutViewController.h"
#import "SIMCheckoutModel.h"

@interface SIMCheckoutViewController ()<SIMCheckoutModelDelegate, UITextFieldDelegate>
@property (nonatomic, strong) SIMCheckoutModel *checkoutModel;

@property (strong, nonatomic) IBOutlet UITextField *cardNumberField;
@property (strong, nonatomic) IBOutlet UITextField *expirationField;
@property (strong, nonatomic) IBOutlet UITextField *cvcField;
@property (strong, nonatomic) IBOutlet UIButton *chargeCardButton;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (strong, nonatomic) IBOutlet UIView *cvcCodeView;
@property (strong, nonatomic) IBOutlet UIView *cardNumberView;
@property (strong, nonatomic) IBOutlet UIView *expirationDateView;


@end

@implementation SIMCheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cardNumberField.delegate = self;
    self.expirationField.delegate = self;
    self.cvcField.delegate = self;
    self.checkoutModel = [SIMCheckoutModel new];
    self.checkoutModel.delegate = self;
    [self setCardTypeImage];
    [self buttonSetUp];
    [self.cardNumberField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonSetUp {
    [self.chargeCardButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    [self buttonsEnabled];
}

-(void)buttonsEnabled {
    UIColor *cardBackgroundColor = [UIColor whiteColor];
    UIColor *dateBackgroundColor = [UIColor whiteColor];
    UIColor *cvcBackgroundColor = [UIColor whiteColor];
    
    if (self.checkoutModel.cardNumber.length > 0) {
        if ([self.checkoutModel isCardNumberValid]) {
            cardBackgroundColor = [UIColor colorWithRed:(250.0/255.0) green:1.0 blue:(248.0/255.0) alpha:1.0];
        } else {
            cardBackgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(248.0/255.0) blue:(248.0/255.0) alpha:1.0];
        }
    }
    
    if (self.checkoutModel.expirationDate.length > 0) {
        if ([self.checkoutModel isExpirationDateValid]) {
            dateBackgroundColor = [UIColor colorWithRed:(250.0/255.0) green:1.0 blue:(248.0/255.0) alpha:1.0];
        } else {
            dateBackgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(248.0/255.0) blue:(248.0/255.0) alpha:1.0];
        }
    }
    
    if (self.checkoutModel.cvcCode.length > 0) {
        if ([self.checkoutModel isCVCCodeValid]) {
            cvcBackgroundColor = [UIColor colorWithRed:(250.0/255.0) green:1.0 blue:(248.0/255.0) alpha:1.0];
        } else {
            cvcBackgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(248.0/255.0) blue:(248.0/255.0) alpha:1.0];
        }
    }
    
    self.cardNumberView.backgroundColor = cardBackgroundColor;
    self.expirationDateView.backgroundColor = dateBackgroundColor;
    self.cvcCodeView.backgroundColor = cvcBackgroundColor;
    BOOL isEnabled = [self.checkoutModel isCheckoutPossible];
    [self.chargeCardButton setEnabled:isEnabled];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.cardNumberField) {
        [self.checkoutModel updateCardNumberWithString:newString];
        self.cardNumberField.text = self.checkoutModel.formattedCardNumber;
        [self setCardTypeImage];
    }
    
    else if (textField == self.cvcField) {
        [self.checkoutModel updateCVCNumberWithString:newString];
        self.cvcField.text = self.checkoutModel.cvcCode;
    }
    
    else if (textField == self.expirationField) {
        [self.checkoutModel updateExpirationDateWithString:newString];
        self.expirationField.text = self.checkoutModel.formattedExpirationDate;
    }
    
    [self buttonsEnabled];

    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == self.cardNumberField) {
        [self.checkoutModel updateCardNumberWithString:@""];
        [self setCardTypeImage];
    }
    
    else if (textField == self.cvcField) {
        [self.checkoutModel updateCVCNumberWithString:@""];
    }
    
    else if (textField == self.expirationField) {
        [self.checkoutModel updateExpirationDateWithString:@""];
    }
    
    [self buttonsEnabled];
    
    return YES;
}

-(void)setCardTypeImage {
    UIImage *cardImage = [SIMSDKHelper imageNamed:self.checkoutModel.cardTypeString];
    [self.cardTypeImage setImage:cardImage];
}

- (IBAction)retrieveToken:(id)sender {
    [self.checkoutModel retrieveToken];
}

-(void) clearTextFields {
    [self.checkoutModel updateCardNumberWithString:@""];
    [self.checkoutModel updateCVCNumberWithString:@""];
    [self.checkoutModel updateExpirationDateWithString:@""];
    self.cardNumberField.text = self.checkoutModel.formattedCardNumber;
    self.cvcField.text = self.checkoutModel.cvcCode;
    self.expirationField.text = self.checkoutModel.formattedExpirationDate;
    [self setCardTypeImage];
    [self buttonsEnabled];
}

#pragma mark SIMRetrieveTokenModelDelegate methods
- (void)paymentFailedWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error processing payment"
                                                    message:error.localizedDescription
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self clearTextFields];
    });

}

- (void)paymentProcessedWithPaymentID:(NSString *)paymentID {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Payment Processed Successfully"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self clearTextFields];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
