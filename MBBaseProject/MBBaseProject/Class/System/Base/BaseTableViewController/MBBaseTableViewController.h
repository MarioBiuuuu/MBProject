//
//  MBBaseTableViewController.h
//  MBBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBBaseViewController.h"
#import "MBBaseTableViewCell.h"
#import "MBBaseTableView.h"

typedef void(^MBTableVcCellSelectedHandle)(MBBaseTableViewCell *cell, NSIndexPath *indexPath);

typedef NS_ENUM(NSUInteger, MBBaseTableVcRefreshType) {
    //无刷新
    MBBaseTableVcRefreshTypeNone = 0,
    //仅刷新
    MBBaseTableVcRefreshTypeOnlyCanRefresh,
    //仅上拉加载
    MBBaseTableVcRefreshTypeOnlyCanLoadMore,
    //刷新 + 加载
    MBBaseTableVcRefreshTypeRefreshAndLoadMore
};

typedef NS_ENUM(NSUInteger, MBBaseTableVcHeaderRefreshType) {
    // 菊花
    MBBaseTableVcHeaderRefreshTypeNormal = 0,
    // gif
    MBBaseTableVcHeaderRefreshTypeGif
};

typedef NS_ENUM(NSUInteger, MBBaseTableViewType) {
    //默认 plain
    MBBaseTableViewTypeNormal = 0,
    //plain
    MBBaseTableViewTypePlain,
    //group
    MBBaseTableViewTypeGroup,
};

@interface MBBaseTableViewController : MBBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_dataArray;
}

/**
 *  设置tableview的类型 plain/group
 */
@property (nonatomic, assign) MBBaseTableViewType tableViewType;

@property (nonatomic, assign) MBBaseTableVcRefreshType refreshType;

/**
 *  刚才执行的是刷新
 */
@property (nonatomic, assign) NSInteger isRefresh;

/**
 *  刚才执行的是上拉加载
 */
@property (nonatomic, assign) NSInteger isLoadMore;

/**
 *  监听通知
 *
 *  @param notiName 通知名
 *  @param action   操作
 */
- (void)MB_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action;

/**
 *  隐藏statusBar
 */
@property (nonatomic, assign) BOOL hiddenStatusBar;

/**
 *  statusBar风格
 */
@property (nonatomic, assign) UIStatusBarStyle barStyle;


/**
 *  表视图
 */
@property (nonatomic, weak) MBBaseTableView *tableView;

/**
 *  表视图偏移
 */
@property (nonatomic, assign) UIEdgeInsets tableEdgeInset;

/**
 *  分割线颜色
 */
@property (nonatomic, assign) UIColor *sepLineColor;

/**
 *  数据源数量
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  加载即时通讯类页面只显示菊花
 */
@property (nonatomic, assign) BOOL isChat;

/**
 *  是否需要系统的cell的分割线
 */
@property (nonatomic, assign) BOOL needCellSepLine;

/**
 *  添加表视图刷新控件
 *
 *  @param refreshType 控件类型
 *  @param headerType 表头控件类型
 *  @param dropDownImageName 下拉动图
 *  @param dropDownImageCount 下拉动图数量
 *  @param loadingImageName 刷新动图
 *  @param loadingImageCount 刷新动图数量
 */
- (void)MB_addRefreshControlWithRefreshType:(MBBaseTableVcRefreshType)refreshType
                                 headerType:(MBBaseTableVcHeaderRefreshType)headerType
                          dropDownImageName:(NSString *)dropDownImageName
                         dropDownImageCount:(NSUInteger)dropDownImageCount
                           loadingImageName:(NSString *)loadingImageName
                          loadingImageCount:(NSUInteger)loadingImageCount;

/**
 *  刷新数据
 */
- (void)MB_reloadData;

/**
 *  开始下拉
 */
- (void)MB_beginRefresh;

/**
 *  停止刷新
 */
- (void)MB_endRefresh;

/**
 *  停止上拉加载
 */
- (void)MB_endLoadMore;

/**
 *  隐藏刷新
 */
- (void)MB_hiddenRrefresh;

/**
 *  隐藏上拉加载
 */
- (void)MB_hiddenLoadMore;

/**
 *  提示没有更多信息
 */
- (void)MB_noticeNoMoreData;

/**
 *  是否在下拉刷新
 */
@property (nonatomic, assign, readonly) BOOL isHeaderRefreshing;

/**
 *  是否在上拉加载
 */
@property (nonatomic, assign, readonly) BOOL isFooterRefreshing;

#pragma mark - 子类去重写
/**
 *  分组数量
 *
 *  @return <#return value description#>
 */
- (NSInteger)MB_numberOfSections;

/**
 *  某个分组的cell数量
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)MB_numberOfRowsInSection:(NSInteger)section;

/**
 *  某行的cell
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (MBBaseTableViewCell *)MB_cellAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  点击某行
 *
 *  @param indexPath <#indexPath description#>
 *  @param cell      <#cell description#>
 */
- (void)MB_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(MBBaseTableViewCell *)cell;

/**
 *  行高
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)MB_cellheightAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  某个组头
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)MB_headerAtSection:(NSInteger)section;

/**
 *  某个组bottom视图
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)MB_footerAtSection:(NSInteger)section;

/**
 *  某个组头高度
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)MB_sectionHeaderHeightAtSection:(NSInteger)section;

/**
 *  某个组尾高度
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)MB_sectionFooterHeightAtSection:(NSInteger)section;

/**
 *  侧边栏数组
 *
 *  @return <#return value description#>
 */
- (NSArray *)MB_sectionIndexTitles;

/**
 *  索引
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)MB_titleForHeaderInSection:(NSInteger)section;

/**
 *  索引
 *
 *  @param section <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)MB_sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;


/**
 *  分割线偏移
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UIEdgeInsets)MB_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  自定义侧滑操作
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
-(NSArray<UITableViewRowAction *> *)MB_editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  自定义侧滑操作开关
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)MB_canEditActionForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  cell即将显示
 *
 *  @param cell <#cell description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)MB_cellWillDisplay:(MBBaseTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - 子类去继承
/**
 *  刷新方法
 */
- (void)MB_refresh;

/**
 *  上拉加载方法
 */
- (void)MB_loadMore;

@property (nonatomic, assign) BOOL showRefreshIcon;

- (void)endRefreshIconAnimation;

@property (nonatomic, weak, readonly) UIView *refreshHeader;


@end
