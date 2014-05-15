//
//  SIMProductViewController.m
//  SimplifySDKSampleApp
//
//  Created by Neem Serra on 5/15/14.
//  Copyright (c) 2014 MasterCard. All rights reserved.
//

#import "SIMProductViewController.h"
#import <Simplify/SIMChargeCardViewController.h>
@interface SIMProductViewController ()<SIMChargeCardViewControllerDelegate>

@end

@implementation SIMProductViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    
    //    SIMChargeCardViewController *chargeController =
    
    SIMChargeCardViewController *chargeController = [segue destinationViewController];
    chargeController =[[SIMChargeCardViewController alloc] initWithApiKey:@"sbpb_N2ZkOGIwZWYtYTg3My00OTE1LWI3ZjgtMzZhMzZhZTAyYTY5"];
    chargeController.delegate = self;
    // Pass the selected object to the new view controller.
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
