# Simplify iOS SDK

Please download the [iOS SDK](https://www.simplify.com/commerce/distribution/ios/simplify.zip) and follow the [instructions](https://www.simplify.com/commerce/docs/sdk/ios) to get started.

## Overview

The iOS SDK by Simplify allows you to create a card token (one time use token representing card details) in your iOS app to send to a server to enable it to make a payment. By creating a card token, Simplify allows you to avoid sending card details to your server. The SDK can help with formatting and validating card information before the information is tokenized.

These five easy steps will allow you to collect card information, retrieve a card token from Simplify with the card information, send the card token to your server in order to charge a card, and present feedback on success or failure to your user.

A sample project included here illustrates how easy it is to build an app around the SDK.

## Requirements

* iOS 8.0+
* ARC

## Usage

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

### 4. Charge a Card

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

For more information on how to set up your payment system, see the [API documentation ](https://www.simplify.com/commerce/docs/api/index)and [our tutorial](https://www.simplify.com/commerce/docs/tutorial/index). You can even quickly set up a Heroku payment processing server using the instructions [here](https://www.simplify.com/commerce/docs/examples/heroku).

### 5. Present the Response View Controller (optional)

After your successfully process your token or experience a failure, you'll want to notify your app's user. To do this, you can provide your own response view, or you can use the provided SIMResponseViewController class.  The success property will determine the default text and icon, and a provided tint color will change the default icon's appearance.  Further customization options are described later in this document.

```
-(void)creditCardTokenFailedWithError:(NSError *)error{
	SIMResponseViewController *viewController = [[SIMResponseViewController alloc]initWithSuccess:NO tintColor:[UIColor redColor]];
	[self presentViewController:viewController animated:YES completion:nil];
}
```

## Customization

There are several ways in which you can tailor the Charge Card View Controller and the Response View Controller.  These are entirely optional.

### Charge Card View Controller

Implement the following code after instantiating the view controller but prior to presenting it.

#### CVC and Zip Requirement
```
	//CVC and zip are not required by default
    chargeController.isCVCRequired = YES;  
    chargeController.isZipRequired = YES;
```

#### Payment Button
```
	chargeController.paymentButtonNormalTitle = @"Submit";
    chargeController.paymentButtonDisabledTitle = @"Submit";
    chargeController.paymentButtonDisabledColor = [UIColor redColor];
    chargeController.paymentButtonNormalColor = [UIColor greenColor];
    chargeController.paymentButtonNormalTitleColor = [UIColor whiteColor];
    chargeController.paymentButtonDisabledTitleColor = [UIColor whiteColor];
```

#### Header
```
    chargeController.headerTitle = @"Card Information";
    chargeController.headerTitleColor = [UIColor blackColor];
    chargeController.headerViewBackgroundColor = [UIColor whiteColor];
```

### Response View Controller

#### When Initializaing

Several initialization methods are available for use.

```
 /**
 Initialization method for a response view controller with default messaging and colors
 @param success Whether or not the charge succeeded
 */
-(instancetype)initWithSuccess:(BOOL)success;

/**
 Initialization method for a response view controller with default messaging and a tinted icon and title
 @param success Whether or not the charge succeeded
 @param tintColor The custom color to tint the interface, which will be overriden if the title message color is set
 */
-(instancetype)initWithSuccess:(BOOL)success tintColor:(UIColor *)tintColor;

/**
 Initialization method for a response view controller with default messaging and a tinted icon and title
 @param success Whether or not the charge succeeded
 @param titleMessage The custom title for the response
 @param descriptionMessage The custom description of the response, which will be overriden if the title message color is set
 */
-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage;

/**
 Initialization method for a response view controller with default messaging and a tinted icon and title
 @param success Whether or not the charge succeeded
 @param titleMessage The custom title for the response
 @param descriptionMessage The custom description of the response
 @param iconImage The small image that appears above the title
 @param backgroundImage The large image behind the rest of the UI
 @param tintColor The custom color to tint the interface, which will be overriden if the title message color is set
 */
-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage iconImage:(UIImage *)iconImage backgroundImage:(UIImage *)backgroundImage tintColor:(UIColor *)tintColor;

```
#### Further modification

Optionally, you can modify the following properties after instantiating the view controller but prior to presenting it.

```
/**
 The text color for the title message
*/
@property (strong, nonatomic) UIColor *titleMessageColor;

/**
 The text color for the description message
*/
@property (strong, nonatomic) UIColor *descriptionMessageColor;

/**
 The background color for the bottom button
*/
@property (strong, nonatomic) UIColor *buttonColor;

/**
 The text color for the bottom button
*/
@property (strong, nonatomic) UIColor *buttonTextColor;

/**
 The text for the bottom button
*/
@property (strong, nonatomic) NSString *buttonText;

``` 
