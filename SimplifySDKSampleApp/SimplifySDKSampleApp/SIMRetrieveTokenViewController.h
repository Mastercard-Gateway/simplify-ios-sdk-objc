@interface SIMRetrieveTokenViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *cardNumberField;
@property (strong, nonatomic) IBOutlet UITextField *expirationField;
@property (strong, nonatomic) IBOutlet UITextField *cvcField;
@property (strong, nonatomic) IBOutlet UIButton *chargeCardButton;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeImage;


@end
