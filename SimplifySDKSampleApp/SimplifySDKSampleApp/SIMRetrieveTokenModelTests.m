#import "SIMCheckoutModel.h"

@interface SIMRetrieveTokenModelTests : XCTestCase
@property (nonatomic, strong) SIMCheckoutModel *testCheckoutModel;
@end

@implementation SIMRetrieveTokenModelTests

- (void)setUp
{
    [super setUp];
    self.testCheckoutModel = [SIMCheckoutModel new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithCartInitializesCheckoutModelProperly
{
    XCTAssertEqualObjects(self.testCheckoutModel.chargeAmount, @"0", "no charge amount");
    XCTAssertEqualObjects(self.testCheckoutModel.cardNumber, @"", "no card number!");
    XCTAssertEqualObjects(self.testCheckoutModel.expirationDate, @"", "no expiration!");
    XCTAssertEqualObjects(self.testCheckoutModel.formattedCardNumber, @"", "no charge amount");
    XCTAssertEqualObjects(self.testCheckoutModel.formattedCardNumber, @"", "no card number!");
    XCTAssertEqualObjects(self.testCheckoutModel.formattedExpirationDate, @"", "no expiration!");
    XCTAssertEqualObjects(self.testCheckoutModel.cvcCode, @"", "no cvc code");
    XCTAssertEqualObjects(self.testCheckoutModel.cardTypeString, @"blank", "blank type");
}

//Tests for format
-(void) testFormattedChargeAmountCorrectlyFormatsFor0Dollars {
    NSString *expectedFormattedChargeAmount = @"$0.00";
    
    [self.testCheckoutModel updateChargeAmountWithString:@"0"];
    
    NSString *actualChargeAmount = self.testCheckoutModel.formattedChargeAmount;
    
    XCTAssertEqualObjects(expectedFormattedChargeAmount, actualChargeAmount, "zero dollars");
}

-(void) testFormattedChargeAmountCorrectlyFormatsFor8Dollars56Cents {
    NSString *expectedFormattedChargeAmount = @"$8.56";
    
    [self.testCheckoutModel updateChargeAmountWithString:@"856"];
    
    NSString *actualChargeAmount = self.testCheckoutModel.formattedChargeAmount;
    
    XCTAssertEqualObjects(expectedFormattedChargeAmount, actualChargeAmount, "8.56");
}

-(void) testFormattedExpirationDateFormatsCorrectlyWhenStringIsOneDigitLong {
    NSString *expectedExpirationDate = @"2";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"2"];
    
    NSString *actualExpirationDate = self.testCheckoutModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testCheckoutModel.expirationMonth;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "one digit");
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationMonth, "one digit");
}

-(void) testFormattedExpirationDateFormatsCorrectlyWhenStringIsTwoDigitsLong {
    NSString *expectedExpirationDate = @"2/1";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"21"];
    
    NSString *actualExpirationDate = self.testCheckoutModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testCheckoutModel.expirationMonth;
    NSString *actualExpirationYear = self.testCheckoutModel.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "two digits");
    XCTAssertEqualObjects(@"2", actualExpirationMonth, "one digit");
    XCTAssertEqualObjects(@"1", actualExpirationYear, "one digit");
}

-(void) testFormattedExpirationDateFormatsCorrectlyWhenStringIsThreeDigitsLong {
    NSString *expectedExpirationDate = @"2/24";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"224"];
    
    NSString *actualExpirationDate = self.testCheckoutModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testCheckoutModel.expirationMonth;
    NSString *actualExpirationYear = self.testCheckoutModel.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "three digits");
    XCTAssertEqualObjects(@"2", actualExpirationMonth, "one digit");
    XCTAssertEqualObjects(@"24", actualExpirationYear, "two digits");
}

