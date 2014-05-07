#import "SIMAPIManager.h"

@interface SIMAPIManager (Test)

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error urlSession:(NSURLSession *)urlSession;

@end

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
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlSession:self.mockURLSession];

    XCTAssertNotNil(this.testSubject, @"");
    XCTAssertTrue(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
    
}

- (void)testAPIManagerCanDetermineSandboxMode {
    NSString *apiKey = @"sb1234";
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlSession:self.mockURLSession];

    XCTAssertNotNil(this.testSubject, @"");
    XCTAssertFalse(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
}

- (void)testAPIManagerReturnsNilAndErrorWhenAPIKeyIsInvalid {
    NSString *apiKey = @"invalid1234";
    NSError *error;

    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlSession:self.mockURLSession];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNotNil(error, @"");
    XCTAssertEqual(error.code, SIMAPIManagerErrorCodeInvalidAPIKey, @"");
}

- (void)testAPIManagerSendsRequestsToTheCorrectServiceHost {
    NSString *apiKey = @"sb1234";
    NSString *endpoint = @"testendpoint";
    
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:nil urlSession:self.mockURLSession];
    
    NSString *expectedErrorCode = SIMAPIManagerErrorCodeInvalidAPIKey;
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNotNil(error, @"");
    XCTAssertEqual(error.code, SIMAPIManagerErrorCodeInvalidAPIKey, @"");
}

@end
