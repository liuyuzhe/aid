//
//  AidNetWork.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/30.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AidDownloadProgress)(int64_t bytesRead, int64_t totalBytesRead);
typedef void (^AidUploadProgress)(int64_t bytesWritten, int64_t totalBytesWritten);

//typedef NS_ENUM(NSUInteger, AidRequestType) {
//    AidRequestTypePlainText  = 1, // 普通text/html
//    AidRequestTypeJSON = 2 // 默认
//};
//
//typedef NS_ENUM(NSUInteger, AidResponseType) {
//    AidResponseTypeJSON = 1, // 默认
//    AidResponseTypeXML  = 2, // XML
//    AidResponseTypeData = 3
//};

typedef NSURLSessionTask AidURLSessionTask;
typedef void (^AidResponseSuccess)(id response);
typedef void (^AidResponseFailure)(NSError *error);


@interface AidNetWork : NSObject

+ (AidURLSessionTask *)getWithUrl:(NSString *)url
                          success:(AidResponseSuccess)success
                             failure:(AidResponseFailure)failure;
+ (AidURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(AidResponseSuccess)success
                             failure:(AidResponseFailure)failure;
+ (AidURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(AidDownloadProgress)progress
                          success:(AidResponseSuccess)success
                             failure:(AidResponseFailure)failure;

+ (AidURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(AidResponseSuccess)success
                           failure:(AidResponseFailure)failure;
+ (AidURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                          progress:(AidDownloadProgress)progress
                           success:(AidResponseSuccess)success
                           failure:(AidResponseFailure)failure;

+ (AidURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(AidUploadProgress)progress
                               success:(AidResponseSuccess)success
                               failure:(AidResponseFailure)failure;

+ (AidURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(AidUploadProgress)progress
                                 success:(AidResponseSuccess)success
                                    failure:(AidResponseFailure)failure;

+ (AidURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(AidDownloadProgress)progress
                               success:(AidResponseSuccess)success
                               failure:(AidResponseFailure)failure;
@end
