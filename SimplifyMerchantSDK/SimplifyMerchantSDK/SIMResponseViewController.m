#import "SIMResponseViewController.h"
#import "NSBundle+Simplify.h"
#import <UIColor+Simplify.h>

@interface SIMResponseViewController ()


@property (nonatomic) BOOL success;
@property (strong, nonatomic) NSString *titleMessage;
@property (strong, nonatomic) NSString *descriptionMessage;
@property (strong, nonatomic) UIImage *iconImage;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIColor *tintColor;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

- (IBAction)close:(id)sender;

@end

@implementation SIMResponseViewController

-(instancetype)initWithSuccess:(BOOL)success{
    return [self initWithSuccess:success title:nil description:nil iconImage:nil backgroundImage:nil tintColor:nil];
}

-(instancetype)initWithSuccess:(BOOL)success tintColor:(UIColor *)tintColor{
    return [self initWithSuccess:success title:nil description:nil iconImage:nil backgroundImage:nil tintColor:tintColor];
}

-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage{
    return [self initWithSuccess:success title:titleMessage description:descriptionMessage iconImage:nil backgroundImage:nil tintColor:nil];
}

-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage iconImage:(UIImage *)iconImage backgroundImage:(UIImage *)backgroundImage tintColor:(UIColor *)tintColor{

    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        
        self.success = success;
        
        if (titleMessage) {
            self.titleMessage = titleMessage;
        }else{
            self.titleMessage = success ? @"Success!" : @"Uh oh.";
        }
        
        if (descriptionMessage) {
            self.descriptionMessage = descriptionMessage;
        }else{
            self.descriptionMessage = success ? @"Your transaction is complete." : @"There was a problem with the payment.";
        }
        
        if (iconImage) {
            self.iconImage = iconImage;
        }else if (!iconImage && !backgroundImage){
            self.iconImage = success ? [[UIImage imageNamed:@"successGraphic" inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : [[UIImage imageNamed:@"failGraphic" inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
        self.backgroundImage = backgroundImage ? backgroundImage : nil;
        
        self.tintColor = tintColor ? tintColor : [UIColor blackColor];
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleMessage;
    self.descriptionLabel.text = self.descriptionMessage;
    self.backgroundImageView.image = self.backgroundImage;
    self.iconImageView.image = self.iconImage;
    self.iconImageView.tintColor = self.tintColor;
    self.titleLabel.textColor = self.titleMessageColor ? self.titleMessageColor : self.tintColor;
    
    if (self.descriptionMessageColor) {
        self.descriptionLabel.textColor = self.descriptionMessageColor;
    }
   
    if (self.buttonColor) {
        self.bottomButton.backgroundColor = self.buttonColor;
    }
    
    if (!self.buttonText) {
        self.buttonText = self.success ? @"Done" : @"Cancel";
    }
    [self.bottomButton setTitle:self.buttonText forState:UIControlStateNormal];
    
    if (self.buttonTextColor) {
        [self.bottomButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
