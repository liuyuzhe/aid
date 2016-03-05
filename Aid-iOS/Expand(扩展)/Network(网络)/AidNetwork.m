//
//  AidNetwork.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/30.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "AidNetwork.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation AidNetwork

#pragma mark - public method

+ (AidURLSessionTask *)getWithUrl:(NSString *)url
                          success:(AidResponseSuccess)success
                             failure:(AidResponseFailure)failure
{
    return [self getWithUrl:url
                     params:nil
                    success:success
                       failure:failure];
}

+ (AidURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(AidResponseSuccess)success
                             failure:(AidResponseFailure)failure
{
    return [self getWithUrl:url
                     params:params
                   progress:nil
                    success:success
                       failure:failure];
}

+ (AidURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(AidDownloadProgress)progress
                          success:(AidResponseSuccess)success
                             failure:(AidResponseFailure)failure
{
    AidURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionManager];
    session = [manager GET:url
                parameters:params
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progress) {
                          progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                      }
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (success) {
                          success(responseObject);
                      }
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (error) {
                          failure(error);
                      }
                  }];
    
    return session;
}

+ (AidURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(AidResponseSuccess)success
                              failure:(AidResponseFailure)failure
{
    return [self postWithUrl:url
                      params:params
                    progress:nil
                     success:success
                        failure:failure];
}

+ (AidURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                          progress:(AidDownloadProgress)progress
                           success:(AidResponseSuccess)success
                              failure:(AidResponseFailure)failure
{
    AidURLSessionTask *session = nil;

    AFHTTPSessionManager *manager = [self sessionManager];
    session = [manager POST:url
                 parameters:params
                   progress:^(NSProgress * _Nonnull uploadProgress) {
                       if (progress) {
                           progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                       }
                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (success) {
                           success(responseObject);
                       }
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       if (failure) {
                           failure(error);
                       }
                   }];
    
    return session;
}

+ (AidURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(AidUploadProgress)progress
                               success:(AidResponseSuccess)success
                                  failure:(AidResponseFailure)failure
{
    AidURLSessionTask *session = nil;

    AFHTTPSessionManager *manager = [self sessionManager];
    session = [manager POST:url
                 parameters:parameters
  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      if (progress) {
          progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
      }
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      if (success) {
          success(responseObject);
      }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (failure) {
          failure(error);
      }
  }];
    
    return session;
}

+ (AidURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(AidUploadProgress)progress
                                 success:(AidResponseSuccess)success
                                    failure:(AidResponseFailure)failure
{
    AidURLSessionTask *session = nil;

    AFHTTPSessionManager *manager = [self sessionManager];
    NSURLRequest *uploadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    session = [manager uploadTaskWithRequest:uploadRequest fromFile:[NSURL URLWithString:url] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (success) {
            success(responseObject);
        }
        if (error) {
            if (failure) {
                failure(error);
            }
        }
    }];
    
    return session;
}

+ (AidURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(AidDownloadProgress)progress
                               success:(AidResponseSuccess)success
                               failure:(AidResponseFailure)failure
{
    AidURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self sessionManager];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    session = [manager downloadTaskWithRequest:downloadRequest
                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                          if (progress) {
                                              progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                                          }
                                      } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                          return [NSURL URLWithString:saveToPath];
                                      } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                          if (success) {
                                              success(filePath.absoluteString);
                                          }
                                          if (error) {
                                              if (failure) {
                                                  failure(error);
                                              }
                                          }
                                      }];
    return session;
}

#pragma mark - private method

+ (AFHTTPSessionManager *)sessionManager
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES; // 开启转圈圈

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    manager.operationQueue.maxConcurrentOperationCount = 4; // 最大并发数量
    
    return manager;
}

@end
