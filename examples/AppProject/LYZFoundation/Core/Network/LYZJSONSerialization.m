//
//  LYZJSONSerialization.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/14.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZJSONSerialization.h"

@implementation LYZJSONSerialization

+ (id)dictionaryWithData:(NSData *)data
                 options:(NSJSONReadingOptions)options
                   error:(NSError **)error
{
    if (! [NSJSONSerialization isValidJSONObject:data]) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:options error:error];
}

+ (id)dictionaryWithString:(NSString *)string
                   options:(NSJSONReadingOptions)options
                     error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithData:data options:options error:error];
}

+ (id)dictionaryWithFile:(NSString *)path
                 options:(NSJSONReadingOptions)options
                   error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self dictionaryWithData:data options:options error:error];
}

+ (id)dictionaryWithUrl:(NSURL *)url
                options:(NSJSONReadingOptions)options
                  error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [self dictionaryWithData:data options:options error:error];
}

+ (NSData *)JSONDataWithObject:(id)obj
                       options:(NSJSONWritingOptions)options
                         error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:obj options:options error:error];
}

@end
