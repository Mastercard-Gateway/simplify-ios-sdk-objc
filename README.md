# Simplify iOS SDK

Please download the [iOS SDK](https://github.com/simplifycom/iossdk/blob/master/simplify.zip?raw=true) and follow the [instructions](https://www.simplify.com/commerce/docs/sdk/ios) to get started.

## Overview

The iOS SDK by Simplify allows you to create a card token (one time use token representing card details) in your iOS app to send to a server to enable it to make a payment. By creating a card token, Simplify allows you to avoid sending card details to your server. The SDK can help with formatting and validating card information before the information is tokenized.

These three easy steps will allow you to collect card information, retrieve a card token from Simplify with the card information, and send the card token to your server in order to charge a card.

### 1. Add iOS Framework
##### Add Framework and Bundle to your project

Download the Simplify.Framework and Simplify.bundle and add both of these to your project. Add (Cmd+Option+A) them to your "Frameworks" grouping in XCode and then ensuring that only your build target is selected in "Add to targets" as in the following screenshot. Make sure you have selected "Copy items into destination group's folder".

![](https://www.simplify.com/commerce/images/docs/iossdk1-target.png)

Navigate to your Project->Build Settings->Linking Section and add the "-ObjC" linker flag to "Other Linker Flags". This will enable Objective C functionality (i.e. categories) in external libraries.

![](https://www.simplify.com/commerce/images/docs/iossdk2-linkerflag.png)

### 2. Collect Card Information
##### Setting API keys

After logging into your account, your API keys can be located at: Settings -> API Keys

To set your public API key, you need to instantiate a SIMChargeCardViewController, sign up for the SIMChargeCardViewControllerDelegate protocol and set the SIMChargeCardViewController's delegate. The sample app includes a SIMProductViewController that does all of this. Simply Run (Cmd+R) the "SimplifySDKSampleApp" Scheme. But, you can use any UIViewController subclass as well, by copying and pasting the following Class.

```
#import <Simplify/SIMChargeCardViewController.h>

//1. Sign up to be a SIMChargeViewControllerDelegate so that you get the callback that gives you a token
@interface SIMProductViewController: UIViewController <SIMChargeCardViewControllerDelegate>

@end

@implementation SIMProductViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //2. Create a SIMChargeViewController with your public api key
    SIMChargeCardViewController *chargeVC = [[SIMChargeCardViewController alloc] initWithPublicKey:@"YOUR_PUBLIC_API_KEY"];

    //3. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    chargeVC.delegate = self;

    //4. Add SIMChargeViewController to your view hierarchy
    [self presentViewController:chargeVC animated:YES completion:nil];

}

#pragma mark SIMChargeCardViewControllerDelegate callback
//5. This method will be called on your class whenever the user presses the Charge Card button and tokenization succeeds
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {

    //Process the provided token
    NSLog(@"Token:%@", token.token);

}

@end
```


The SDK will determine Live or Sandbox mode based upon the public key.

##### Collecting Card Information

You can use SIMChargeCardViewController in order to collect card information in your iOS app. There are validations on each of the fields, and the background of each field will turn green if valid or red if invalid (ex. an expiration date in the past will have a red field). The submit button will not be enabled unless the credit card number and the expiration date are both valid.


![](https://www.simplify.com/commerce/images/docs/iossdk3-screenshot1.png)

### 3. Create a Card Token
##### Create a single-use token

Once the user fills in the form and taps Charge Card, you will receive a callback describing the transaction where the token was created. This removes the burden of storing or processing credit card details from you as a merchant. In order to prevent possible security issues, you should never store or attempt to reuse this single-use token.

```
#pragma mark SIMChargeCardViewControllerDelegate callback

-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {

    //Process the provided token

}
```

All of the work of gathering information of the user, validating the inputs, creating the request to Simplify and submitting it is handled for you by the SDK. You simply need to implement the above method and you will receive the SIMCreditCardToken in the callback. If you would like to access the API directly, follow [the Manual Card Token generation instructions](https://www.simplify.com/commerce/docs/sdk/ios_viewless) if you'd like to see how the Card Token is actually requested.

#####Charging a Card

The example below shows how to handle three callbacks relating to tokens in SIMProductViewController, but you can implement these three callbacks in your own view controller. The first callback, chargeCardCancelled, is called if the user cancels inputting card details in the SIMChargeCardViewController. The controller will dismiss itself and then call this method.

```
#pragma mark - SIMChargeViewControllerDelegate Protocol

-(void)chargeCardCancelled {

    //User cancelled the SIMChargeCardViewController
    NSLog(@"User Cancelled");

}
```

The second callback, creditCardTokenFailedWithError, shows an example of how to handle a failed token request. In this case, it presents a screen that asks the user to try again.

```
-(void)creditCardTokenFailedWithError:(NSError *)error {

    NSLog(@"Credit Card Token Failed with error:%@", error.localizedDescription);

    UIImageView *blurredView = [UIImage blurImage:self.view.layer];
    NSString *errorDescription = @"There was a problem with the token.\nPlease try again.";
    SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:blurredView primaryColor:[UIColor blackColor] title:@"Failure." description:errorDescription];
    [self presentViewController:viewController animated:YES completion:nil];
}
```

You can charge a card by submitting a card token generated by the iOS SDK to your own server running one of the Simplify Commerce SDKs to create a Charge. The third callback (creditCardTokenProcessed) shows an example of how to send a token to your server for payment processing. If there is an error in payment processing, you should alert your user to the failure. If the payment was a success, you can return the user to another workflow.

```
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
        //Handle your server error

    } else {

        //Handle your server's response
    }

}
```

You will need to implement the details to send the request to your server and process the payment. Your server will need an endpoint that can receive a card token so that you can use the token to make a charge.

For more information on how to set up your payment system, see the [API documentation ](https://www.simplify.com/commerce/docs/api/index)and [our tutorial](https://www.simplify.com/commerce/docs/tutorial/index).
