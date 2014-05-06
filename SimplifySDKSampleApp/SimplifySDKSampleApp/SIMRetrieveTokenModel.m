#import "SIMRetrieveTokenModel.h"
#import "SIMDigitVerifier.h"
#import "SIMCardType.h"

@interface SIMRetrieveTokenModel ()
@property (nonatomic, strong) SIMDigitVerifier *digitVerifier;
@property (nonatomic, strong, readwrite) NSString *cardNumber;
@property (nonatomic, strong, readwrite) NSString *expirationDate;
@property (nonatomic, strong, readwrite) NSString *expirationMonth;
@property (nonatomic, strong, readwrite) NSString *expirationYear;
@property (nonatomic, strong, readwrite) NSString *formattedCardNumber;
@property (nonatomic, strong, readwrite) NSString *formattedExpirationDate;
@property (nonatomic, strong, readwrite) NSString *cvcCode;
@property (nonatomic, strong, readwrite) NSString *cardType;
@end

@implementation SIMRetrieveTokenModel

- (instancetype) init {
    if (self) {
        self.cardNumber = @"";
        self.expirationDate = @"";
        self.cvcCode = @"";
    }
    return self;
}

- (BOOL)isRetrievalPossible {
    if (self.cardNumber.length > 12 && self.expirationDate.length > 2) {
        return YES;
    }
    return NO;
}

- (void) updateCardNumberWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];

    if (updatedString.length <= 16) {
        self.cardNumber = updatedString;
    }
}

- (void) updateExpirationDateWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if (updatedString.length <= 4) {
        self.expirationDate = updatedString;
    }
}

- (void) updateCVCNumberWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if (updatedString.length <= 4) {
        self.cvcCode = updatedString;
    }
}

- (NSString *)formattedCardNumber {
    NSMutableString *formattedString =[NSMutableString stringWithString:self.cardNumber];
    int index=4;
    
    while (index < formattedString.length && formattedString.length < 19) {
        [formattedString insertString:@" " atIndex:index];
        index +=5;
    }
    
    return formattedString;
}

- (NSString *)formattedExpirationDate {
    if (self.expirationDate.length > 1) {
        return [NSString stringWithFormat:@"%@/%@",self.expirationMonth, self.expirationYear];
    }
    return self.expirationDate;
}

- (NSString *)expirationMonth {
    if (self.expirationDate.length  > 0 && self.expirationDate.length <= 3) {
        return [self.expirationDate substringToIndex:1];
    } else if (self.expirationDate.length > 3){
        return [self.expirationDate substringToIndex:2];
    }
    return @"";
}

- (NSString *)expirationYear {
    if (self.expirationDate.length  > 0 && self.expirationDate.length <= 3) {
        return [self.expirationDate substringFromIndex:1];
    } else if (self.expirationDate.length > 3){
        return [self.expirationDate substringFromIndex:2];
    }
    return @"";
}

- (NSString *)cardType {
    SIMCardType *cardType = [SIMCardType new];
    return [cardType cardTypeFromCardNumberString:self.cardNumber];
}

- (void)retrieveToken {
//    SIMCardTokenRequest *tokenGenerator = [SIMCardTokenRequest new];
//    NSString *token = [tokenGenerator createCardTokenWithCardNumber:self.cardNumber expirationMonth:self.expirationMonth expirationYear:self.expirationYear cvc:self.cvcCode error:nil];
//    NSLog(@"token: %@", token);
}

@end
