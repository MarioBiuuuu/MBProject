//
//  MBSwipCellMenuItem.h
//  SwipCellDemo
//
//  Created by ZhangXiaofei on 17/3/20.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBSwipCellMenuItem;

typedef void(^MBSwipCellItemHandler)(MBSwipCellMenuItem *item);

typedef NS_ENUM(NSInteger, MBSwipCellItemStyle) {
    MBSwipCellItemStyleNormal     = 0,  // 默认Button展示类型
    MBSwipCellItemStyleCenter     = 1,  // 图片文字居中
    MBSwipCellItemStyleOnlyImage  = 2,  // 仅图片
    MBSwipCellItemStyleOnlyTitle  = 3,  // 仅文字
};

@interface MBSwipCellMenuItem : NSObject

/**
 *  未选中状态图片
 */
@property (nonatomic, strong) UIImage *normalImage;

/**
 *  选中状态图片
 */
@property (nonatomic, strong) UIImage *selectedImage;

/**
 *  标题文字
 */
@property (nonatomic, copy) NSString *itemTitle;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  选项背景色
 */
@property (nonatomic, strong) UIColor *itemBackgroundColor;

/**
 *  标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  选项宽度
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  选项类型 MBSwipCellItemStyle
 */
@property (nonatomic, assign) MBSwipCellItemStyle style;

/**
 *  Menu点击处理
 */
@property (nonatomic,copy) MBSwipCellItemHandler handler;

/**
 点击某一个item出发回调

 @param handler 回调
 */
- (void)clickItem:(MBSwipCellItemHandler)handler;

@end
