#import "SIMAppDelegate.h"
#import <Simplify/Simplify.h>
#import <Simplify/UIColor+Simplify.h>

#import "SIMProductViewController.h"


@interface SIMAppDelegate () <SIMChargeCardViewControllerDelegate>
@property (nonatomic, strong) UIStoryboard *storyboard;
@end

@implementation SIMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = [UIColor whiteColor];
    self.storyboard = [self.window.rootViewController storyboard];
    SIMProductViewController *productController = [self.storyboard instantiateInitialViewController];
//    SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithApiKey:@"sbpb_N2ZkOGIwZWYtYTg3My00OTE1LWI3ZjgtMzZhMzZhZTAyYTY5"];
//    chargeController.delegate = self;
    self.window.rootViewController = productController;

    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - SIMChargeViewController Protocol
-(void)chargeCardCancelled {
    //User cancelled the SIMChargeViewController
    NSLog(@"User Cancelled");
}

-(void)creditCardTokenFailedWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error processing token" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];

    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);
}

-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    
    NSURL *url= [NSURL URLWithString:@"https://Your_server/charge.rb"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"simplifyToken=";
    
    postString = [postString stringByAppendingString:token.token];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    
    //Process Request on your own server
    
    if (error) {
        NSLog(@"error:%@", error);
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Payment Processed Successfully"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }

}

@end
