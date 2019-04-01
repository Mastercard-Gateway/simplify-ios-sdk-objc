#import "SIM3DSecureData.h"

@interface SIM3DSecureData()

@property (nonatomic, readwrite) NSString *threeDSID;
@property (nonatomic, readwrite) BOOL isEnrolled;
@property (nonatomic, readwrite) NSString *acsUrl;
@property (nonatomic, readwrite) NSString *paReq;
@property (nonatomic, readwrite) NSString *md;
@property (nonatomic, readwrite) NSString *termUrl;

@end

@implementation SIM3DSecureData

-(instancetype)initWiththreeDSID:(NSString *)threeDSID isEnrolled:(BOOL)enrollment acsUrl:(NSString *)acsUrl paReq:(NSString *)paReq md:(NSString *)md termUrl:(NSString *)termUrl {
    self = [super init];
    if (self) {
        self.threeDSID = threeDSID ? threeDSID : @"";
        self.isEnrolled = enrollment ? enrollment : NO;
        self.acsUrl = acsUrl ? acsUrl : @"";
        self.paReq = paReq ? paReq : @"";
        self.md = md ? md : @"";
        self.termUrl = termUrl ? termUrl : @"";
    }
    return self;
}

+(SIM3DSecureData *)threeDSecureDataFromDictionary:(NSDictionary *)dictionary {
    
    SIM3DSecureData *threeDSData = [[SIM3DSecureData alloc] init];
    threeDSData.threeDSID = dictionary[@"id"];
    
    threeDSData.isEnrolled = [dictionary[@"isEnrolled"] boolValue];
    threeDSData.acsUrl = dictionary[@"acsUrl"];
    threeDSData.paReq = dictionary[@"paReq"];
    threeDSData.md = dictionary[@"md"];
    threeDSData.termUrl = dictionary[@"termUrl"];

    return threeDSData;
}

@end
