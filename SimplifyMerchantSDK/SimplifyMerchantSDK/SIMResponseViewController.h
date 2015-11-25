#import <UIKit/UIKit.h>

@interface SIMResponseViewController : UIViewController

-(instancetype)initWithSuccess:(BOOL)success;

-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage;

-(instancetype)initWithSuccess:(BOOL)success title:(NSString *)titleMessage description:(NSString *)descriptionMessage imageView:(UIImageView *)imageView primaryColor:(UIColor *)primaryColor;

@property (strong, nonatomic) UIColor *imageViewRenderColor;
@property (strong, nonatomic) UIColor *titleMessageColor;
@property (strong, nonatomic) UIColor *titleDescriptionColor;
@property (strong, nonatomic) UIColor *buttonColor;
@property (strong, nonatomic) UIColor *buttonTextColor;
@property (strong, nonatomic) NSString *buttonText;

@end
