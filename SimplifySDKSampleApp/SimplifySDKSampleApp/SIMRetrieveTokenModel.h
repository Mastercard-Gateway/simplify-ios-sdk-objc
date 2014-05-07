#import <Simplify/SIMCardType.h>
@protocol SIMRetrieveTokenModelDelegate

- (void)processCardToken:(NSString *)cardToken WithError:(NSError *)error;

@end

@interface SIMRetrieveTokenModel : NSObject
@property (nonatomic, weak) id<SIMRetrieveTokenModelDelegate> delegate;
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
@property (nonatomic, strong, readonly) SIMCardType *cardType;

- (BOOL) isRetrievalPossible;
- (BOOL) isCardNumberValid;
- (BOOL) isExpirationDateValid;
- (void) updateChargeAmountWithString:(NSString *)newString;
- (void) updateCardNumberWithString:(NSString *)newString;
- (void) updateExpirationDateWithString:(NSString *)newString;
- (void) updateCVCNumberWithString:(NSString *)newString;
- (void) retrieveToken;
@end
