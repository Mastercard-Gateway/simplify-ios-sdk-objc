#import "SIM3DSecureData.h"

@interface SIM3DSecureDataTests : XCTestCase
@property (nonatomic, strong) SIM3DSecureData *testSubject;
@end

@implementation SIM3DSecureDataTests

-(void)testThatSIM3DSecureDataCanBeCreated {
    
    NSString *threeDSID = @"3DS ID";
    BOOL isEnrolled = YES;
    NSString *acsUrl = @"ACS URL path";
    NSString *paReq = @"pareq: 1234";
    NSString *md = @"123HBACE1234";
    NSString *termUrl = @"Terms and Conditions";
    
    self.testSubject = [[SIM3DSecureData alloc]initWiththreeDSID:threeDSID isEnrolled:isEnrolled acsUrl:acsUrl paReq:paReq md:md termUrl:termUrl];

    XCTAssertTrue([self.testSubject.threeDSID isEqualToString:threeDSID], @"");
    XCTAssertTrue(self.testSubject.isEnrolled, @"");
    XCTAssertTrue([self.testSubject.acsUrl isEqualToString:acsUrl], @"");
    XCTAssertTrue([self.testSubject.paReq isEqualToString:paReq], @"");
    XCTAssertTrue([self.testSubject.md isEqual:md], @"");
    XCTAssertTrue([self.testSubject.termUrl isEqual:termUrl], @"");
}

-(void)testThatSIM3DSecureDataCanBeCreatedWithNilValuesReturnsNilSafeValues {
    
    self.testSubject = [[SIM3DSecureData alloc] initWiththreeDSID:nil isEnrolled:nil acsUrl:nil paReq:nil md:nil termUrl:nil];

    XCTAssertNotNil(self.testSubject.threeDSID, @"");
    XCTAssertFalse(self.testSubject.isEnrolled, @"");
    XCTAssertNotNil(self.testSubject.acsUrl, @"");
    XCTAssertNotNil(self.testSubject.paReq, @"");
    XCTAssertNotNil(self.testSubject.md, @"");
    XCTAssertNotNil(self.testSubject.termUrl, @"");
}

-(void)testFromDictionary_BuildsObjectFromDictionaryCorrectly {
    NSDictionary *dictionary = @{@"id": @"xK85kK7k",
                                @"isEnrolled": @"1",
                                @"acsUrl": @"https://mtf.gateway.mastercard.com/acs/MastercardACS/9e0b8a35-b267-455b-85e2-bf3fd6117775",
                                @"paReq": @"eAFVUdtugkAQfTfxHwjpaxkuImLGNVjSaJo2pkqTPhLYyibc3IVi/767CNXO054zM2dnzuD6UuTaN+WCVeVKtwxT12iZVCkrTys9Oj4/LvQ1mU7wmHFKwwNNWk4JvlIh4hPVWCp7Zp7vz62FTnAfvNMzwUGOSDXDRhih7OJJFpcNwTg5b3ZvxHVcxzIRBogF5buQuHN37slAuGIs44KSAyvqnH39aEcqGoSew6Rqy4b/ENOZI4wAW56TrGlqsQTous4QQ6uRVAWIpuJUAIKqQrjNtG/VdEJud2EpiV5Cz6mClGVdcIo2Rbr93Lup+5H7YoWgKjCNG0ps0/JNx3Y121xa3tKeIfQ8xoWajQRRqD1II9SWVwZr9VFwBZZK3BMoDebyAuNOI0J6qauSSkXp6N8b4Tb101b5mjTKwbuYyVAO9wmlwqRftmU6vYwCCKoVhuNJR/rbSubfzaeTXziJtKg=",
                                @"md": @"NTMwMzNkNDBhZDYzYzY0MU27bwTOrSOc3a9iljg/vNh52gr4g80rdG8+0URIX0YEooBIwTc5CCOmceKzLhhXaJeeImzpUP7Ij/QRsHdnFn9cjy92XzFEMjD+LsFkjEzAej/VWdm7XxfgaM8wwkvvyA==",
                                @"termUrl": @"https://uat.simplify.com/commerce/secure3d"
                                };
    
    self.testSubject = [SIM3DSecureData threeDSecureDataFromDictionary:dictionary];
    
    XCTAssertTrue([self.testSubject.threeDSID isEqualToString:@"xK85kK7k"], @"");
    XCTAssertTrue(self.testSubject.isEnrolled, @"");
    XCTAssertTrue([self.testSubject.acsUrl isEqualToString:@"https://mtf.gateway.mastercard.com/acs/MastercardACS/9e0b8a35-b267-455b-85e2-bf3fd6117775"], @"");
    XCTAssertTrue([self.testSubject.paReq isEqualToString:@"eAFVUdtugkAQfTfxHwjpaxkuImLGNVjSaJo2pkqTPhLYyibc3IVi/767CNXO054zM2dnzuD6UuTaN+WCVeVKtwxT12iZVCkrTys9Oj4/LvQ1mU7wmHFKwwNNWk4JvlIh4hPVWCp7Zp7vz62FTnAfvNMzwUGOSDXDRhih7OJJFpcNwTg5b3ZvxHVcxzIRBogF5buQuHN37slAuGIs44KSAyvqnH39aEcqGoSew6Rqy4b/ENOZI4wAW56TrGlqsQTous4QQ6uRVAWIpuJUAIKqQrjNtG/VdEJud2EpiV5Cz6mClGVdcIo2Rbr93Lup+5H7YoWgKjCNG0ps0/JNx3Y121xa3tKeIfQ8xoWajQRRqD1II9SWVwZr9VFwBZZK3BMoDebyAuNOI0J6qauSSkXp6N8b4Tb101b5mjTKwbuYyVAO9wmlwqRftmU6vYwCCKoVhuNJR/rbSubfzaeTXziJtKg="], @"");
    XCTAssertTrue([self.testSubject.md isEqual:@"NTMwMzNkNDBhZDYzYzY0MU27bwTOrSOc3a9iljg/vNh52gr4g80rdG8+0URIX0YEooBIwTc5CCOmceKzLhhXaJeeImzpUP7Ij/QRsHdnFn9cjy92XzFEMjD+LsFkjEzAej/VWdm7XxfgaM8wwkvvyA=="], @"");
    XCTAssertTrue([self.testSubject.termUrl isEqual:@"https://uat.simplify.com/commerce/secure3d"], @"");
}


@end
