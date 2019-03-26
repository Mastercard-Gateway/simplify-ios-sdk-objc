/**< Holds data for 3D Secure 1.0 response */
@interface SIM3DSecureData : NSObject

@property (nonatomic, readonly) NSString *id; /**<  */
@property (nonatomic, readonly) BOOL isEnrolled; /**<  */
@property (nonatomic, readonly) NSString *acsUrl; /**<  */
@property (nonatomic, readonly) NSString *paReq; /**<  */
@property (nonatomic, readonly) NSString *md; /**<  */
@property (nonatomic, readonly) NSString *termUrl; /**<  */


/**
 Creates an instance of SIM3DSecureData
 @param amount is the amount of the transaction
 @param currency is the currency of the transaction
 @param descripiton is the description of the transaction
 @return an instnace of SIM3DSecureData with all of the input information
 */
-(instancetype)initWiththreeDSID:(NSString *)threeDSID isEnrolled:(BOOL)enrollment acsUrl:(NSString *)acsUrl paReq:(NSString *)paReq md:(NSString *)md termUrl:(NSString *)termUrl;

+(SIM3DSecureData *)threeDSecureDataFromDictionary:(NSDictionary *)dictionary;

@end
