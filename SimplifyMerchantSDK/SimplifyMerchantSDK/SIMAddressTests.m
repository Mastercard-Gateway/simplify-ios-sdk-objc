#import "SIMAddress.h"
@interface SIMAddressTests : XCTestCase
@property (nonatomic, strong) SIMAddress *testSubject;
@end

@implementation SIMAddressTests

- (void)setUp {
	[super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void)testThatAddressCanBeCreated {
	self.testSubject = [[SIMAddress alloc] initWithName:@"Sam Simple" addressLine1:@"2200 Mastercard Blvd" addressLine2:@"Area 1" city:@"O'Fallon" state:@"MO" zip:@"63368"];
    
	XCTAssertTrue([self.testSubject.name isEqualToString:@"Sam Simple"]);
	XCTAssertTrue([self.testSubject.addressLine1 isEqualToString:@"2200 Mastercard Blvd"]);
	XCTAssertTrue([self.testSubject.addressLine2 isEqualToString:@"Area 1"]);
	XCTAssertTrue([self.testSubject.city isEqualToString:@"O'Fallon"]);
	XCTAssertTrue([self.testSubject.state isEqualToString:@"MO"]);
	XCTAssertTrue([self.testSubject.zip isEqualToString:@"63368"]);
	XCTAssertTrue([self.testSubject.country isEqualToString:@"US"]);
}

@end
