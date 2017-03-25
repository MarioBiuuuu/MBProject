//
//  UIControl+Delay.h
//  LKProject
//
//  Created by ZhangXiaofei on 17/3/21.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Delay)

/**
 *  按钮响应延迟时间(单位:秒)
 */
@property (nonatomic, assign) NSTimeInterval delay_acceptEventTime;

@end
