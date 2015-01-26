//
//  SIMPKTokenProcessor.m
//  SimplifyMerchantSDK
//
//  Created by Stewart Boling on 1/22/15.
//  Copyright (c) 2015 MasterCard Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIMTokenProcessor.h"

@interface SIMTokenProcessor()

@end

@implementation SIMTokenProcessor

-(void) convertToSimplifyToken:(PKPayment *)payment withKey:(NSString *)publicKey completiion:(void (^)(SIMCreditCardToken *))response
{
    NSURL *url = [NSURL URLWithString:@"<!#SimplifySandBoxAPI>"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:publicKey forKey:@"key"];
}

@end