#import "SIMAddress.h"

@interface SIMCreditCardToken : NSObject

@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *last4;
@property (nonatomic, readonly) SIMAddress *address;
@property (nonatomic, readonly) NSNumber *expMonth;
@property (nonatomic, readonly) NSNumber *expYear;
@property (nonatomic, readonly) NSDate *dateCreated;

- (id)initWithToken:(NSString *)token id:(NSString *)id name:(NSString *)name type:(NSString *)type last4:(NSString *)last4
address:(SIMAddress *)address expMonth:(NSNumber *)expMonth expYear:(NSNumber *)expYear dateCreated:(NSDate *)dateCreated;

+ (SIMCreditCardToken *)cardTokenFromDictionary:(NSDictionary *)dictionary;

@end