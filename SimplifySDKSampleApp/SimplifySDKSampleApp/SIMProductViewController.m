#import "SIMProductViewController.h"
#import <Simplify/SIMChargeCardViewController.h>
#import <Simplify/SIMButton.h>
#import <Simplify/UIImage+Simplify.h>
#import <Simplify/SIMResponseViewController.h>

@interface SIMProductViewController ()<SIMChargeCardViewControllerDelegate>
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (strong, nonatomic) IBOutlet SIMButton *buyButton;
@property (strong, nonatomic) UIColor *primaryColor;
@end

@implementation SIMProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.primaryColor = [UIColor colorWithRed:42.0/255.0 green:48.0/255.0 blue:145.0/255.0 alpha:1.0];
    self.buyButton.primaryColor = self.primaryColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (IBAction)buyCupcake:(id)sender {
    SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithApiKey:@"sbpb_N2ZkOGIwZWYtYTg3My00OTE1LWI3ZjgtMzZhMzZhZTAyYTY5" primaryColor:self.primaryColor];

    chargeController.delegate = self;
    self.chargeController = chargeController;
    
    [self presentViewController:self.chargeController animated:YES completion:nil];
    
}

#pragma mark - SIMChargeViewController Protocol
-(void)chargeCardCancelled {
    //User cancelled the SIMChargeCardViewController
    
    [self.chargeController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"User Cancelled");
}

-(void)creditCardTokenFailedWithError:(NSError *)error {
    
    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);
}

-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    
    NSURL *url= [NSURL URLWithString:@"https://Your_server/charge.rb"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"simplifyToken=";
    
    postString = [postString stringByAppendingString:token.token];
    
    NSLog(@"postString:%@", postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    
    //Process Request on your own server
    
    if (error) {
        NSLog(@"error:%@", error);
        UIImageView *blurredView = [UIImage blurImage:self.view.layer];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:self.primaryColor title:@"Failure." description:@"There was a problem with the payment.\nPlease try again."];
        [self presentViewController:viewController animated:YES completion:nil];

    } else {
        
        UIImageView *blurredView = [UIImage blurImage:self.view.layer];
        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:self.primaryColor title:@"Success!" description:@"You purchased a cupcake!"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

@end
