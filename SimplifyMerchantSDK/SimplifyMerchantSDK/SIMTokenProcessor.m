#import "SIMTokenProcessor.h"
#import <AddressBook/ABPerson.h>

@interface SIMTokenProcessor()

@end

@implementation SIMTokenProcessor


+(NSData *) formatDataForRequestWithKey:(NSString *)publicKey withPayment:(PKPayment *)payment error:(NSError *)error
{
    ABRecordRef ref = [payment billingAddress];
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonLastNameProperty));
    
    NSString *cardHolderName = nil;
    if (firstName && lastName) {
        cardHolderName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    }
    
    NSObject *paymentTokenData = [NSJSONSerialization JSONObjectWithData:[[payment token] paymentData] options:kNilOptions error:&error];
    
    NSMutableDictionary *cardDict = [NSMutableDictionary new];
    cardDict[@"cardEntryMode"] = @"APPLE_PAY_IN_APP";
    cardDict[@"applePayData"] = @{ @"paymentToken" : paymentTokenData};
    if (cardHolderName) {
        cardDict[@"name"] = cardHolderName;
    }
    
    NSDictionary *dict = @{
                           @"key" : publicKey,
                           @"card" : cardDict
                           };
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    return jsonData;
}

@end