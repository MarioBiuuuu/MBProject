//
//  ApiUtil.m
//  LKProject
//
//  Created by yunjing on 2017/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "ApiUtil.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

#define kTimeOutInterval 30


typedef NS_ENUM(NSInteger, ApiRequestMethod) {
    ApiRequestMethodGET = 0,
    ApiRequestMethodPOST,
};
typedef void (^ApiSuccessBack) (NSDictionary *jsonObject);
typedef void (^ApifailedErrorBack) (NSError *error);
@interface ApiRequestFunc : NSObject

/**
 *   基本网络请求,(get,post)
 *
 *  @param arguments            参数
 *  @param url                  请求地址,短地址除去BaseUrl
 *  @param method               请求方式, ApiRequestMethod 枚举类型
 *  @param successBack          成功Block回调
 *  @param errorBack            失败Block回调
 */
+ (void)sendApiRequestWithArguments:(NSDictionary *)arguments requestURL:(NSString *)url requestMethod:(ApiRequestMethod)method
        MD5Encryption:(BOOL)MD5Encryption successBack:(ApiSuccessBack)successBack errorBack:(ApifailedErrorBack)errorBack;
/**
 *  上传图像、文件
 *
 *  @param arguments            参数
 *  @param url                  请求地址,短地址除去BaseUrl
 *  @param fileData             文件二进制
 *  @param name                 对接参数
 *  @param fileName             文件名
 *  @param mimeType             文件类型
 *  @param successBack          成功Block回调
 *  @param errorBack            失败Block回调
 */
+ (void)sendApiUploadWithArguments:(NSDictionary *)arguments requestURL:(NSString *)url fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBack:(ApiSuccessBack)successBack errorBack:(ApifailedErrorBack)errorBack;

/**
 *  停止所有上传网络请求
 */
+ (void)cancelAllUploadTask;

@end


@implementation ApiRequestFunc

- (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/JavaScript", nil];
    return manager;
}

+ (void)sendApiRequestWithArguments:(NSDictionary *)arguments requestURL:(NSString *)url requestMethod:(ApiRequestMethod)method MD5Encryption:(BOOL)MD5Encryption successBack:(ApiSuccessBack)successBack errorBack:(ApifailedErrorBack)errorBack {
    NSLog(@"***** RequestURL: ***** %@",url);
    NSLog(@"***** arguments: ***** %@",arguments);
    NSDictionary *encryptionDict = arguments;
    
    AFHTTPSessionManager *manger = [[self alloc] manager];
    if (method == ApiRequestMethodGET) {
        [manger GET:url parameters:encryptionDict progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"***** RequestSuccess: ***** %@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
           
            if (successBack) {
                successBack(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (errorBack) {
                NSLog(@"***** RequestError: ***** %@",error);
                errorBack(error);
            }
        }];
    }else if (method == ApiRequestMethodPOST) {
        NSLog(@"***** arguments: ***** %@",encryptionDict);
        [manger POST: url parameters:encryptionDict progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"***** RequestSuccess: ***** %@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            
            if (successBack) {
                successBack(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (errorBack) {
                NSLog(@"***** RequestError: ***** %@",error);
                errorBack(error);
            }
        }];
    }
}

+ (void)sendApiUploadWithArguments:(NSDictionary *)arguments requestURL:(NSString *)url fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBack:(ApiSuccessBack)successBack errorBack:(ApifailedErrorBack)errorBack {
    NSLog(@"***** RequestURL: ***** %@",url);

    AFHTTPSessionManager *manger = [[self alloc] manager];
    [manger POST:url parameters:arguments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"***** RequestImageSuccess: ***** %@",[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);

        if (successBack) {
            successBack(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"***** RequestImageError: ***** %@",error);

        if (errorBack) {
            errorBack(error);
        }
    }];
}

const char *kUPLOADMANAGERS;

+ (NSMutableArray <AFHTTPSessionManager *>*)getUploadManagers {
    return objc_getAssociatedObject(self, &kUPLOADMANAGERS);
}

+ (void)setUploadManagers:(AFHTTPSessionManager *)manager {
    if (!manager) {
        return;
    }
    NSMutableArray *arrM = [self getUploadManagers];
    if (!arrM) {
        arrM = [NSMutableArray array];
    }
    [arrM addObject:manager];
    objc_setAssociatedObject(self, &kUPLOADMANAGERS, arrM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)cancelAllUploadTask {
    NSMutableArray *arrM = [self getUploadManagers];
    for (AFHTTPSessionManager *manager in arrM) {
        [manager.operationQueue cancelAllOperations];
    }
}

@end


@implementation ApiUtil

+ (void)cancelAllUploadTask {
    [ApiRequestFunc cancelAllUploadTask];
}

@end
