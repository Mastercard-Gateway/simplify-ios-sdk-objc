#import <Simplify/SIMCardType.h>
#import <Simplify/SIMAddress.h>
@protocol SIMCheckoutModelDelegate

- (void)paymentFailedWithError:(NSError *)error;
- (void)paymentProcessedWithPaymentID:(NSString *)paymentID;

@end

@interface SIMCheckoutModel : NSObject
@property (nonatomic, weak) id<SIMCheckoutModelDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *chargeAmount;
@property (nonatomic, strong, readonly) NSString *cardNumber;
@property (nonatomic, strong, readonly) NSString *expirationDate;
@property (nonatomic, strong, readonly) NSString *expirationMonth;
@property (nonatomic, strong, readonly) NSString *expirationYear;
@property (nonatomic, strong, readonly) NSString *formattedChargeAmount;
@property (nonatomic, strong, readonly) NSString *formattedCardNumber;
@property (nonatomic, strong, readonly) NSString *formattedExpirationDate;
@property (nonatomic, strong, readonly) NSString *cvcCode;
@property (nonatomic, strong, readonly) NSString *cardTypeString;
@property (nonatomic, strong, readonly) SIMAddress *address;
@property (nonatomic, strong, readonly) SIMCardType *cardType;

- (BOOL) isCheckoutPossible;
- (BOOL) isCardNumberValid;
- (BOOL) isExpirationDateValid;
- (BOOL) isCVCCodeValid;
- (void) updateChargeAmountWithString:(NSString *)newString;
- (void) updateCardNumberWithString:(NSString *)newString;
- (void) updateExpirationDateWithString:(NSString *)newString;
- (void) updateCVCNumberWithString:(NSString *)newString;
- (void) retrieveToken;
@end
