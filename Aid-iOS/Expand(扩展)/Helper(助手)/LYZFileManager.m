//
//  LYZFileManager.m
//  AppProject
//
//  Created by 刘育哲 on 15/3/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <sys/stat.h>

#import "LYZFileManager.h"
#import "LYZMathMacro.h"

@implementation LYZFileManager

+ (BOOL)createFileAtPath:(NSString *)path
{
    if ([self isExistAtPath:path]) {
        return YES;
    }
    
    return [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path
{
    if ([self isExistAtPath:path]) {
        return YES;
    }
    
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)removeItemAtPath:(NSString *)path
{
    if (! [self isExistAtPath:path]) {
        return YES;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (BOOL)removeItemsAtPaths:(NSArray *)paths
{
    BOOL success = YES;
    for (NSString *path in paths) {
        success &= [self removeItemAtPath:path];
    }
    
    return success;
}

- (NSData *)readFileContent:(NSString *)path
{
//    The methods of the shared NSFileManager object can be called from multiple threads safely. However, if you use a delegate to receive notifications about the status of move, copy, remove, and link operations, you should create a unique instance of the file manager object, assign your delegate to that object, and use that file manager to initiate your operations.
    return [[[NSFileManager alloc] init] contentsAtPath:path];
}

- (BOOL)writeFileAtPath:(NSString *)path useData:(NSData *)content
{
//    The methods of the shared NSFileManager object can be called from multiple threads safely. However, if you use a delegate to receive notifications about the status of move, copy, remove, and link operations, you should create a unique instance of the file manager object, assign your delegate to that object, and use that file manager to initiate your operations.
    return [[[NSFileManager alloc] init] createFileAtPath:path contents:content attributes:nil];
}

+ (NSData *)readFileAtPathAsData:(NSString *)path
{
    NSData *contents;
    
    if ([self isExistAtPath: path]) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        if (fileHandle) {
            contents = [[NSData alloc] initWithData:[fileHandle availableData]];
            [fileHandle closeFile];
        }
    }
    
    return contents;
}

+ (NSString *)readFileAtPathAsString:(NSString *)path
{
    return [[NSString alloc] initWithData:[self readFileAtPathAsData:path] encoding:NSUTF8StringEncoding];
}

+ (void)writeFileAtPath:(NSString *)path useData:(NSData *)content
{
    if (! content) {
        return;
    }
    if (! [self isExistAtPath:path]) {
        BOOL isCreat = [self createFileAtPath:path];
        if (! isCreat) {
            return;
        }
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    if (fileHandle) {
        [fileHandle writeData:content];
        [fileHandle closeFile];
    }
}

+ (void)writeFileAtPath:(NSString *)path useString:(NSString *)content
{
    if (! content) {
        return;
    }
    
    [self writeFileAtPath:path useData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)updateFileAtPath:(NSString *)path useData:(NSData *)content
{
    if (! content) {
        return;
    }
    if (! [self isExistAtPath:path]) {
        BOOL isCreat = [self createFileAtPath:path];
        if (! isCreat) {
            return;
        }
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    if (fileHandle) {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:content];
        [fileHandle closeFile];
    }
}

+ (void)updateFileAtPath:(NSString *)path useString:(NSString *)content
{
    if (! content) {
        return;
    }
    
    [self updateFileAtPath:path useData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

@end



@implementation LYZFileManager (SystemPaths)

+ (NSString *)pathForDocumentsDirectory
{
    static NSString *path = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = paths.firstObject;
    });
    
    return path;
}

+ (NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path
{
    return [[self pathForDocumentsDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForLibraryDirectory
{
    static NSString *path = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = paths.firstObject;
    });
    
    return path;
}

+ (NSString *)pathForLibraryDirectoryWithPath:(NSString *)path
{
    return [[self pathForLibraryDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForApplicationSupportDirectory
{
    static NSString *path = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        path = paths.firstObject;
    });
    
    return path;
}

+ (NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path
{
    return [[self pathForApplicationSupportDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForCachesDirectory
{
    static NSString *path = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        path = paths.firstObject;
    });
    
    return path;
}

+ (NSString *)pathForCachesDirectoryWithPath:(NSString *)path
{
    return [[self pathForCachesDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForTemporaryDirectory
{
    static NSString *path = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = NSTemporaryDirectory();
    });
    
    return path;
}

+ (NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path
{
    return [[self pathForTemporaryDirectory] stringByAppendingPathComponent:path];
}

+ (BOOL)clearCachesDirectory
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:[self pathForCachesDirectory]]];
}

+ (BOOL)clearTemporaryDirectory
{
    return [self removeItemsAtPaths:[self listFilesInDirectoryAtPath:[self pathForTemporaryDirectory]]];
}

@end



@implementation LYZFileManager (ItemInformation)

+ (BOOL)isExistAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
}

+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key
{
    return [[self attributesOfItemAtPath:path] objectForKey:key];
}

+ (CGFloat)MByteOfFileAtPath:(NSString *)path
{
    return [self attributesOfItemAtPath:path].fileSize / LYZBytesInMB;
}

+ (CGFloat)MByteOfDirectoryAtPath:(NSString *)path
{
    unsigned long long pathSize = 0;
    
    NSArray *subpaths = [self listItemsInDirectoryAtPath:path deep:YES];
    for (NSString *path in subpaths) {
        pathSize += [self attributesOfItemAtPath:path].fileSize;
    }
    
    return pathSize / LYZBytesInMB;
}


+ (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode
{
    uint64_t totalSize = 0;
    NSMutableArray *searchPaths = [NSMutableArray arrayWithObject:filePath];
    while ([searchPaths count] > 0) {
        @autoreleasepool {
            NSString *fullPath = [searchPaths objectAtIndex:0];
            [searchPaths removeObjectAtIndex:0];
            
            struct stat fileStat;
            if (lstat([fullPath fileSystemRepresentation], &fileStat) == 0) {
                if (fileStat.st_mode & S_IFDIR) {
                    NSArray *childSubPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:nil];
                    for (NSString *childItem in childSubPaths) {
                        NSString *childPath = [fullPath stringByAppendingPathComponent:childItem];
                        [searchPaths insertObject:childPath atIndex:0];
                    }
                }
                else {
                    if (diskMode) {
                        totalSize += fileStat.st_blocks * 512;
                    }
                    else {
                        totalSize += fileStat.st_size;
                    }
                }
            }
        }
    }
    
    return totalSize;
}

+ (BOOL)isFileItemAtPath:(NSString *)path
{
    return ([self attributeOfItemAtPath:path forKey:NSFileType] == NSFileTypeRegular);
}

+ (BOOL)isExecutableItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}

+ (BOOL)isReadableItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}

+ (BOOL)isWritableItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path
{
    NSArray *subpaths = [self listItemsInDirectoryAtPath:path deep:NO];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:
                              ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                  NSString *subpath = (NSString *)evaluatedObject;
                                  return [self isFileItemAtPath:subpath];
                              }];
    
    return [subpaths filteredArrayUsingPredicate:predicate];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension
{
    NSArray *subpaths = [self listFilesInDirectoryAtPath:path];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:
                              ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                  NSString *subpath = (NSString *)evaluatedObject;
                                  NSString *subpathExtension = [[subpath pathExtension] lowercaseString];
                                  NSString *filterExtension = [[extension lowercaseString] stringByReplacingOccurrencesOfString:@"." withString:@""];
                                  return [subpathExtension isEqualToString:filterExtension];
                              }];
    
    return [subpaths filteredArrayUsingPredicate:predicate];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix
{
    NSArray *subpaths = [self listFilesInDirectoryAtPath:path];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:
                              ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                  NSString *subpath = (NSString *)evaluatedObject;
                                  return ([subpath hasPrefix:prefix]);
                              }];
    return [subpaths filteredArrayUsingPredicate:predicate];
}

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix
{
    NSArray *subpaths = [self listFilesInDirectoryAtPath:path];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:
                              ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                  NSString *subpath = (NSString *)evaluatedObject;
                                  NSString *subpathName = [subpath stringByDeletingPathExtension];
                                  return ([subpath hasSuffix:suffix] || [subpathName hasSuffix:suffix]);
                              }];
    
    return [subpaths filteredArrayUsingPredicate:predicate];
}

+ (NSArray *)listItemsInDirectoryAtPath:(NSString *)path deep:(BOOL)deep
{
    NSArray *subpaths = (deep) ? [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil] : [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *allSubpaths = [[NSMutableArray alloc] init];
    
    for(NSString *subPath in subpaths)
    {
        NSString *absoluteSubpath = [path stringByAppendingPathComponent:subPath];
        [allSubpaths addObject:absoluteSubpath];
    }
    
    return [NSArray arrayWithArray:allSubpaths];
}

@end
