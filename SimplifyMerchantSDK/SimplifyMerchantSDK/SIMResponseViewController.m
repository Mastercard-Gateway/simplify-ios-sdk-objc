#import "SIMResponseViewController.h"

@interface SIMResponseViewController ()

@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UIColor *primaryColor;
@property (nonatomic) BOOL didSucceed;

@end

@implementation SIMResponseViewController

-(instancetype)initWithBackground:(UIImageView *)backgroundView primaryColor:(UIColor *)primaryColor success:(BOOL)didSucceed {
    self = [super init];
    if (self) {
        self.backgroundView = backgroundView;
        self.primaryColor = primaryColor;
        self.didSucceed = didSucceed;
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
    titleLabel.text = self.didSucceed ? @"Success!" : @"Failure.";
    [self.view addSubview:titleLabel];

    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 132)];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.numberOfLines = 3;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [UIFont boldSystemFontOfSize:20.0];
    descriptionLabel.text = self.didSucceed ? @"You successfully generated a token!" : @"There was a problem with the token generation.\nPlease try again.";
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
    // Dispose of any resources that can be recreated.
}

@end
