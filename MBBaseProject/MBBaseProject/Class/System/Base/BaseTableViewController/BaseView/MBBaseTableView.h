//
//  MBBaseTableView.h
//  MBBaseController
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBBaseTableViewRowAnimation) {
    Fade = UITableViewRowAnimationFade,
    Right = UITableViewRowAnimationRight,           // slide in from right (or out to right)
    Left = UITableViewRowAnimationLeft,
    Top = UITableViewRowAnimationTop,
    Bottom = UITableViewRowAnimationBottom,
    None = UITableViewRowAnimationNone,            // available in iOS 3.0
    Middle = UITableViewRowAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
    Automatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
};

typedef NS_ENUM(NSInteger, MBBaseTableViewEmptyImageType) {
    MBBaseTableViewEmptyImageTypeNoNetwork = 0,            //无网络
    MBBaseTableViewEmptyImageTypeSendRedEnvelopeStatus,  //红包发放状态: 待发放、发放中、已结束
    MBBaseTableViewEmptyImageTypeRedEnvelopeManagementCenter, //红包管理中心
    MBBaseTableViewEmptyImageTypeVoucherAndKind,             //优惠券和实物类
    MBBaseTableViewEmptyOnlyString,                          //只有文字
};

typedef void(^TapViewHandler)(UIScrollView *scroollView, UIView *tapView);

@class MBBaseTableViewCell;

@interface MBBaseTableView : UITableView

@property (nonatomic, assign) BOOL isShowEmptyView;

@property (nonatomic, copy) TapViewHandler tapViewBlock;

@property (nonatomic, strong) UIImage *emptyImage;

@property (nonatomic, copy) NSString *emptyTipString;

@property (nonatomic, strong) UIFont *emptyTipStringFont;

@property (nonatomic, strong) UIColor *emptyTipStringColor;

@property (nonatomic, copy) NSString *emptySubTipString;

@property (nonatomic, strong) UIFont *emptySubTipStringFont;

@property (nonatomic, strong) UIColor *emptySubTipStringColor;

@property (nonatomic, strong) UIColor *emptyBackgroundColor;

@property (nonatomic, assign) MBBaseTableViewEmptyImageType emptyImageType;

@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) CGFloat imageSpace;

@property (nonatomic, assign) BOOL emptyViewScrollEnable;

- (void)emptyTableViewTapHandler:(TapViewHandler)handler;

- (void)MB_updateWithUpdateBlock:(void(^)(MBBaseTableView *tableView ))updateBlock;

- (UITableViewCell *)MB_cellAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  注册普通的UITableViewCell
 *
 *  @param cellClass  Class
 *  @param identifier 复用标示
 */
- (void)MB_registerCellClass:(Class)cellClass identifier:(NSString *)identifier;

/**
 *  注册一个从xib中加载的UITableViewCell
 *
 *  @param cellNib       nib
 *  @param nibIdentifier 复用标示
 */
- (void)MB_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier;

/**
 *  注册一个普通的UITableViewHeaderFooterView
 *
 *  @param headerFooterClass Class
 *  @param identifier        复用标示
 */
- (void)MB_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier;

/**
 *  注册一个从xib中加载的UITableViewHeaderFooterView
 *
 *  @param headerFooterNib nib
 *  @param nibIdentifier   复用标示
 */
- (void)MB_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier;

#pragma mark - 只对已经存在的cell进行刷新
/**
 *  刷新单行
 *
 *  @param indexPath 坐标
 */
- (void)MB_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  刷新单行
 *
 *  @param indexPath 坐标
 *  @param animation 动画类型
 */
- (void)MB_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  刷新多行
 *
 *  @param indexPaths 坐标
 */
- (void)MB_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 *  刷新多行
 *
 *  @param indexPaths 坐标
 *  @param animation  动画类型
 */
- (void)MB_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  刷新某个section
 *
 *  @param section 分组坐标
 */
- (void)MB_reloadSingleSection:(NSInteger)section;

/**
 *  刷新某个section
 *
 *  @param section   分组坐标
 *  @param animation 动画类型
 */
- (void)MB_reloadSingleSection:(NSInteger)section animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  刷新多个section
 *
 *  @param sections 坐标
 */
- (void)MB_reloadSections:(NSArray <NSNumber *>*)sections;

/**
 *  刷新多个section
 *
 *  @param sections  分组坐标
 *  @param animation 动画类型
 */
- (void)MB_reloadSections:(NSArray <NSNumber *>*)sections animation:(MBBaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/**
 *  删除单行
 *
 *  @param indexPath 坐标
 */
- (void)MB_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  删除单行
 *
 *  @param indexPath 坐标
 *  @param animation 动画类型
 */
- (void)MB_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  删除多行
 *
 *  @param indexPaths 坐标
 */
- (void)MB_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 *  删除多行
 *
 *  @param indexPaths 坐标
 *  @param animation  动画类型
 */
- (void)MB_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  删除某个section
 *
 *  @param section 坐标
 */
- (void)MB_deleteSingleSection:(NSInteger)section;

/**
 *  删除某个section
 *
 *  @param section   坐标
 *  @param animation 动画类型
 */
- (void)MB_deleteSingleSection:(NSInteger)section animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  删除多个section
 *
 *  @param sections 坐标
 */
- (void)MB_deleteSections:(NSArray <NSNumber *>*)sections;

/**
 *  删除多个section
 *
 *  @param sections  坐标
 *  @param animation 动画类型
 */
- (void)MB_deleteSections:(NSArray <NSNumber *>*)sections animation:(MBBaseTableViewRowAnimation)animation;

#pragma mark - 插入cell
/**
 *  增加单行
 *
 *  @param indexPath 坐标
 */
- (void)MB_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  增加单行
 *
 *  @param indexPath 坐标
 *  @param animation 动画类型
 */
- (void)MB_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  增加单个section
 *
 *  @param section 坐标
 */
- (void)MB_insertSingleSection:(NSInteger)section;

/**
 *  增加单个section
 *
 *  @param section   坐标
 *  @param animation 动画类型
 */
- (void)MB_insertSingleSection:(NSInteger)section animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  增加多行
 *
 *  @param indexPaths 坐标
 */
- (void)MB_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/**
 *  增加多行
 *
 *  @param indexPaths 坐标
 *  @param animation  动画类型
 */
- (void)MB_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(MBBaseTableViewRowAnimation)animation;

/**
 *  增加多section
 *
 *  @param sections 坐标
 */
- (void)MB_insertSections:(NSArray <NSNumber *>*)sections;

/**
 *  增加多section
 *
 *  @param sections  坐标
 *  @param animation 动画类型
 */
- (void)MB_insertSections:(NSArray <NSNumber *>*)sections animation:(MBBaseTableViewRowAnimation)animation;


@end
