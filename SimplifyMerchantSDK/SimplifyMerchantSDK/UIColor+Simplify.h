#import <UIKit/UIKit.h>

@interface UIColor (Simplify)

+ (UIColor *)buttonBackgroundColorEnabled;
+ (UIColor *)buttonHighlightColorEnabled;
+ (UIColor *)buttonBackgroundColorDisabled;
+ (UIColor *)buttonHighlightColorDisabled;
+ (UIColor *)fieldBorderColorValid;
+ (UIColor *)fieldBorderInvalid;
+ (UIColor *)viewBorderColorValid;
+ (UIColor *)viewBorderColorInvalid;


+ (UIColor *)darkerColorThanColor:(UIColor *)originalColor;

@end
