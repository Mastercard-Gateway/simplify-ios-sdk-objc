#import "SIMAppDelegate.h"
#import <Simplify/Simplify.h>

#import "SIMProductViewController.h"


@interface SIMAppDelegate () 
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

@end
