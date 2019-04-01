/**< Holds data for 3D Secure 1.0 response */
@interface SIM3DSecureData : NSObject

@property (nonatomic, readonly) NSString *threeDSID; /**< ID of the 3DS Data */
@property (nonatomic, readonly) BOOL isEnrolled; /**< Is the card enrolled for 3DS Authentication  */
@property (nonatomic, readonly) NSString *acsUrl; /**< Url of the challenge for authentication request */
@property (nonatomic, readonly) NSString *paReq; /**< Paramerter Requirement  */
@property (nonatomic, readonly) NSString *md; /**< MD hash */
@property (nonatomic, readonly) NSString *termUrl; /**< Terms and conditions URL */

/**
 Creates an instance of SIM3DSecureData
 @param threeDSID is the id of the 3DS transaction
 @param enrollment a boolean value of if the card is enrolled in 3DS
 @param acsUrl is the url of the challenge for authentication request
 @param paReq
 @param md is a hash value
 @param termUrl is the URL to the terms and conditions
 @return is an instance of SIM3DSecureData initialised with all the values
 */
-(instancetype)initWiththreeDSID:(NSString *)threeDSID isEnrolled:(BOOL)enrollment acsUrl:(NSString *)acsUrl paReq:(NSString *)paReq md:(NSString *)md termUrl:(NSString *)termUrl;

+(SIM3DSecureData *)threeDSecureDataFromDictionary:(NSDictionary *)dictionary;

@end
