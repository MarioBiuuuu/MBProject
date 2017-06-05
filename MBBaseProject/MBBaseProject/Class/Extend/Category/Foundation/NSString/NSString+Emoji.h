//
//  NSString+Emoji.h
//  MBBaseProject
//
//  Created by ZhangXiaofei on 2017/6/5.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)
/** 判断字符传中是否包含Emoji表情 */
- (void)judgeEmojiComplate:(void (^)(BOOL isContains, NSUInteger emojiCount))complate;
@end
