@interface SIMCheckoutModel : NSObject
@property (nonatomic, strong, readonly) NSString *cardNumber;
@property (nonatomic, strong, readonly) NSString *expirationDate;
@property (nonatomic, strong, readonly) NSString *expirationMonth;
@property (nonatomic, strong, readonly) NSString *expirationYear;
@property (nonatomic, strong, readonly) NSString *formattedCardNumber;
@property (nonatomic, strong, readonly) NSString *formattedExpirationDate;
@property (nonatomic, strong, readonly) NSString *cvcCode;

- (BOOL)checkoutPossible;
- (void) updateCardNumberWithString:(NSString *)newString;
- (void) updateExpirationDateWithString:(NSString *)newString;
- (void) updateCVCNumberWithString:(NSString *)newString;
- (void) chargeCard;
@end
