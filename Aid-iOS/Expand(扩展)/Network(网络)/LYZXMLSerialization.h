//
//  LYZXMLSerialization.h
//  AppProject
//
//  Created by 刘育哲 on 15/7/14.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, LYZXMLReadingOptions)
{
    LYZXMLReadingNone = 0,
    LYZXMLReadingShouldProcessNamespaces = 1 << 0,
    LYZXMLReadingShouldReportNamespacePrefixes = 1 << 1,
    LYZXMLReadingShouldResolveExternalEntities = 1 << 2,
};


@interface LYZXMLSerialization : NSObject

+ (NSDictionary *)dictionaryWithParser:(NSXMLParser *)parser
                               options:(LYZXMLReadingOptions)options
                                 error:(NSError **)error;
+ (NSDictionary *)dictionaryWithData:(NSData *)data
                             options:(LYZXMLReadingOptions)options
                               error:(NSError **)error;
+ (NSDictionary *)dictionaryWithString:(NSString *)string
                               options:(LYZXMLReadingOptions)options
                                 error:(NSError **)error;
+ (NSDictionary *)dictionaryWithFile:(NSString *)path
                             options:(LYZXMLReadingOptions)options
                               error:(NSError **)error;
+ (NSDictionary *)dictionaryWithURL:(NSURL *)url
                             options:(LYZXMLReadingOptions)options
                               error:(NSError **)error;

@end
