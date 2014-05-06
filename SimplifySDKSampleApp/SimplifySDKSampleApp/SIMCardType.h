#import <Foundation/Foundation.h>

@interface SIMCardType : NSObject
@property (nonatomic, strong, readonly) NSString *cardTypeString;
@property (nonatomic, readonly) int CVCLength;
@property (nonatomic, readonly) int minCardLength;
@property (nonatomic, readonly) int maxCardLength;
+(instancetype)cardTypeFromCardNumberString:(NSString *)cardNumber;
+(BOOL)hasPrefixFromArray:(NSArray *)prefixArray inString:(NSString *)cardString;
@end
