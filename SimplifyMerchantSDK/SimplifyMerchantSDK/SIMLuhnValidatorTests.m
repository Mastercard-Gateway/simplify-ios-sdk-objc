#import "SIMLuhnValidator.h"
@interface SIMLuhnValidatorTests : XCTestCase
@property (nonatomic, strong) SIMLuhnValidator *testLuhnValidator;
@end

@implementation SIMLuhnValidatorTests

- (void)setUp
{
    [super setUp];
    self.testLuhnValidator = [SIMLuhnValidator new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLuhnValidatorReturnsYesForValidCards
{
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"49927398716"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"1234567812345670"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"79927398713"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"5105105105105100"], "valid");
    
}

- (void)testLuhnValidatorReturnsNoForInvalidCards
{
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"49927398717"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"1234567812345678"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398710"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398711"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398712"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398714"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398715"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398716"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398717"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398718"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398719"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"a"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"799273987a1s9"], "invalid");
}

@end
