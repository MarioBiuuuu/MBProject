//
//  LKBaseModel.m
//  Dangdang
//
//  Created by Yuri on 16/6/16.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "MBBaseModel.h"
#import <objc/runtime.h>

/** 归档 */
#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \
- (NSUInteger)hash { return [self yy_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

@implementation MBBaseModel

/** 映射模型中的属性 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

/** 映射模型中的容器类型属性 数组/字典/集合 */
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{};
}

YYModelSynthCoderAndHash

+ (void)fetchDataComplate:(void (^)(BOOL finished, NSDictionary *jsonObject, id resultModel, NSError *error))handler {
    [ApiUtil sendModelRequestWithUrl:[self requestUrl] arguments:[self arguments] requestMethod:[self requestMethod] MD5Encryption:[self MD5Encryption] success:^(NSDictionary *jsonObject) {
        id model = [[self class] yy_modelWithDictionary:jsonObject];
        handler(YES, jsonObject, model, nil);
    } failed:^(NSError *error) {
        handler(NO, nil, nil, error);
    }];
}

+ (ApiRequestMethod)requestMethod {
    return ApiRequestMethodGET;
}

+ (NSString *)requestUrl {
    return @"";
}

+ (NSDictionary *)arguments {
    return nil;
}

+ (BOOL)MD5Encryption {
    return NO;
}
@end
