//
//  MBSwipCellMenuItem.m
//  SwipCellDemo
//
//  Created by ZhangXiaofei on 17/3/20.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBSwipCellMenuItem.h"

@implementation MBSwipCellMenuItem
- (void)clickItem:(MBSwipCellItemHandler)handler {
    self.handler = handler;
}
@end
