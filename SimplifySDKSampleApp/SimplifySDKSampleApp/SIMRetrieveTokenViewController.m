#import <Simplify/SIMSDKHelper.h>
#import "SIMRetrieveTokenViewController.h"
#import "SIMRetrieveTokenModel.h"

@interface SIMRetrieveTokenViewController ()<SIMRetrieveTokenModelDelegate>
@property (nonatomic, strong) SIMRetrieveTokenModel *checkoutModel;

@end

@implementation SIMRetrieveTokenViewController

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
    self.chargeAmountField.delegate = self;
    self.cardNumberField.delegate = self;
    self.expirationField.delegate = self;
    self.cvcField.delegate = self;
    self.checkoutModel = [SIMRetrieveTokenModel new];
    self.checkoutModel.delegate = self;
    [self setCardTypeImage];
    [self buttonSetUp];
    
    // Do any additional setup after loading the view.
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
    
    if ([self.checkoutModel isCardNumberValid]) {
        cardBackgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0];

    }
    if ([self.checkoutModel isExpirationDateValid]) {
        dateBackgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0];
    }
    
    self.cardNumberView.backgroundColor = cardBackgroundColor;
    self.expirationDateView.backgroundColor = dateBackgroundColor;
    BOOL isEnabled = [self.checkoutModel isRetrievalPossible];
    [self.chargeCardButton setEnabled:isEnabled];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == self.chargeAmountField) {
        [self.checkoutModel updateChargeAmountWithString:newString];
        self.chargeAmountField.text = self.checkoutModel.formattedChargeAmount;
    }
    
    else if (textField == self.cardNumberField) {
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
    if (textField == self.chargeAmountField) {
        [self.checkoutModel updateChargeAmountWithString:@""];
    }
    
    else if (textField == self.cardNumberField) {
        [self.checkoutModel updateCardNumberWithString:@""];
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

#pragma mark SIMRetrieveTokenModelDelegate methods
-(void) processCardTokenWithError:(NSError *)error {
    if (error) {
        
    } else {
        
    }
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
