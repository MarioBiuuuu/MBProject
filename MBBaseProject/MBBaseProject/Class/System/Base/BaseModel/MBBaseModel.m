//
//  LKBaseModel.m
//  Dangdang
//
//  Created by Yuri on 16/6/16.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "MBBaseModel.h"
#import <objc/runtime.h>

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
@end
