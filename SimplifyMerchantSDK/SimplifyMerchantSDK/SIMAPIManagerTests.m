#import "SIMAPIManager.h"

//Expose internals for testing
@interface SIMAPIManager (Test)

@property (nonatomic) NSURL *currentAPIURL;

@end

@interface SIMAPIManagerTests : XCTestCase

@property (nonatomic) SIMAPIManager *testSubject;

@end

@implementation SIMAPIManagerTests

-(void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

-(void)testAPIManagerCanDetermineLiveModeFromProvidedApiKey {
    NSString *apiKey = @"lvpb_1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithApiKey:apiKey error:&error];

    NSURL *apiURL = [NSURL URLWithString:@"https://api.simplify.com/v1/api"];
    
    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertTrue(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
    XCTAssertEqualObjects(apiURL, self.testSubject.currentAPIURL, @"");
}

-(void)testAPIManagerCanDetermineSandboxModeFromProvidedApiKey {
    NSString *apiKey = @"sbpb_1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithApiKey:apiKey error:&error];

    NSURL *apiURL = [NSURL URLWithString:@"https://sandbox.simplify.com/v1/api"];

    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertFalse(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
    XCTAssertEqualObjects(apiURL, self.testSubject.currentAPIURL, @"");
    
}

-(void)testAPIManagerReturnsNilAndErrorWhenAPIKeyIsInvalid {
    NSString *apiKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithApiKey:apiKey error:&error];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNotNil(error, @"");
    XCTAssertEqual(error.code, SIMAPIManagerErrorCodeInvalidAPIKey, @"");
}

-(void)testAPIManagerAcceptsNilErrorOnSuccess {
    NSString *apiKey = @"sbpb_1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithApiKey:apiKey error:nil];
    
    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertNil(error, @"");
}

-(void)testAPIManagerAcceptsNilErrorOnFailureAndNilObject {
    NSString *apiKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithApiKey:apiKey error:nil];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNil(error, @"");
}

@end
