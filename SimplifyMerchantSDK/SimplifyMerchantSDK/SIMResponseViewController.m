#import "SIMResponseViewController.h"
#import <UIColor+Simplify.h>

@interface SIMResponseViewController ()

@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) NSString *titleMessage;
@property (nonatomic) NSString *descriptionMessage;
@property (nonatomic) UIColor *primaryColor;
@property (nonatomic) BOOL didSucceed;

@end

@implementation SIMResponseViewController

-(instancetype)initWithBackground:(UIImageView *)backgroundView primaryColor:(UIColor *)primaryColor title:(NSString *)titleMessage description:(NSString *)descriptionMessage {
    self = [super init];
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
    
    [self.view addSubview:self.backgroundView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 44)];
    titleLabel.textColor = self.primaryColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    titleLabel.text = self.titleMessage;
    [self.view addSubview:titleLabel];

    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 400)];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.numberOfLines = 10;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [UIFont boldSystemFontOfSize:20.0];
    descriptionLabel.text = self.descriptionMessage;
    [self.view addSubview:descriptionLabel];

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
