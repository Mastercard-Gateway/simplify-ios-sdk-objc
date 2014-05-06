#import "SIMAPIManager.h"

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

- (void)testAPIManagerCanDetermineLiveMode {
    NSString *apiKey = @"lv1234";
    
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey urlSession:self.mockURLSession];
    XCTAssertTrue(self.testSubject.isLiveMode, @"");
    
}

- (void)testAPIManagerCanDetermineSandboxMode {
    NSString *apiKey = @"sb1234";
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey urlSession:self.mockURLSession];
    XCTAssertFalse(self.testSubject.isLiveMode, @"");
    
}

@end
