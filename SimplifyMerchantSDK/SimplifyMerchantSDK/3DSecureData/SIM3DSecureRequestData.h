/**< Holds data for 3D Secure 1.0 authentication */
@interface SIM3DSecureRequestData : NSObject

@property (nonatomic, readonly) NSNumber *amount; /**< Amount of transaction */
@property (nonatomic, readonly) NSString *currency; /**< Currency of the transaction */
@property (nonatomic, readonly) NSString *description; /**< Description of transaction */


/**
 Creates an instance of SIM3DSecureData
 @param amount is the amount of the transaction
 @param currency is the currency of the transaction
 @param descripiton is the description of the transaction
 @return an instnace of SIM3DSecureData with all of the input information
 */
-(instancetype)initWithAmount:(NSNumber *)amount currency:(NSString *)currency description:(NSString *)description;

@end
