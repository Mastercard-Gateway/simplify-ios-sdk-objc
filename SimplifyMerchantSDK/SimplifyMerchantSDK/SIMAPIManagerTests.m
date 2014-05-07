#import "SIMAPIManager.h"

@interface SIMAPIManager (Test)

- (id)initWithPublicApiKey:(NSString *)publicApiKey error:(NSError **) error urlRequest:(NSMutableURLRequest *)request;

@end

@interface SIMAPIManagerTests : XCTestCase

@property (nonatomic) SIMAPIManager *testSubject;
@property (nonatomic) id mockURLRequest;

@end

@implementation SIMAPIManagerTests

- (void)setUp
{
    self.mockURLRequest = [OCMockObject mockForClass:NSMutableURLRequest.class];
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testAPIManagerCanDetermineLiveMode {
    NSString *apiKey = @"lvpb_1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlRequest:self.mockURLRequest];

    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertTrue(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
    
}

- (void)testAPIManagerCanDetermineSandboxMode {
    NSString *apiKey = @"sbpb_1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlRequest:self.mockURLRequest];

    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertFalse(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
}

- (void)testAPIManagerReturnsNilAndErrorWhenAPIKeyIsInvalid {
    NSString *apiKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlRequest:self.mockURLRequest];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNotNil(error, @"");
    XCTAssertEqual(error.code, SIMAPIManagerErrorCodeInvalidAPIKey, @"");
}

//- (void)testAPIManagerAcceptsNilErrorOnSuccess {
//    NSString *apiKey = @"sbpb_1234";
//    NSError *error;
//    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:nil urlRequest:self.mockURLRequest];
//    
//    XCTAssertNil(self.testSubject, @"");
//    XCTAssertNil(error, @"");
//}
//
//- (void)testAPIManagerAcceptsNilErrorOnFailureAndNilObject {
//    NSString *apiKey = @"invalid1234";
//    NSError *error;
//    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:nil urlRequest:self.mockURLRequest];
//    
//    XCTAssertNil(self.testSubject, @"");
//    XCTAssertNil(error, @"");
//}
//
//
//- (void)testAPIManagerSendsRequestsToTheCorrectServiceHost {
//    NSString *apiKey = @"sbpb_1234";
////    NSString *endpoint = @"testendpoint";
//    NSError *error;
//    
//    self.testSubject = [[SIMAPIManager alloc] initWithPublicApiKey:apiKey error:&error urlRequest:self.mockURLRequest];
//    
//    XCTAssertNil(self.testSubject, @"");
//    XCTAssertNotNil(error, @"");
//    XCTAssertEqual(error.code, SIMAPIManagerErrorCodeInvalidAPIKey, @"");
//}

@end
