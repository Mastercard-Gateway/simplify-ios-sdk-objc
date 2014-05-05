#import "SIMDigitVerifier.h"

@implementation SIMDigitVerifier

-(BOOL)isDigit:(NSString *)potentialDigit {
    BOOL isDigit = NO;
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([potentialDigit rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        isDigit = YES;
    }
    return isDigit;
}

@end
