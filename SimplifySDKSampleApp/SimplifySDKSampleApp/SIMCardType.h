#import <Foundation/Foundation.h>

@interface SIMCardType : NSObject
@property (nonatomic, strong) NSString *cardType;

-(NSString *)cardTypeFromCardNumberString:(NSString *)cardNumber;

@end
