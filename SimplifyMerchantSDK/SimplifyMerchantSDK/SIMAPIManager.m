#import "SIMAPIManager.h"

#define SIMAPIManagerPrefixLive @"lv"
#define SIMAPIManagerPrefixSandbox @"sb"

@interface SIMAPIManager ()

@end

@implementation SIMAPIManager

- (id)initWithPublicApiKey:(NSString *)publicApiKey urlSession:(NSURLSession *)urlSession {
    self = [super init];
    
    if (self) {

        self.isLiveMode = [self isAPIKeyLiveMode:publicApiKey];

    }

    return self;
}

-(BOOL)isAPIKeyLiveMode:(NSString *)apiKey {
    return [apiKey hasPrefix:SIMAPIManagerPrefixLive];
    
}

@end
