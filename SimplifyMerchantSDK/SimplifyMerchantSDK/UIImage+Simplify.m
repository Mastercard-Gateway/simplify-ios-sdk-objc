#import "UIImage+Simplify.h"
#import "NSBundle+Simplify.h"

@implementation UIImage (Simplify)

+(UIImage*)imageNamedFromFramework:(NSString*)name {
    NSString *fileName = [[NSBundle frameworkBundle] pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:fileName];
}


@end
