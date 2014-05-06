#import "SIMCardType.h"

@implementation SIMCardType
-(NSString *)cardTypeFromCardNumberString:(NSString *)cardNumber {
    if ([self hasPrefixFromArray:@[@"34", @"37"] inString:cardNumber]) {
        return @"amex";
    } else if ([self hasPrefixFromArray:@[@"622", @"624", @"625", @"626", @"628"] inString:cardNumber]) {
            return @"china-union";
    } else if ([self hasPrefixFromArray:@[@"300", @"301", @"302", @"303", @"304", @"305", @"309", @"36", @"38", @"39"] inString:cardNumber]) {
        return @"dinersclub";
	} else if ([self hasPrefixFromArray:@[@"65", @"6011", @"644", @"645", @"646", @"647", @"648", @"649"] inString:cardNumber]) {
        return @"discover";
    } else if ([self hasPrefixFromArray:@[@"3528", @"3529", @"353", @"354", @"355", @"356", @"357", @"358"] inString:cardNumber]) {
            return @"jcb";
	} else if ([self hasPrefixFromArray:@[@"50", @"51", @"52", @"53", @"54", @"55", @"67"] inString:cardNumber]) {
		return @"mastercard";
	} else if ([cardNumber hasPrefix:@"4"]) {
		return @"visa";
    }
    
    return @"blank";
    
    //Source for Amex: https://secure.cmax.americanexpress.com/Internet/International/japa/SG_en/Merchant/PROSPECT/WorkingWithUs/AvoidingCardFraud/HowToCheckCardFaces/Files/Guide_to_checking_Card_Faces.pdf
    //Source for China Union, Diners Club, Discover, JCB: http://www.discovernetwork.com/merchants/images/Merchant_Marketing_PDF.pdf
    //Source for MasterCard: http://www.mastercard.com/hu/merchant/PDF/ADC.pdf - 2-6
    //Source for Visa: http://usa.visa.com/download/merchants/card-security-features-mini-vcp-111512.pdf
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
