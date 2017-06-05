//
//  NSString+Pinyin.m
//  MBBaseProject
//
//  Created by ZhangXiaofei on 2017/6/5.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "NSString+Pinyin.h"

@implementation NSString (Pinyin)
- (NSString *)translateChineseToPinYin {
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}
@end
