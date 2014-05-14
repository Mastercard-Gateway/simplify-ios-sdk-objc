#import "SIMLuhnValidator.h"
#import "SIMDigitVerifier.h"
@implementation SIMLuhnValidator

-(BOOL)luhnValidateString:(NSString *)cardNumberString {
    SIMDigitVerifier *digitVerifier = [SIMDigitVerifier new];
    if ([digitVerifier isDigit:cardNumberString]) {
        
        int oddSum = 0;
        int evenSum = 0;
        int initialValue = (int)cardNumberString.length - 1;
        
        BOOL isOdd = YES;
        
        for (int i = initialValue; i >= 0; i--) {
        
            int digit = (int)([cardNumberString characterAtIndex:i] - '0');
            
            if (isOdd) {
                oddSum += digit;
            } else {
                evenSum += digit / 5 + (2 * digit) % 10;
            }
            
            isOdd = !isOdd;
        }
        
        int totalSum = oddSum + evenSum;
        
        return (totalSum % 10 == 0);
    }
    return NO;
}

@end
