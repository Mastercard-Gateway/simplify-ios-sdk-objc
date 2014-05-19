#import "SIMChargeCardModel.h"

@interface SIMChargeCardModelTests : XCTestCase
@property (nonatomic, strong) SIMChargeCardModel *testChargeCardModel;
@end

@implementation SIMChargeCardModelTests

-(void)setUp
{
    [super setUp];
    NSError *error;
    
    self.testChargeCardModel = [[SIMChargeCardModel alloc] initWithApiKey:@"sbpb_N2ZkOGIwZWYtYTg3My00OTE1LWI3ZjgtMzZhMzZhZTAyYTY5" error:&error];
}

-(void)tearDown
{
    [super tearDown];
}

-(void)testInitWithCartInitializesChargeCardModelProperly
{
    XCTAssertEqualObjects(self.testChargeCardModel.cardNumber, @"", "no card number");
    XCTAssertEqualObjects(self.testChargeCardModel.expirationDate, @"", "no expiration");
    XCTAssertEqualObjects(self.testChargeCardModel.formattedCardNumber, @"", "no formatted card number");
    XCTAssertEqualObjects(self.testChargeCardModel.formattedExpirationDate, @"", "no formatted expiration");
    XCTAssertEqualObjects(self.testChargeCardModel.cvcCode, @"", "no cvc code");
    XCTAssertEqualObjects(self.testChargeCardModel.cardTypeString, @"blank", "blank type");
}

//Tests for format
-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsOneDigitLong {
    NSString *expectedExpirationDate = @"2";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"2"];
    
    NSString *actualExpirationDate = self.testChargeCardModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testChargeCardModel.expirationMonth;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "one digit");
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationMonth, "one digit");
}

-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsTwoDigitsLong {
    NSString *expectedExpirationDate = @"2/1";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"21"];
    
    NSString *actualExpirationDate = self.testChargeCardModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testChargeCardModel.expirationMonth;
    NSString *actualExpirationYear = self.testChargeCardModel.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "two digits");
    XCTAssertEqualObjects(@"2", actualExpirationMonth, "one digit");
    XCTAssertEqualObjects(@"1", actualExpirationYear, "one digit");
}

-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsThreeDigitsLong {
    NSString *expectedExpirationDate = @"2/24";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"224"];
    
    NSString *actualExpirationDate = self.testChargeCardModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testChargeCardModel.expirationMonth;
    NSString *actualExpirationYear = self.testChargeCardModel.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "three digits");
    XCTAssertEqualObjects(@"2", actualExpirationMonth, "one digit");
    XCTAssertEqualObjects(@"24", actualExpirationYear, "two digits");
}

