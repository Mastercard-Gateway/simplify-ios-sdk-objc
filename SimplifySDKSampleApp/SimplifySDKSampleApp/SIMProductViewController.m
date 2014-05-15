//
//  SIMProductViewController.m
//  SimplifySDKSampleApp
//
//  Created by Neem Serra on 5/15/14.
//  Copyright (c) 2014 MasterCard. All rights reserved.
//

#import "SIMProductViewController.h"
#import <Simplify/SIMChargeCardViewController.h>
@interface SIMProductViewController ()

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
    // Pass the selected object to the new view controller.
}

@end
