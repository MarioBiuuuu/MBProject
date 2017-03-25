//
//  MBBaseTableViewCell.h
//  MBBaseController
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSwipCellMenuItem.h"

@interface MBBaseTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL autoClose;

- (void)closeLeftSwipe; //关闭左滑

- (void)addMenuItems:(NSArray <MBSwipCellMenuItem *>*)items;
/**
 *  返回持有该cell的tableview
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 *  快速创建一个不是从xib中加载的tableview cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  快速创建一个从xib中加载的tableview cell
 */
+ (instancetype)nibCellWithTableView:(UITableView *)tableView;

/**
 *  获取cell的复用ID
 *
 *  @return
 */
+ (NSString *)getCellReuserIdentifer;
@end