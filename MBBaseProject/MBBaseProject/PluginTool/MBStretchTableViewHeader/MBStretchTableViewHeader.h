//
//  MBStretchTableViewHeader.h
//  MBStretchTableViewHeader
//
//  Created by ZhangXiaofei on 17/2/27.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBStretchTableViewHeader : NSObject

/**
 *  表头子视图是否随着移动, 默认为YES
 */
@property (nonatomic, assign) BOOL headerSubViewMoving;

/**
 构造方法  
 
 @param tableView 当前操作TableView
 @param headerView 表头
 @param holderViews 待移动视图十足
 @return 对象
 */
- (instancetype)initWithTableView:(UITableView *)tableView headerView:(UIView *)headerView holderViews:(NSArray<UIView *> *)holderViews;

/**
 配置表头
 
 @param tableView 当前操作TableView
 @param headerView 表头
 @param holderViews 待移动视图十足
 */
- (void)configureWithTableView:(UITableView *)tableView headerView:(UIView *)headerView holderViews:(NSArray<UIView *> *)holderViews;

@end
