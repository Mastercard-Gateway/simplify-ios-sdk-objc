#import "SIMAddress.h"

@interface SIMCreditCardToken : NSObject

@property (nonatomic, readonly) NSString *token;
@property (nonatomic, readonly) NSString *tokenId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSNumber *last4;
@property (nonatomic, readonly) SIMAddress *address;
@property (nonatomic, readonly) NSNumber *expMonth;
@property (nonatomic, readonly) NSNumber *expYear;
@property (nonatomic, readonly) NSDate *dateCreated;

- (id)initWithToken:(NSString *)token tokenId:(NSString *)tokenId name:(NSString *)name type:(NSString *)type last4:(NSNumber *)last4
address:(SIMAddress *)address expMonth:(NSNumber *)expMonth expYear:(NSNumber *)expYear dateCreated:(NSDate *)dateCreated;

+ (SIMCreditCardToken *)cardTokenFromDictionary:(NSDictionary *)dictionary;

@end