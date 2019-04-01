#import "SIMCreditCardToken.h"
#import "SIM3DSecureData.h"

@interface SIMCreditCardToken ()

@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, readwrite) NSString *tokenId;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) NSNumber *last4;
@property (nonatomic, readwrite) SIMAddress *address;
@property (nonatomic, readwrite) NSNumber *expMonth;
@property (nonatomic, readwrite) NSNumber *expYear;
@property (nonatomic, readwrite) NSDate *dateCreated;
@property (nonatomic, readwrite) SIM3DSecureData *threeDSecureData;

@end

@implementation SIMCreditCardToken

-(instancetype)initWithToken:(NSString *)token tokenId:(NSString *)tokenId name:(NSString *)name type:(NSString *)type last4:(NSNumber *)last4
address:(SIMAddress *)address expMonth:(NSNumber *)expMonth expYear:(NSNumber *)expYear dateCreated:(NSDate *)dateCreated threeDSecureData:(SIM3DSecureData *)threeDSecureData {
    
    self = [super init];
	if (self) {
		self.token = token ? token : @"";
		self.tokenId = tokenId ? tokenId : @"";
		self.name = name ? name : @"";
		self.type = type ? type : @"";
		self.last4 = last4 ? last4 : @0;
        if(address) {
            self.address = address;
        } else {
            self.address = [[SIMAddress alloc] initWithName:nil addressLine1:nil addressLine2:nil city:nil state:nil zip:nil];
        }
		self.expMonth = expMonth ? expMonth : @0;
		self.expYear = expYear ? expYear : @0;
		self.dateCreated = dateCreated ? dateCreated : [NSDate date];
        self.threeDSecureData = threeDSecureData;
	}
	return self;
}

+(SIMCreditCardToken *)cardTokenFromDictionary:(NSDictionary *)dictionary {
    
	SIMCreditCardToken *cardToken = [[SIMCreditCardToken alloc] init];
	cardToken.token = dictionary[@"id"];
	cardToken.tokenId = dictionary[@"card"][@"id"];
	cardToken.name = dictionary[@"card"][@"name"];
	cardToken.type = dictionary[@"card"][@"type"];
	cardToken.last4 = dictionary[@"card"][@"last4"];
    SIMAddress *address = [[SIMAddress alloc] initWithName:dictionary[@"card"][@"name"] addressLine1:dictionary[@"card"][@"addressLine1"] addressLine2:dictionary[@"card"][@"addressLine2"] city:dictionary[@"card"][@"addressCity"] state:dictionary[@"card"][@"addressState"] zip:dictionary[@"card"][@"addressZip"]];
    cardToken.address = address;
	cardToken.expMonth = dictionary[@"card"][@"expMonth"];
	cardToken.expYear = dictionary[@"card"][@"expYear"];
	NSString *date = [dictionary[@"card"][@"dateCreated"] description];
	cardToken.dateCreated = [[NSDate alloc] initWithTimeIntervalSince1970:[date longLongValue] / 1000];
    
    SIM3DSecureData *threeDS = [SIM3DSecureData threeDSecureDataFromDictionary:dictionary[@"card"][@"secure3DData"]];
    cardToken.threeDSecureData = threeDS;
	
    return cardToken;
}

@end
