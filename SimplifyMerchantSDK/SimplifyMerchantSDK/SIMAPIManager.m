#import "SIMAPIManager.h"

#define SIMAPIManagerPrefixLive @"lv"
#define SIMAPIManagerPrefixSandbox @"sb"

#define SIMAPIManagerErrorDomain @"com.mastercard.simplify.errordomain"

@interface SIMAPIManager ()

@end

@implementation SIMAPIManager

- (id)initWithPublicApiKey:(NSString *)publicApiKey urlSession:(NSURLSession *)urlSession error:(NSError **) error{
    self = [super init];
    
    if (self) {

        self.isLiveMode = [self isAPIKeyLiveMode:publicApiKey error:error];
        
        if (error) {
            return nil;
        }
        
    }

    return self;
}

-(BOOL)isAPIKeyLiveMode:(NSString *)apiKey error:(NSError **) error{

    BOOL isLive;
    
    if ([apiKey hasPrefix:SIMAPIManagerPrefixLive]) {
        isLive = YES;
    } else if ([apiKey hasPrefix:SIMAPIManagerPrefixSandbox]){
        isLive = NO;
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not create API Manager: Invalid API Key."};
        
        *error = [NSError errorWithDomain:SIMAPIManagerErrorDomain code:SIMAPIManagerErrorCodeInvalidAPIKey userInfo:userInfo];
    }
    
    return isLive;
    
}

@end
