#import "SIMResponseViewController.h"
#import "NSBundle+Simplify.h"
#import <UIColor+Simplify.h>

@interface SIMResponseViewController ()

@property (nonatomic) NSString *titleMessage;
@property (nonatomic) NSString *descriptionMessage;
@property (nonatomic) UIColor *primaryColor;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *customBackgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

- (IBAction)close:(id)sender;

@end

@implementation SIMResponseViewController



-(instancetype)initWithSuccess:(BOOL)success{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        if (success) {
            self = [self initWithSuccess:success title:@"Success!" description:@"Your transaction is complete." imageView:nil primaryColor:nil];
        }else{
            self = [self initWithSuccess:success title:@"Uh oh." description:@"There was a problem with the payment." imageView:nil primaryColor:nil];
        }
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        self = [self initWithSuccess:success title:titleMessage description:descriptionMessage imageView:nil primaryColor:nil];
    }
    return self;
}

-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage imageView:(UIImageView *)imageView primaryColor:(UIColor *)primaryColor{
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        
        self.titleMessage = titleMessage;
        self.descriptionMessage = descriptionMessage;

        //should check if there's an iv.
        //if there is, then use that
        //if there's no frame, then use that
        
        if (imageView && (self.imageView.frame.size.width > 0.0 && self.imageView.frame.size.height > 0.0)) {
            self.customImageView = imageView;
        }else if (imageView){
            self.customImageView = imageView;
        }else{
            
        }
    }
    return self;
}

/*
-(instancetype)initWithBackground:(UIImageView *)backgroundView primaryColor:(UIColor *)primaryColor title:(NSString *)titleMessage description:(NSString *)descriptionMessage {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        self.backgroundView = backgroundView;
        self.primaryColor = primaryColor ? primaryColor : [UIColor buttonBackgroundColorEnabled];
        self.titleMessage = titleMessage ? titleMessage : @"Status Unknown";
        self.descriptionMessage = descriptionMessage ? descriptionMessage : @"Please try again.";
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    if (self.backgroundView) {
        [self.view addSubview:self.backgroundView];
    }
    */
    self.titleLabel.text = self.titleMessage;
    self.descriptionLabel.text = self.descriptionMessage;
    if (self.customImageView) {
        self.backgroundImageView.image = self.customImageView.image;
    }

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}
/*
-(void)setIsPaymentSuccessful:(BOOL)isPaymentSuccessful {
    _isPaymentSuccessful = isPaymentSuccessful;
    
    UIImage *approvedIcon = [UIImage imageNamed:@"approvedIconWhite" inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil];
    UIImage *declinedIcon = [UIImage imageNamed:@"declinedIconGrey" inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil];
    
    self.view.backgroundColor = _isPaymentSuccessful ? [UIColor viewBackgroundColorValid] : [UIColor viewBackgroundColorInvalid];
    self.successIndicatorImageView.image = _isPaymentSuccessful ?  approvedIcon : declinedIcon;
    
}*/

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
