//
//  LYZXMLSerialization.m
//  AppProject
//
//  Created by 刘育哲 on 15/7/14.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import "LYZXMLSerialization.h"
#import "LYZSingletonMacro.h"

@interface LYZXMLSerialization () <NSXMLParserDelegate>

@property (nonatomic,strong)    NSMutableArray *stacks;
@property (nonatomic,strong)    NSError *error;

- (NSDictionary *)parse:(NSXMLParser *)parser
                options:(LYZXMLReadingOptions)options
                  error:(NSError **)error;
@end


@implementation LYZXMLSerialization

IS_SINGLETON(LYZXMLSerialization)

#pragma mark - LYZXMLSerialization public

+ (NSDictionary *)dictionaryWithParser:(NSXMLParser *)parser
                               options:(LYZXMLReadingOptions)options
                                 error:(NSError **)error
{
    return [[[self class] sharedInstance] parse:parser options:options error:error];
}

+ (NSDictionary *)dictionaryWithData:(NSData *)data
                             options:(LYZXMLReadingOptions)options
                               error:(NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    return [self dictionaryWithParser:parser options:options error:error];
}

+ (NSDictionary *)dictionaryWithString:(NSString *)string
                               options:(LYZXMLReadingOptions)options
                                 error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithData:data options:options error:error];
}

+ (NSDictionary *)dictionaryWithFile:(NSString *)path
                             options:(LYZXMLReadingOptions)options
                               error:(NSError **)error
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self dictionaryWithData:data options:options error:error];
}

+ (NSDictionary *)dictionaryWithURL:(NSURL *)url
                            options:(LYZXMLReadingOptions)options
                              error:(NSError **)error;
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [self dictionaryWithData:data options:options error:error];
}

#pragma mark - LYZXMLSerialization private

- (NSDictionary *)parse:(NSXMLParser *)parser
                options:(LYZXMLReadingOptions)options
                  error:(NSError **)error
{
    parser.delegate = self;
    
    parser.shouldProcessNamespaces = options & LYZXMLReadingShouldProcessNamespaces;
    parser.shouldReportNamespacePrefixes = options & LYZXMLReadingShouldReportNamespacePrefixes;
    parser.shouldResolveExternalEntities = options & LYZXMLReadingShouldResolveExternalEntities;
    
    self.stacks = [NSMutableArray array];
    [self.stacks addObject:[NSMutableDictionary dictionary]];
    
    NSDictionary *result = nil;
    BOOL success = [parser parse];
    if (success)
    {
        result = [self.stacks firstObject];
    }
    else
    {
        if (error)
        {
            *error = self.error;
        }
    }
    
    return result;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary *parentDict = [self.stacks lastObject];
    NSMutableDictionary *childDict = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
    
    id existedValue = [parentDict objectForKey:elementName];
    if (existedValue)
    {
        if ([existedValue isKindOfClass:[NSMutableArray class]])
        {
            [(NSMutableArray *)existedValue addObject:parentDict];
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:existedValue];
            [array addObject:childDict];
            [parentDict setObject:array forKey:elementName];
        }
    }
    else
    {
        [parentDict setObject:childDict forKey:elementName];
    }
    [self.stacks addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [self.stacks removeLastObject];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.error = parseError;
}

@end
