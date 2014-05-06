@interface SIMAPIManager : NSObject

@property (nonatomic) BOOL isLiveMode;

- (id)initWithPublicApiKey:(NSString *)publicApiKey urlSession:(NSURLSession *)urlSession;

@end