-(void) testFormattedExpirationDateFormatsCorrectlyWhenStringIsFourDigitsLong {
    NSString *expectedExpirationDate = @"12/14";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"1214"];
    
    NSString *actualExpirationDate = self.testCheckoutModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testCheckoutModel.expirationMonth;
    NSString *actualExpirationYear = self.testCheckoutModel.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "four digits");
    XCTAssertEqualObjects(@"12", actualExpirationMonth, "two digits");
    XCTAssertEqualObjects(@"14", actualExpirationYear, "two digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith4NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234";
    
    [self.testCheckoutModel updateCardNumberWithString:@"1234"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "four digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith5NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5";
    
    [self.testCheckoutModel updateCardNumberWithString:@"12345"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "five digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith11NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5678 901";
    
    [self.testCheckoutModel updateCardNumberWithString:@"12345678901"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "11 digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith16NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5678 9012 3456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"1234567890123456"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "16 digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith4NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434";
    
    [self.testCheckoutModel updateCardNumberWithString:@"3434"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "four digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith5NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434 5";
    
    [self.testCheckoutModel updateCardNumberWithString:@"34345"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "five digits");
}

-(void) testFormatttedCreditCardStringFormatsCorrectlyWith11NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434 567890 1";
    
    [self.testCheckoutModel updateCardNumberWithString:@"34345678901"];
    
    NSString *actualCreditCardString = self.testCheckoutModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "11 digits");
}

//Tests for isRetrivalPossible, isExpirationDateValid, and isCardNumberValid
-(void)testIsCheckoutPossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigits {
    [self.testCheckoutModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testCheckoutModel updateExpirationDateWithString:@"123"];
    [self.testCheckoutModel updateCVCNumberWithString:@"123"];

    XCTAssertTrue([self.testCheckoutModel isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testCheckoutModel isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testCheckoutModel isCheckoutPossible], "should be yes");
}

-(void)testIsCheckoutPossibleReturnsNoWhenCardNumberIsLessThanMinimumNumberOfDigitsPerCardType {
    [self.testCheckoutModel updateCardNumberWithString:@"412345678901"];
    [self.testCheckoutModel updateExpirationDateWithString:@"123"];
    XCTAssertFalse([self.testCheckoutModel isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testCheckoutModel isCheckoutPossible], "should be no, less than minumum for visa");
}

-(void)testIsCheckoutPossibleReturnsNoWhenCardNumberIsMoreThanMaximumNumberOfDigitsPerCardType {
    [self.testCheckoutModel updateCardNumberWithString:@"34123456789013"];
    [self.testCheckoutModel updateExpirationDateWithString:@"123"];
    XCTAssertFalse([self.testCheckoutModel isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testCheckoutModel isCheckoutPossible], "should be no, more than max for amex");
}

-(void)testIsCheckoutPossibleReturnsNoWhenCardNumberIsNotLuhnValidated {
    [self.testCheckoutModel updateCardNumberWithString:@"5105 1051 0510 5102"];
    [self.testCheckoutModel updateExpirationDateWithString:@"123"];
    XCTAssertFalse([self.testCheckoutModel isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testCheckoutModel isCheckoutPossible], "should be no, more than max for amex");
}

-(void)testIsCheckoutPossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigitsButNoCVCCode {
    [self.testCheckoutModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testCheckoutModel updateExpirationDateWithString:@"123"];
    XCTAssertTrue([self.testCheckoutModel isExpirationDateValid], "should be yes");
    XCTAssertTrue([self.testCheckoutModel isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testCheckoutModel isCheckoutPossible], "should be yes");
}

-(void)testIsCheckoutPossibleReturnsNoWhenExpirationDateIsLessThanThreeDigits {
    [self.testCheckoutModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testCheckoutModel updateExpirationDateWithString:@"12"];
    XCTAssertFalse([self.testCheckoutModel isExpirationDateValid], "should be no");
    XCTAssertFalse([self.testCheckoutModel isCheckoutPossible], "should be no");
}

-(void)testIsCheckoutPossibleReturnsNoWhenExpirationDateIsExpired {
    [self.testCheckoutModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testCheckoutModel updateExpirationDateWithString:@"4/14"];
    XCTAssertFalse([self.testCheckoutModel isExpirationDateValid], "should be no");
    XCTAssertFalse([self.testCheckoutModel isCheckoutPossible], "should be no");
}

//Tests for updating charge amount, card number, expiration date, and CVC code
-(void)testUpdateChargeAmountWithStringCorrectlyRemovesSpaces {
    NSString *expectedStringWithNoSpaces = @"856";
    
    [self.testCheckoutModel updateChargeAmountWithString:@"8 56"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.chargeAmount, "no spaces");
}

-(void)testUpdateChargeAmountWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"856";
    
    [self.testCheckoutModel updateChargeAmountWithString:@"8 s56d"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.chargeAmount, "no non digits");
}

-(void)testUpdateChargeAmountWithStringDoesNotAddMoreThan8Digits {
    NSString *expectedStringWithNoSpaces = @"85612345";
    
    [self.testCheckoutModel updateChargeAmountWithString:@"85612345"];
    
    [self.testCheckoutModel updateChargeAmountWithString:@"85612345343"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.chargeAmount, "no non digits");
}

-(void)testUpdateCardNumberWithStringCorrectlyRemovesSpaces {
    NSString *expectedStringWithNoSpaces = @"123434563456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"1234 3456 3456"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"123434563456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"1234 a3456s 3456s"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no non-digits");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfOver19Digits {
    [self.testCheckoutModel updateCardNumberWithString:@"1234 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"1234345634563456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"1234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfDinersAndOver14Digits {
    [self.testCheckoutModel updateCardNumberWithString:@"3004 3456 3456 34"];
    NSString *expectedStringWithNoSpaces = @"30043456345634";
    
    [self.testCheckoutModel updateCardNumberWithString:@"3004 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfAmexAndOver15Digits {
    [self.testCheckoutModel updateCardNumberWithString:@"34234 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"34234345634563456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"341234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfMasterCardAndOver16Digits {
    [self.testCheckoutModel updateCardNumberWithString:@"3528 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"3528345634563456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"35289 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfJCBAndOver16Digits {
    [self.testCheckoutModel updateCardNumberWithString:@"5134 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"5134345634563456";
    
    [self.testCheckoutModel updateCardNumberWithString:@"351234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cardNumber, "no spaces");
}

-(void)testUpdateExpirationDateWithStringCorrectlyRemovesSlashes {
    NSString *expectedStringWithNoSpaces = @"24";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"24"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "no spaces");
}

-(void)testUpdateExpirationDateWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"24";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"2a4"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "only digits");
}

-(void)testUpdateExpirationDateWithStringDoesNotUpdateExpirationDateIfOver4Digits {
    [self.testCheckoutModel updateExpirationDateWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringIsNot4DigitsLongIfMonthDoesNotStartWith0or1 {
    [self.testCheckoutModel updateExpirationDateWithString:@"234"];
    NSString *expectedStringWithNoSpaces = @"234";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"2345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringIfStringIsEmpty {
    [self.testCheckoutModel updateExpirationDateWithString:@""];
    NSString *expectedStringWithNoSpaces = @"";
    
    [self.testCheckoutModel updateExpirationDateWithString:@""];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "no digits");
}

-(void)testUpdateExpirationDateWithStringDoesNotUpdateExpirationDateIfMonthMoreThan12 {
    [self.testCheckoutModel updateExpirationDateWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testCheckoutModel updateExpirationDateWithString:@"1345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringDoesUpdateExpirationDateIfMonthStartsWithZero {
    [self.testCheckoutModel updateExpirationDateWithString:@"0234"];
    NSString *expectedStringWithNoSpaces = @"0234";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.expirationDate, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverFourDigitsIfCardTypeBlank {
    [self.testCheckoutModel updateCardNumberWithString:@"1"];
    [self.testCheckoutModel updateCVCNumberWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testCheckoutModel updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cvcCode, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverFourDigitsIfCardTypeAmex {
    [self.testCheckoutModel updateCardNumberWithString:@"341234"];
    [self.testCheckoutModel updateCVCNumberWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testCheckoutModel updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cvcCode, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverThreeDigitsIfCardTypeNotBlankOrAmex {
    [self.testCheckoutModel updateCardNumberWithString:@"41234"];
    [self.testCheckoutModel updateCVCNumberWithString:@"123"];
    NSString *expectedStringWithNoSpaces = @"123";
    
    [self.testCheckoutModel updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cvcCode, "three digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testCheckoutModel updateCVCNumberWithString:@"12sf34"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testCheckoutModel.cvcCode, "four digits");
}


@end
