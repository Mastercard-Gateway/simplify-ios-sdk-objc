#import "SIMCreditCardToken.h"
@interface SIMCardTokenTests : XCTestCase
@property (nonatomic, strong) SIMCreditCardToken *testSubject;
@end

@implementation SIMCardTokenTests


- (void)testFromDictionary_BuildsObjectFromDictionaryCorrectly {
	NSDictionary *cardDictionary = @{
                                     @"name" : @"MasterCard Customer",
                                     @"type" : @"cardType",
                                     @"last4" : @"1234",
                                     @"addressLine1" : @"2200 MasterCard Blvd",
                                     @"addressLine2" : @"Area 1",
                                     @"addressCity" : @"O'Fallon",
                                     @"addressState" : @"Missouri",
                                     @"addressZip" : @"63368",
                                     @"addressCountry" : @"US",
                                     @"expMonth" : @"05",
                                     @"expYear" : @"15",
                                     @"dateCreated" : @"20140508"
                                     };
	NSDictionary *dictionary = @{@"id" : @"cardTokenID", @"card" : cardDictionary};
    
	self.testSubject = [SIMCreditCardToken cardTokenFromDictionary:dictionary];
    
	XCTAssertTrue([self.testSubject.token isEqualToString:@"cardTokenID"]);
	XCTAssertTrue([self.testSubject.name isEqualToString:@"MasterCard Customer"]);
	XCTAssertTrue([self.testSubject.type isEqualToString:@"cardType"]);
	XCTAssertTrue([self.testSubject.last4 isEqualToString:@"1234"]);
	XCTAssertTrue([self.testSubject.address.addressLine1 isEqualToString:@"2200 MasterCard Blvd"]);
	XCTAssertTrue([self.testSubject.address.addressLine2 isEqualToString:@"Area 1"]);
	XCTAssertTrue([self.testSubject.address.city isEqualToString:@"O'Fallon"]);
	XCTAssertTrue([self.testSubject.address.state isEqualToString:@"Missouri"]);
	XCTAssertTrue([self.testSubject.address.zip isEqualToString:@"63368"]);
	XCTAssertTrue([self.testSubject.address.country isEqualToString:@"US"]);
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:20140508 / 1000];
	XCTAssertEqualObjects(self.testSubject.dateCreated, date);
}

@end