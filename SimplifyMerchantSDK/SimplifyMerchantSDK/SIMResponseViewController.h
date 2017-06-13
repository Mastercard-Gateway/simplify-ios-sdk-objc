#import <UIKit/UIKit.h>

@interface SIMResponseViewController : UIViewController

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

@end
