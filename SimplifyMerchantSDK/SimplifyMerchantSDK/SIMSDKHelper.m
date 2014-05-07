#import "SIMSDKHelper.h"

@implementation SIMSDKHelper

+(NSBundle *)frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"Simplify.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}

+(UIImage*)imageNamed:(NSString*)name {
    NSString *fileName = [[SIMSDKHelper frameworkBundle] pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:fileName];
}

@end
