//
//  LYZJSONSerialization.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/14.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYZJSONSerialization : NSObject

+ (id)dictionaryWithData:(NSData *)data
                 options:(NSJSONReadingOptions)options
                   error:(NSError **)error;
+ (id)dictionaryWithString:(NSString *)string
                   options:(NSJSONReadingOptions)options
                     error:(NSError **)error;
+ (id)dictionaryWithFile:(NSString *)path
                 options:(NSJSONReadingOptions)options
                   error:(NSError **)error;
+ (id)dictionaryWithUrl:(NSURL *)url
                options:(NSJSONReadingOptions)options
                  error:(NSError **)error;

+ (NSData *)JSONDataWithObject:(id)obj
                       options:(NSJSONWritingOptions)options
                         error:(NSError **)error;

@end
