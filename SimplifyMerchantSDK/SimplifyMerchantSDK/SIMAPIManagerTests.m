#import "SIMAPIManager.h"

#define SIMAPIManagerPrefixLive @"lv"
#define SIMAPIManagerPrefixSandbox @"sb"

@interface SIMAPIManagerTests : XCTestCase

@property (nonatomic) SIMAPIManager *testSubject;
@property (nonatomic) id mockURLSession;

@end

@implementation SIMAPIManagerTests

- (void)setUp
{
    self.mockURLSession = [OCMockObject mockForClass:NSURLSession.class];
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAPIManagerCanDetermineLiveMode
{
    [self.testSubject initWithPublicApiToken:@"" urlSession:self.mockURLSession];
    
}

@end
