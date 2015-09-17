//
//  NSString+LYZEncodeAndDecode.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/17.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "NSString+LYZEncodeAndDecode.h"
#import "NSData+LYZEncodeAndDecode.h"

static NSString * const LYZURLEncodingCharactersToBeEscaped = @"!*\'();:@&=+$,/?%#[]";

@implementation NSString (LYZEncodeAndDecode)

- (NSData *)base64EncodedData
{
    return [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

#pragma mark -

- (NSString *)stringByURLEncode
{
    return [self stringByURLEncode:NSUTF8StringEncoding];
}

- (NSString *)stringByURLEncode:(NSStringEncoding)encoding
{
    CFStringRef buffer = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (__bridge CFStringRef)self,
                                                                 NULL,
                                                                 (__bridge CFStringRef)LYZURLEncodingCharactersToBeEscaped,
                                                                 (CFStringEncoding)encoding);
    
    return [NSString stringWithString:(__bridge_transfer NSString *)buffer];
}

- (NSString *)stringByURLDecode
{
    return [self stringByURLDecode:NSUTF8StringEncoding];
}

- (NSString *)stringByURLDecode:(NSStringEncoding)encoding
{
    CFStringEncoding encode = CFStringConvertNSStringEncodingToEncoding(encoding);
    NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                        withString:@" "];
    decoded = (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (__bridge CFStringRef)decoded,
                                                            CFSTR(""),
                                                            encode);
    return decoded;
}

- (NSString *)URLQueryStringAppendDictionary:(NSDictionary *)dict
{
    NSMutableArray* pairs = [NSMutableArray array];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *value = [(NSString *)obj stringByURLEncode];
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }];
    
    NSString *params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

- (NSDictionary *)URLQueryDictionary
{
    return [self URLQueryDictionary:NSUTF8StringEncoding];
}

- (NSDictionary *)URLQueryDictionary:(NSStringEncoding)encoding
{
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    
    while (! [scanner isAtEnd]) {
        NSString *pairString;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString *key = [kvPair[0] stringByReplacingPercentEscapesUsingEncoding:encoding];
            
            NSMutableArray *values = pairs[key];
            if (! values) {
                values = [NSMutableArray array];
                pairs[key] = values;
            }
            
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            }
            else if (kvPair.count == 2) {
                NSString *value = [kvPair[1] stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [pairs copy];
}

#pragma mark -

- (NSString *)stringByAddingHTMLEscapes
{
    if (self.length == 0) {
        return self;
    }
    
    static NSDictionary *escapingDictionary = nil;
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        escapingDictionary = @{ @" " : @"&nbsp;",
                                @">" : @"&gt;",
                                @"<" : @"&lt;",
                                @"&" : @"&amp;",
                                @"'" : @"&apos;",
                                @"\"" : @"&quot;",
                                @"«" : @"&laquo;",
                                @"»" : @"&raquo;"
                                };
        regex = [NSRegularExpression regularExpressionWithPattern:@"(&|>|<|'|\"|«|»)" options:0 error:NULL];
    });
    
    NSMutableString *mutableString = [self mutableCopy];
    NSArray *matches = [regex matchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length])];
    for (NSTextCheckingResult *result in matches.reverseObjectEnumerator) {
        NSString *foundString = [mutableString substringWithRange:result.range];
        NSString *replacementString = escapingDictionary[foundString];
        if (replacementString) {
            [mutableString replaceCharactersInRange:result.range withString:replacementString];
        }
    }
    
    return [mutableString copy];
}

- (NSString *)stringByReplacingHTMLEscapes
{
    if (self.length == 0) {
        return self;
    }
    
    static NSDictionary *escapingDictionary = nil;
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        escapingDictionary = @{@"&nbsp;" : @" ",
                               @"&gt;" : @">",
                               @"&lt;" : @"<",
                               @"&amp;": @"&",
                               @"&apos;":@"'",
                               @"&quot;": @"\"",
                               @"&laquo;":@"«",
                               @"&raquo;":@"»"
                               };
        regex = [NSRegularExpression regularExpressionWithPattern:@"((&nbsp;)|(&gt;)|(&lt;)|(&amp;)|(&apos;)|(&quot;)|(&laquo;)|(&raquo;))" options:0 error:NULL];
    });
    
    NSMutableString *mutableString = [self mutableCopy];
    NSArray *matches = [regex matchesInString:mutableString options:0 range:NSMakeRange(0, [mutableString length])];
    for (NSTextCheckingResult *result in matches.reverseObjectEnumerator) {
        NSString *foundString = [mutableString substringWithRange:result.range];
        NSString *replacementString = escapingDictionary[foundString];
        if (replacementString) {
            [mutableString replaceCharactersInRange:result.range withString:replacementString];
        }
    }
    
    return [mutableString copy];
}

@end
