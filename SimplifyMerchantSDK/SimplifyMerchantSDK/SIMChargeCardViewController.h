/**
 @mainpage
 Simplify by Mastercard iOS SDK. Start taking payments today.
 
 @section intro_sec Introduction
 You can use this SDK to generate a card token for a payment. You can either utilize the SIMChargeCardViewController to handle the complete lifecycle of user input to token generation, or use the SIMSimplify class to generate it yourself.

 @section implementation_sec Implementation

 You can implement the SDK using three different mechanisms: SIMChargeCardViewController,  SIMChargeCardModel and SIMSimplify.
 <br/><br/>
 SIMChargeCardViewController and SIMChargeCardViewControllerDelegate - This is the turn key solution. Simply create a SIMChargeCardViewController, signup as a SIMChargeCardViewControllerDelegate and implement the callbacks. All card input validation and token creation is handled for you. You simply present the UIViewController subclass and wait for for the token
 <br/><br/>
 SIMChargeCardModel and SIMChargeCardModelDelegate - This model allows you to input the fields required to make a payment, validates them and then allows you to retrieve a token. Create a SIMChargeCardModel, signup as a SIMChargeCardModelDelegate, implement the callbacks and then ask the SIMChargeCardModel to retrieveToken.
 <br/><br/>
 SIMSimplify - This object allows you to pass in the parameters required for tokenization and a completionHandler that will either return the token or an error.
 
 @class SIMChargeCardViewController
 
 @author Copyright (c) 2014 Mastercard International Incorporated. All Rights Reserved.
 @file
 */

#import <UIKit/UIKit.h>
#import "SIMCreditCardToken.h"

/**
 Public Protocol for communicating success or failure of the token generation.
 */

@protocol SIMChargeCardViewControllerDelegate

/**
 Token cancel Callback. The User has elected to cancel the token generation workflow.
 */
-(void)chargeCardCancelled;

/**
 Token failure Callback. If token generation fails, this will be called back and an error will be provided with a localizedDescription and code.
 */
-(void)creditCardTokenFailedWithError:(NSError *)error;

/**
 Token success Callback. If token generation succeeds, this will be called back and the fully hydrated credit card token.
 */
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token;

@end

@interface SIMChargeCardViewController : UIViewController

-(instancetype)initWithPublicKey:(NSString *)publicKey;
-(instancetype)initWithPublicKey:(NSString *)publicKey primaryColor:(UIColor *)primaryColor;

@property (nonatomic, weak) id <SIMChargeCardViewControllerDelegate> delegate; /**< Delegate for SIMChargeCardModelDelegate */

@end
