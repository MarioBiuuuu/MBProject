//
//  NSString+LKEncry.h
//  MD5 加密
//
//  Created by yunjing on 2017/2/21.
//  Copyright © 2017年 yunjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LKEncry)

/**
 *  请求验证码加密方法
 *
 *  @param string     加密字符串
 *  @return           加密完的字符串
 */

+ (NSString *)luckyKingEncryptionWithString:(NSString *)string;
/**
 *   生成MD5 加密接口 
 *
 *  @param arguments     加密的字典
 *  @return              加密完的字典
 */
+ (NSDictionary *)generateArguments:(NSDictionary *)arguments;

/**
 *   生成MD5 加密接口  (登录、注册、修改密码接口)
 *
 *  @param arguments     加密的字典
 *  @return              加密完的字典
 */
+ (NSDictionary *)generatePartArguments:(NSDictionary *)arguments;

+ (BOOL)validateNeedSaltValue:(NSString *)url;
@end
