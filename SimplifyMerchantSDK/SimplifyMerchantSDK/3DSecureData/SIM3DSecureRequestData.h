/**< Holds data for 3D Secure 1.0 request */
@interface SIM3DSecureRequestData : NSObject

@property (nonatomic, readonly) NSDecimalNumber *amount; /**< Amount of transaction */
@property (nonatomic, readonly) NSString *currency; /**< Currency Code of the transaction */
@property (nonatomic, readonly) NSString *descriptionMessage; /**< Description of transaction */


/**
 Creates an instance of SIM3DSecureRequestData
 @param amount is the amount of the transaction
 @param currency is the currency of the transaction
 @param descripiton is the description of the transaction
 @return an instnace of SIM3DSecureRequestData with all of the input information
 */
-(instancetype)initWithAmount:(NSDecimalNumber *)amount currency:(NSString *)currency description:(NSString *)description;

@end
