//
//  NSString+Cutout.h
//  LKProject
//
//  Created by Kipling on 2017/3/9.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Cutout)

/**
 * 判断是否为表情

 @param string 传入字符
 @return 1 是 0 否
 */
+ (BOOL)isEmoji:(NSString *)string;

/**
 * 字符串长度

 @param string 传入字符串
 @return 字符串长度(表情算1个)
 */
+ (NSInteger)lengthOfString:(NSString *)string;

@end
