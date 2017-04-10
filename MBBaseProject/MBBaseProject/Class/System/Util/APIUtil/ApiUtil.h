//
//  ApiUtil.h
//  LKProject
//
//  Created by yunjing on 2017/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ApiRequestMethod) {
    ApiRequestMethodGET = 0,
    ApiRequestMethodPOST,
};

@interface ApiUtil : NSObject

/**
 *  停止所有上传网络请求
 */
+ (void)cancelAllUploadTask;

/**
 发送模型对象数据请求
 
 @param url 请求地址
 @param arguments 请求参数
 @param requestMethod 请求方式
 @param MD5Encryption 是否加密
 @param response 成功
 @param error 失败
 */
+ (void)sendModelRequestWithUrl:(NSString *)url arguments:(NSDictionary *)arguments requestMethod:(ApiRequestMethod)requestMethod MD5Encryption:(BOOL)MD5Encryption success:(void (^)(NSDictionary *jsonObject))response failed:(void (^)(NSError *error))error;
@end
