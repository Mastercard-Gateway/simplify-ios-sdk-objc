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
 @param
 @param
 @param
 @return
 */
-(instancetype)initWiththreeDSID:(NSString *)threeDSID isEnrolled:(BOOL)enrollment acsUrl:(NSString *)acsUrl paReq:(NSString *)paReq md:(NSString *)md termUrl:(NSString *)termUrl;

+(SIM3DSecureData *)threeDSecureDataFromDictionary:(NSDictionary *)dictionary;

@end
