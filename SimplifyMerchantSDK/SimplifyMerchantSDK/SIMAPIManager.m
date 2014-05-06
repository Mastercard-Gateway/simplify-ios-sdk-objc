#import "SIMAPIManager.h"

@interface SIMAPIManager ()

@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSURLSession *urlSession;
@property (nonatomic) NSURL *currentAPIURL;

@end

@implementation SIMAPIManager

static NSString *prodAPILiveURL = @"https://api.simplify.com/v1/api";
static NSString *prodAPISandboxURL = @"https://sandbox.simplify.com/v1/api";

- (id)initWithPublicApiToken:(NSString *)publicApiToken urlSession:(NSURLSession *)urlSession {
    self = [super init];
    
    if (self) {

    }
    return self;
}
@end
