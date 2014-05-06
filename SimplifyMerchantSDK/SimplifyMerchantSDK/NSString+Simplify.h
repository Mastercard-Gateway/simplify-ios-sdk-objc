@interface NSString (Simplify)

+(NSString *)urlEncodedString:(NSString *)urlString;
+(NSString *)urlEncodedString:(NSString *)urlString usingEncoding:(NSStringEncoding)encoding;

@end
