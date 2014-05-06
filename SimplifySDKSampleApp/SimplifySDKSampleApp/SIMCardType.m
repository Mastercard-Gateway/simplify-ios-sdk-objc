#import "SIMCardType.h"

@implementation SIMCardType
-(NSString *)cardTypeFromCardNumberString:(NSString *)cardNumber {
    if ([self hasPrefixFromArray:@[@"34", @"37"] inString:cardNumber]) {
        return @"amex";
    } else if ([self hasPrefixFromArray:@[@"300", @"301", @"302", @"303", @"304", @"305", @"309", @"36", @"38", @"39"] inString:cardNumber]) {
        return @"dinersclub";
	} else if ([self hasPrefixFromArray:@[@"65", @"6011", @"644", @"645", @"646", @"647", @"648", @"649"] inString:cardNumber]) {
        return @"discover";
    } else if ([self hasPrefixFromArray:@[@"3528", @"3529", @"353", @"354", @"355", @"356", @"357", @"358"] inString:cardNumber]) {
            return @"jcb";
	} else if ([self hasPrefixFromArray:@[@"50", @"51", @"52", @"53", @"54", @"55"] inString:cardNumber]) {
		return @"mastercard";
	} else if ([cardNumber hasPrefix:@"4"]) {
		return @"visa";
    }
    
    return @"blank";
}


-(BOOL)hasPrefixFromArray:(NSArray *)prefixArray inString:(NSString *)cardString {
    for (NSString* prefix in prefixArray ) {
        if ( [cardString hasPrefix:prefix] ) {
            return YES;
        }
    }
    return NO;
}
@end
