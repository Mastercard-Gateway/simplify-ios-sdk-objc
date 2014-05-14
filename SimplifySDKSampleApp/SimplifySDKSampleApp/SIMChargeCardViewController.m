#import <Simplify/SIMSDKHelper.h>
#import "SIMChargeCardViewController.h"
#import "SIMChargeCardModel.h"
#import "SIMButton.h"
#import <Simplify/UIColor+Simplify.h>


@interface SIMChargeCardViewController () <SIMChargeCardModelDelegate, UITextFieldDelegate>
@property (nonatomic, strong) SIMChargeCardModel *chargeCardModel;
@property (strong, nonatomic) IBOutlet UITextField *cardNumberField;
@property (strong, nonatomic) IBOutlet UITextField *expirationField;
@property (strong, nonatomic) IBOutlet UITextField *cvcField;
@property (strong, nonatomic) IBOutlet SIMButton *chargeCardButton;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (strong, nonatomic) IBOutlet UIView *cvcCodeView;
@property (strong, nonatomic) IBOutlet UIView *cardNumberView;
@property (strong, nonatomic) IBOutlet UIView *expirationDateView;

@end

@implementation SIMChargeCardViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cardNumberField.delegate = self;
    self.expirationField.delegate = self;
    self.cvcField.delegate = self;
    self.chargeCardModel = [SIMChargeCardModel new];
    self.chargeCardModel.delegate = self;
    [self setCardTypeImage];
    [self buttonSetUp];
    [self.cardNumberField becomeFirstResponder];

}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonSetUp {
    [self buttonsEnabled];
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
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.cardNumberField) {
        [self.chargeCardModel updateCardNumberWithString:newString];
        self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
        [self setCardTypeImage];
    }
    
    else if (textField == self.cvcField) {
        [self.chargeCardModel updateCVCNumberWithString:newString];
        self.cvcField.text = self.chargeCardModel.cvcCode;
    }
    
    else if (textField == self.expirationField) {
        [self.chargeCardModel updateExpirationDateWithString:newString];
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
    UIImage *cardImage = [SIMSDKHelper imageNamed:self.chargeCardModel.cardTypeString];
    [self.cardTypeImage setImage:cardImage];
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

#pragma mark SIMRetrieveTokenModelDelegate methods
-(void)paymentFailedWithError:(NSError *)error {
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

-(void)paymentProcessedWithPaymentID:(NSString *)paymentID {
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

@end
