@interface SIMAPIManager : NSObject

@property (nonatomic) BOOL isLiveMode;

- (id)initWithPublicApiToken:(NSString *)publicApiToken urlSession:(NSURLSession *)urlSession;

@end
