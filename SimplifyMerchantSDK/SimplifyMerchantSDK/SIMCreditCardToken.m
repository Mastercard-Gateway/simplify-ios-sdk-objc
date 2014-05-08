#import "SIMCreditCardToken.h"

@interface SIMCreditCardToken ()

@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) NSString *id;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSString *last4;
@property (nonatomic, readwrite) SIMAddress *address;
@property (nonatomic, readwrite) NSNumber *expMonth;
@property (nonatomic, readwrite) NSNumber *expYear;
@property (nonatomic, readwrite) NSDate *dateCreated;

@end

@implementation SIMCreditCardToken

- (instancetype)initWithToken:(NSString *)token id:(NSString *)id name:(NSString *)name type:(NSString *)type last4:(NSString *)last4
address:(SIMAddress *)address expMonth:(NSNumber *)expMonth expYear:(NSNumber *)expYear dateCreated:(NSDate *)dateCreated {
    
    self = [super init];
	if (self) {
		self.token = token;
		self.id = id;
		self.name = name;
		self.type = type;
		self.last4 = last4;
        SIMAddress *address = [[SIMAddress alloc] initWithName:address.name addressLine1:address.addressLine1 addressLine2:address.addressLine2 city:address.city
                                                         state:address.state zip:address.zip];
		self.expMonth = expMonth;
		self.expYear = expYear;
		self.dateCreated = dateCreated;
	}
	return self;
}

+ (SIMCreditCardToken *)cardTokenFromDictionary:(NSDictionary *)dictionary {
    
	SIMCreditCardToken *cardToken = [[SIMCreditCardToken alloc] init];
	cardToken.token = dictionary[@"id"];
	cardToken.id = dictionary[@"card"][@"id"];
	cardToken.name = dictionary[@"card"][@"name"];
	cardToken.type = dictionary[@"card"][@"type"];
	cardToken.last4 = dictionary[@"card"][@"last4"];
    SIMAddress *address = [[SIMAddress alloc] initWithName:dictionary[@"card"][@"name"] addressLine1:dictionary[@"card"][@"addressLine1"] addressLine2:dictionary[@"card"][@"addressLine2"] city:dictionary[@"card"][@"addressCity"] state:dictionary[@"card"][@"addressState"]
                                                       zip:dictionary[@"card"][@"addressZip"]];
    cardToken.address = address;
	cardToken.expMonth = dictionary[@"card"][@"expMonth"];
	cardToken.expYear = dictionary[@"card"][@"expYear"];
	NSString *date = [dictionary[@"card"][@"dateCreated"] description];
	cardToken.dateCreated = [[NSDate alloc] initWithTimeIntervalSince1970:[date longLongValue] / 1000];
	return cardToken;
}

@end