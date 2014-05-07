#import "SIMRetrieveTokenModel.h"
#import <Simplify/SIMDigitVerifier.h>
#import <Simplify/SIMAPIManager.h>
#import <Simplify/SIMLuhnValidator.h>

@interface SIMRetrieveTokenModel ()
@property (nonatomic, strong) SIMDigitVerifier *digitVerifier;
@property (nonatomic, strong, readwrite) NSString *chargeAmount;
@property (nonatomic, strong, readwrite) NSString *cardNumber;
@property (nonatomic, strong, readwrite) NSString *expirationDate;
@property (nonatomic, strong, readwrite) NSString *expirationMonth;
@property (nonatomic, strong, readwrite) NSString *expirationYear;
@property (nonatomic, strong, readwrite) NSString *formattedChargeAmount;
@property (nonatomic, strong, readwrite) NSString *formattedCardNumber;
@property (nonatomic, strong, readwrite) NSString *formattedExpirationDate;
@property (nonatomic, strong, readwrite) NSString *cvcCode;
@property (nonatomic, strong, readwrite) NSString *cardTypeString;
@property (nonatomic, readwrite) int cvcLength;
@property (nonatomic, readwrite) int cardNumberMinLength;
@property (nonatomic, readwrite) int cardNumberMaxLength;
@end

@implementation SIMRetrieveTokenModel

- (instancetype) init {
    if (self) {
        self.cardNumber = @"";
        self.expirationDate = @"";
        self.cvcCode = @"";
        self.chargeAmount = @"0";
    }
    return self;
}

- (BOOL)isRetrievalPossible {
    if ([self isCardNumberValid] && [self isExpirationDateValid]) {
        return YES;
    }
    return NO;
}

-(BOOL)isCardNumberValid {
    if ((self.cardNumber.length >= self.cardNumberMinLength) && (self.cardNumber.length <= self.cardNumberMaxLength)) {
        SIMLuhnValidator *luhnValidator = [SIMLuhnValidator new];
        return [luhnValidator luhnValidateString:self.cardNumber];
    }
    return NO;
}

-(BOOL)isExpirationDateValid {
    if ((self.expirationDate.length > 2) && [self expirationDateInFuture]) {
        return YES;
    }
    return NO;
}

-(BOOL)expirationDateInFuture {
    NSDate *currentDate = [NSDate date];
    int expirationMonthInt = [self.expirationMonth intValue] + 1;
    NSString *dateString = [NSString stringWithFormat:@"%d-20%@", expirationMonthInt, self.expirationYear];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM-yyyy";
    NSDate *expirationDate = [dateFormatter dateFromString:dateString];
    return [expirationDate compare:currentDate] == NSOrderedDescending || [expirationDate compare:currentDate] == NSOrderedSame;
}

- (void) updateChargeAmountWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (updatedString.length <= 8) {
        self.chargeAmount = updatedString;
    }
}

- (void) updateCardNumberWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];

    if (updatedString.length <= self.cardNumberMaxLength) {
        self.cardNumber = updatedString;
    }
}

- (void) updateExpirationDateWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if (updatedString.length > 0) {
        int firstDigit = (int)([updatedString characterAtIndex:0] - '0');

    
        if (updatedString.length <= 3) {
            self.expirationDate = updatedString;
        
        } else if ((firstDigit <= 1) && (updatedString.length == 4)) {
            int secondDigit = (int)([updatedString characterAtIndex:1] - '0');
            if (firstDigit == 0) {
                self.expirationDate = updatedString;
            } else if ((firstDigit == 1) && (secondDigit < 3)) {
                self.expirationDate = updatedString;
            }
        }
    } else {
        self.expirationDate = updatedString;
    }
}


- (void) updateCVCNumberWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (updatedString.length <= self.cvcLength) {
        self.cvcCode = updatedString;
    }
}

- (NSString *)formattedChargeAmount {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSDecimalNumber *convertedAmount = [NSDecimalNumber decimalNumberWithString:self.chargeAmount];
    NSDecimalNumber *chargeInDollars = [convertedAmount decimalNumberByMultiplyingByPowerOf10:-2];
    return [currencyFormatter stringFromNumber:chargeInDollars];
}


- (NSString *)formattedCardNumber {
    NSMutableString *formattedString =[NSMutableString stringWithString:self.cardNumber];
    if (![self.cardTypeString isEqual: @"amex"]) {
        int index=4;
    
        while (index < formattedString.length && formattedString.length < 23) {
            [formattedString insertString:@" " atIndex:index];
            index +=5;
        }
    } else {
        if (self.cardNumber.length > 4 && self.cardNumber.length < 10) {
            [formattedString insertString:@" " atIndex:4];
        } else if (self.cardNumber.length >= 10) {
            [formattedString insertString:@" " atIndex:4];
            [formattedString insertString:@" " atIndex:11];
        }
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

- (NSString *)cardTypeString {
    return self.cardType.cardTypeString;
}

- (SIMCardType *)cardType {
    return [SIMCardType cardTypeFromCardNumberString:self.cardNumber];
}

- (int)cvcLength {
    return self.cardType.CVCLength;
}

- (int)cardNumberMaxLength {
    return self.cardType.maxCardLength;
}

- (int)cardNumberMinLength {
    return self.cardType.minCardLength;
}

- (void)retrieveToken {
    SIMAPIManager *apiManager = [[SIMAPIManager alloc] initWithPublicApiKey:@"sbpb_OWNjNGE3MTQtYzA4NC00ODdmLTlkOWItYjk1OWMzMWQ0NDUy" error:nil];
    
    [apiManager createCardTokenWithExpirationMonth:self.expirationMonth expirationYear:self.expirationYear cardNumber:self.cardNumber cvc:self.cvcCode completionHander:^(NSString *cardToken, NSError *error) {
        if (error) {
            NSLog(@"error:%@", error);
            [self.delegate processCardToken:cardToken WithError:error];
        } else {
            NSLog(@"token: %@", cardToken);
            [self.delegate processCardToken:cardToken WithError:nil];
        }
    }];
    

}

@end
