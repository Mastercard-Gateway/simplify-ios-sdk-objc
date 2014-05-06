#import "SIMCardType.h"

@interface SIMCardTypeTests : XCTestCase
@property (nonatomic, strong) SIMCardType *testCardType;
@end

@implementation SIMCardTypeTests

- (void)setUp
{
    [super setUp];
    self.testCardType = [SIMCardType new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAmexRangeReturnsAmex {
    NSString *americanExpress = @"amex";
	NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"34"];
	XCTAssertEqualObjects(creditCardTypeString, americanExpress, "amex");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"37"];
	XCTAssertEqualObjects(americanExpress, creditCardTypeString, "amex");
}

-(void)testChinaUnionRangeReturnsChinaUnion {
    NSString *chinaUnion = @"china-union";
	NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"622"];
	XCTAssertEqualObjects(chinaUnion, creditCardTypeString, "china union");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"624"];
	XCTAssertEqualObjects(chinaUnion, creditCardTypeString, "china union");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"625"];
	XCTAssertEqualObjects(chinaUnion, creditCardTypeString, "china union");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"626"];
	XCTAssertEqualObjects(chinaUnion, creditCardTypeString, "china union");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"628"];
	XCTAssertEqualObjects(chinaUnion, creditCardTypeString, "china union");
}

-(void)testDinersClubRangeReturnsDinersClub{
    NSString *dinersClub = @"dinersclub";
	NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"300"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"301"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"302"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"303"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"304"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"305"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"309"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"36"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"38"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"39"];
	XCTAssertEqualObjects(dinersClub, creditCardTypeString, "dinersClub");
}

-(void)testDiscoverCardRangeReturnsDiscover {
    NSString *discover = @"discover";
    NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"65"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"6011"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"644"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"645"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"646"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"647"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"648"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"649"];
	XCTAssertEqualObjects(discover, creditCardTypeString, "discover");
}

-(void)testJCBRangeReturnsJCB {
	NSString *jcb = @"jcb";
    NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"3528"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"3529"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"353"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"354"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"355"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"356"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"357"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"358"];
    XCTAssertEqualObjects(jcb, creditCardTypeString, "jcb");
}

-(void)testMasterCardRangeReturnsMasterCard {
    NSString *mastercard = @"mastercard";
	NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"51"];
	XCTAssertEqualObjects(mastercard, creditCardTypeString, "mastercard");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"52"];
	XCTAssertEqualObjects(mastercard, creditCardTypeString, "mastercard");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"53"];
	XCTAssertEqualObjects(mastercard, creditCardTypeString, "mastercard");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"54"];
	XCTAssertEqualObjects(mastercard, creditCardTypeString, "mastercard");
	creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"55"];
	XCTAssertEqualObjects(mastercard, creditCardTypeString, "mastercard");
    creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"67"];
	XCTAssertEqualObjects(mastercard, creditCardTypeString, "mastercard");
}

-(void)testVisaRangeReturnsVisa {
	NSString *visa = @"visa";
    NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"4"];
	XCTAssertEqualObjects(visa, creditCardTypeString, "visa");
}

-(void)testUnknownRangeReturnsBlankType {
	NSString *blank = @"blank";
    NSString *creditCardTypeString = [self.testCardType cardTypeFromCardNumberString:@"1"];
	XCTAssertEqualObjects(blank, creditCardTypeString, "blank card");
}

@end
