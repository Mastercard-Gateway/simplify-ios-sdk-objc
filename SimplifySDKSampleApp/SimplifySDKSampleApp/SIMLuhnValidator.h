#import <Foundation/Foundation.h>

@interface SIMLuhnValidator : NSObject
-(BOOL)luhnValidateString:(NSString *)cardNumberString;
@end
