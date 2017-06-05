//
//  NSString+Pinyin.h
//  MBBaseProject
//
//  Created by ZhangXiaofei on 2017/6/5.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Pinyin)
/** 将汉字转化成拼音 */
- (NSString *)translateChineseToPinYin;
@end