-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsFourDigitsLong {
    NSString *expectedExpirationDate = @"12/14";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"1214"];
    
    NSString *actualExpirationDate = self.testChargeCardModel.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testChargeCardModel.expirationMonth;
    NSString *actualExpirationYear = self.testChargeCardModel.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "four digits");
    XCTAssertEqualObjects(@"12", actualExpirationMonth, "two digits");
    XCTAssertEqualObjects(@"14", actualExpirationYear, "two digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith4NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234";
    
    [self.testChargeCardModel updateCardNumberWithString:@"1234"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "four digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith5NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5";
    
    [self.testChargeCardModel updateCardNumberWithString:@"12345"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "five digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith11NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5678 901";
    
    [self.testChargeCardModel updateCardNumberWithString:@"12345678901"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "11 digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith16NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5678 9012 3456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"1234567890123456"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "16 digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith4NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434";
    
    [self.testChargeCardModel updateCardNumberWithString:@"3434"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "four digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith5NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434 5";
    
    [self.testChargeCardModel updateCardNumberWithString:@"34345"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "five digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith11NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434 567890 1";
    
    [self.testChargeCardModel updateCardNumberWithString:@"34345678901"];
    
    NSString *actualCreditCardString = self.testChargeCardModel.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "11 digits");
}

//Tests for isRetrivalPossible, isExpirationDateValid, and isCardNumberValid
-(void)testIsCardChargePossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigits {
    [self.testChargeCardModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testChargeCardModel updateExpirationDateWithString:@"1223"];
    [self.testChargeCardModel updateCVCNumberWithString:@"123"];

    XCTAssertTrue([self.testChargeCardModel isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testChargeCardModel isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testChargeCardModel isCVCCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testChargeCardModel isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsYesWhenCardTypeBlankAndCVCLengthIs3 {
    [self.testChargeCardModel updateCardNumberWithString:@"6709507858655272"];
    [self.testChargeCardModel updateExpirationDateWithString:@"123"];
    [self.testChargeCardModel updateCVCNumberWithString:@"123"];
    
    XCTAssertTrue([self.testChargeCardModel isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testChargeCardModel isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testChargeCardModel isCVCCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testChargeCardModel isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsNoWhenCardNumberIsLessThanMinimumNumberOfDigitsPerCardType {
    [self.testChargeCardModel updateCardNumberWithString:@"412345678901"];
    [self.testChargeCardModel updateExpirationDateWithString:@"123"];
    XCTAssertFalse([self.testChargeCardModel isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testChargeCardModel isCardChargePossible], "should be no, less than minumum for visa");
}

-(void)testIsCardChargePossibleReturnsNoWhenCardNumberIsMoreThanMaximumNumberOfDigitsPerCardType {
    [self.testChargeCardModel updateCardNumberWithString:@"34123456789013"];
    [self.testChargeCardModel updateExpirationDateWithString:@"123"];
    XCTAssertFalse([self.testChargeCardModel isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testChargeCardModel isCardChargePossible], "should be no, more than max for amex");
}

-(void)testIsCardChargePossibleReturnsNoWhenCardNumberIsNotLuhnValidated {
    [self.testChargeCardModel updateCardNumberWithString:@"5105 1051 0510 5102"];
    [self.testChargeCardModel updateExpirationDateWithString:@"123"];
    XCTAssertFalse([self.testChargeCardModel isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testChargeCardModel isCardChargePossible], "should be no, more than max for amex");
}

-(void)testIsCardChargePossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigitsButNoCVCCode {
    [self.testChargeCardModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testChargeCardModel updateExpirationDateWithString:@"123"];
    XCTAssertTrue([self.testChargeCardModel isExpirationDateValid], "should be yes");
    XCTAssertTrue([self.testChargeCardModel isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testChargeCardModel isCVCCodeValid], "should be valid with no code");
    XCTAssertTrue([self.testChargeCardModel isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsNoWhenExpirationDateIsLessThanThreeDigits {
    [self.testChargeCardModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testChargeCardModel updateExpirationDateWithString:@"12"];
    XCTAssertFalse([self.testChargeCardModel isExpirationDateValid], "should be no");
    XCTAssertFalse([self.testChargeCardModel isCardChargePossible], "should be no");
}

-(void)testIsCardChargePossibleReturnsNoWhenExpirationDateIsExpired {
    [self.testChargeCardModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testChargeCardModel updateExpirationDateWithString:@"4/14"];
    XCTAssertFalse([self.testChargeCardModel isExpirationDateValid], "should be no");
    XCTAssertFalse([self.testChargeCardModel isCardChargePossible], "should be no");
}

-(void)testIsCardChargePossibleReturnsNoWhenCVCCodeIsNotLongEnough {
    [self.testChargeCardModel updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testChargeCardModel updateCVCNumberWithString:@"12"];
    XCTAssertFalse([self.testChargeCardModel isCVCCodeValid], "should be no");
    XCTAssertFalse([self.testChargeCardModel isCardChargePossible], "should be no");
}

//Tests for updating charge amount, card number, expiration date, and CVC code
-(void)testUpdateCardNumberWithStringCorrectlyRemovesSpaces {
    NSString *expectedStringWithNoSpaces = @"123434563456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"1234 3456 3456"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"123434563456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"1234 a3456s 3456s"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no non-digits");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfOver19Digits {
    [self.testChargeCardModel updateCardNumberWithString:@"1234 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"1234345634563456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"1234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfDinersAndOver14Digits {
    [self.testChargeCardModel updateCardNumberWithString:@"3004 3456 3456 34"];
    NSString *expectedStringWithNoSpaces = @"30043456345634";
    
    [self.testChargeCardModel updateCardNumberWithString:@"3004 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfAmexAndOver15Digits {
    [self.testChargeCardModel updateCardNumberWithString:@"34234 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"34234345634563456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"341234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfMasterCardAndOver16Digits {
    [self.testChargeCardModel updateCardNumberWithString:@"3528 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"3528345634563456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"35289 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfJCBAndOver16Digits {
    [self.testChargeCardModel updateCardNumberWithString:@"5134 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"5134345634563456";
    
    [self.testChargeCardModel updateCardNumberWithString:@"351234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cardNumber, "no spaces");
}

-(void)testUpdateExpirationDateWithStringCorrectlyRemovesSlashes {
    NSString *expectedStringWithNoSpaces = @"24";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"24"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "no spaces");
}

-(void)testUpdateExpirationDateWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"24";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"2a4"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "only digits");
}

-(void)testUpdateExpirationDateWithStringDoesNotAllow00ForMonth {
    NSString *expectedStringWithNoDoubleZero = @"024";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"024"];
    [self.testChargeCardModel updateExpirationDateWithString:@"0024"];
    
    XCTAssertEqualObjects(expectedStringWithNoDoubleZero, self.testChargeCardModel.expirationDate, "no double zero for month");
}

-(void)testUpdateExpirationDateWithStringDoesNotUpdateExpirationDateIfOver4Digits {
    [self.testChargeCardModel updateExpirationDateWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringIsNot4DigitsLongIfMonthDoesNotStartWith0or1 {
    [self.testChargeCardModel updateExpirationDateWithString:@"234"];
    NSString *expectedStringWithNoSpaces = @"234";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"2345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringIfStringIsEmpty {
    [self.testChargeCardModel updateExpirationDateWithString:@""];
    NSString *expectedStringWithNoSpaces = @"";
    
    [self.testChargeCardModel updateExpirationDateWithString:@""];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "no digits");
}

-(void)testUpdateExpirationDateWithStringDoesNotUpdateExpirationDateIfMonthMoreThan12 {
    [self.testChargeCardModel updateExpirationDateWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testChargeCardModel updateExpirationDateWithString:@"1345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringDoesUpdateExpirationDateIfMonthStartsWithZero {
    [self.testChargeCardModel updateExpirationDateWithString:@"0234"];
    NSString *expectedStringWithNoSpaces = @"0234";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.expirationDate, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverFourDigitsIfCardTypeBlank {
    [self.testChargeCardModel updateCardNumberWithString:@"1"];
    [self.testChargeCardModel updateCVCNumberWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testChargeCardModel updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cvcCode, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverFourDigitsIfCardTypeAmex {
    [self.testChargeCardModel updateCardNumberWithString:@"341234"];
    [self.testChargeCardModel updateCVCNumberWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testChargeCardModel updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cvcCode, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverThreeDigitsIfCardTypeNotBlankOrAmex {
    [self.testChargeCardModel updateCardNumberWithString:@"41234"];
    [self.testChargeCardModel updateCVCNumberWithString:@"123"];
    NSString *expectedStringWithNoSpaces = @"123";
    
    [self.testChargeCardModel updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cvcCode, "three digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testChargeCardModel updateCVCNumberWithString:@"12sf34"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testChargeCardModel.cvcCode, "four digits");
}


@end
