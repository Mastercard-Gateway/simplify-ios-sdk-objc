#import "SIM3DSecureRequestData.h"

@interface SIM3DSecureRequestDataTests : XCTestCase
@property (nonatomic, strong) SIM3DSecureRequestData *testSubject;
@end

@implementation SIM3DSecureRequestDataTests

-(void)testThatSIM3DSecureRequestDataCanBeCreated {
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"15.23"];
    NSString *currency = @"AUD";
    NSString *descriptionMessage = @"Test message";
    
    self.testSubject = [[SIM3DSecureRequestData alloc] initWithAmount:amount currency:currency description:descriptionMessage];
    
    XCTAssertTrue([self.testSubject.amount compare: amount] == NSOrderedSame, @"");
    XCTAssertTrue([self.testSubject.currency isEqual:currency], @"");
    XCTAssertTrue([self.testSubject.descriptionMessage isEqual:descriptionMessage], @"");
}

-(void)testThatSIM3DSecureRequestDataCanBeCreatedWithNilValuesReturnsNilSafeValues {
    
    self.testSubject = [[SIM3DSecureRequestData alloc] initWithAmount:nil currency:nil description:nil];
    
    XCTAssertNotNil(self.testSubject.amount, @"");
    XCTAssertNotNil(self.testSubject.currency, @"");
    XCTAssertNotNil(self.testSubject.descriptionMessage, @"");
}


@end
