#import "SIM3DSecureRequestData.h"

@interface SIM3DSecureRequestData()

@property (nonatomic, readwrite) NSDecimalNumber *amount;
@property (nonatomic, readwrite) NSString *currency;
@property (nonatomic, readwrite) NSString *descriptionMessage;

@end

@implementation SIM3DSecureRequestData

-(instancetype)initWithAmount:(NSDecimalNumber *)amount currency:(NSString *)currency description:(NSString *)description {
    
    self = [super init];
    if (self) {
        self.amount = amount ? amount : [NSDecimalNumber decimalNumberWithString:@"0"];
        self.currency = currency ? currency : @"";
        self.descriptionMessage = description ? description : @"";
    }
    return self;
}

@end
