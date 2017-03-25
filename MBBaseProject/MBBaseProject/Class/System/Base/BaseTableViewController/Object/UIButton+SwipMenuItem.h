//
//  UIButton+SwipMenuItem.h
//  SwipCellDemo
//
//  Created by ZhangXiaofei on 17/3/20.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBSwipCellMenuItem;
@interface UIButton (SwipMenuItem)

+ (instancetype)buttonWithItem:(MBSwipCellMenuItem *)item;

- (instancetype)initWithItem:(MBSwipCellMenuItem *)item;

@end
