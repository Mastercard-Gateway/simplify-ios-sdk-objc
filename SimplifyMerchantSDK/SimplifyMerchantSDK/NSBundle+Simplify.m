#import <UIKit/UIKit.h>
#import "NSBundle+Simplify.h"

@implementation NSBundle (Simplify)

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

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension {

    NSBundle * mainBundle = [NSBundle mainBundle];
    NSString * path = [mainBundle pathForResource:name ofType:extension];
    if (path) {
        return path;
    }
    
    // Otherwise try with other bundles
    NSBundle * bundle;
    
    for (NSString * bundlePath in [mainBundle pathsForResourcesOfType:@"bundle" inDirectory:nil]) {
        bundle = [NSBundle bundleWithPath:bundlePath];
        path = [bundle pathForResource:name ofType:extension];
        if (path) {
            return path;
        }
    }
    
    NSLog(@"No path found for: %@ (.%@)", name, extension);
    return nil;
}

+ (NSArray *)loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options {

    NSBundle * mainBundle = [NSBundle mainBundle];

    if ([mainBundle pathForResource:name ofType:@"nib"]) {
        NSLog(@"Loaded Nib named: '%@' from mainBundle", name);
        return [mainBundle loadNibNamed:name owner:owner options:options];
    }
    
    NSBundle * bundle;
    for (NSString * bundlePath in [mainBundle pathsForResourcesOfType:@"bundle" inDirectory:nil]) {
        bundle = [NSBundle bundleWithPath:bundlePath];
        if ([bundle pathForResource:name ofType:@"nib"]) {
            NSLog(@"Loaded Nib named: '%@' from bundle: '%@' ", name, bundle.bundleIdentifier);
            return [bundle loadNibNamed:name owner:owner options:options];
        }
    }
    
    NSLog(@"Couldn't load Nib named: %@", name);
    return nil;
}

@end