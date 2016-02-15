//
//  LYZFileManager.h
//  AppProject
//
//  Created by 刘育哲 on 15/3/20.
//  Copyright (c) 2015年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYZFileManager : NSObject

+ (BOOL)createFileAtPath:(NSString *)path;
+ (BOOL)createDirectoryAtPath:(NSString *)path;

+ (BOOL)removeItemAtPath:(NSString *)path;
+ (BOOL)removeItemsAtPaths:(NSArray *)paths;

+ (NSData *)readFileAtPathAsData:(NSString *)path;
+ (NSString *)readFileAtPathAsString:(NSString *)path;

+ (void)writeFileAtPath:(NSString *)path useData:(NSData *)content;
+ (void)writeFileAtPath:(NSString *)path useString:(NSString *)content;

+ (void)updateFileAtPath:(NSString *)path useData:(NSData *)content;
+ (void)updateFileAtPath:(NSString *)path useString:(NSString *)content;

@end



@interface LYZFileManager (SystemPaths)

/** iTunes会同步此文件夹，适合存储重要数据 @return ~/Documents */
+ (NSString *)pathForDocumentsDirectory;
+ (NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path;

/** @return ~/Library */
+ (NSString *)pathForLibraryDirectory;
+ (NSString *)pathForLibraryDirectoryWithPath:(NSString *)path;

/** iTunes会同步此文件夹，通常保存应用的设置信息。@return ~/Library/Application Support */
+ (NSString *)pathForApplicationSupportDirectory;
+ (NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path;

/** iTunes不会同步此文件夹，适合存储体积大，不需要备份的非重要数据。 @return ~/Library/Caches */
+ (NSString *)pathForCachesDirectory;
+ (NSString *)pathForCachesDirectoryWithPath:(NSString *)path;

/** iTunes不会同步此文件夹，系统可能在应用没运行时就删除该目录下的文件，此目录仅适合保存应用中的一些临时文件，用完就删除。 @return ~/tmp/ */
+ (NSString *)pathForTemporaryDirectory;
+ (NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path;

+ (BOOL)clearCachesDirectory;
+ (BOOL)clearTemporaryDirectory;

@end



@interface LYZFileManager (ItemInformation)

+ (BOOL)isExistAtPath:(NSString *)path;

+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path;
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key;
+ (CGFloat)MByteOfFileAtPath:(NSString *)path;
+ (CGFloat)MByteOfDirectoryAtPath:(NSString *)path;
/** @param diskMode YES:占用磁盘大小;NO:文件实际大小 */
+ (uint64_t)sizeAtPath:(NSString *)filePath diskMode:(BOOL)diskMode;

+ (BOOL)isFileItemAtPath:(NSString *)path;

+ (BOOL)isExecutableItemAtPath:(NSString *)path;
+ (BOOL)isReadableItemAtPath:(NSString *)path;
+ (BOOL)isWritableItemAtPath:(NSString *)path;

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+ (NSArray *)listItemsInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

@end

