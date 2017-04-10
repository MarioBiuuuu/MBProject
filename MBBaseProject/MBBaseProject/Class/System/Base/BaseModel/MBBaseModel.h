//
//  LKBaseModel.h
//  Dangdang
//
//  Created by Yuri on 16/6/16.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <UIKit/UIKit.h>
#import "ApiUtil.h"

@interface MBBaseModel : NSObject<NSCoding>
/**
 子类重写返回请求参数体
 
 @return
 */
+ (NSDictionary *)arguments;

/**
 子类重写返回请求方式
 
 @return
 */
+ (ApiRequestMethod)requestMethod;

/**
 子类重写发挥请求地址
 
 @return
 */
+ (NSString *)requestUrl;

/**
 子类重写返回是否是用MD5加密
 
 @return
 */
+ (BOOL)MD5Encryption;

/**
 子类模型类直接调用此方法生成对应的模型对象,注意:此处模型结构要与返回数据结构一样, 否则会导致模型转换失败
 
 @param handler 回调
 */
+ (void)fetchDataComplate:(void (^)(BOOL finished, NSDictionary *jsonObject, id resultModel, NSError *error))handler;

@end
