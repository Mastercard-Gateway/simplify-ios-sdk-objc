#import <UIKit/UIKit.h>
/**
 * Helper for generating the SDK
 */
@interface SIMSDKHelper : NSObject

/**
 Bundles the framework for Simplify
 @return a bundled version of the Simplify Merchant SDK
 */
+(NSBundle*)frameworkBundle;

/**
 Obtains the UIImage from an NSString
 @param name is the file name of the image to be retrieved
 @return UIImage image housed in the framework bundle
 */
+(UIImage*)imageNamed:(NSString*)name;

@end
