#import "SIMResponseViewController.h"
#import "NSBundle+Simplify.h"
#import <UIColor+Simplify.h>

@interface SIMResponseViewController ()

@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) NSString *titleMessage;
@property (nonatomic) NSString *descriptionMessage;
@property (nonatomic) UIColor *primaryColor;
@property (nonatomic) BOOL didSucceed;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation SIMResponseViewController

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.backgroundView) {
        [self.view addSubview:self.backgroundView];
    }
    
    self.titleLabel.text = self.titleMessage;
    self.descriptionLabel.text = self.descriptionMessage;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}


- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
