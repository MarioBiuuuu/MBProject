//
//  MBBaseTableViewController.m
//  MBBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBBaseTableViewController.h"
#import "MBBaseTableViewCell.h"
#import "MBBaseTableHeaderFooterView.h"
#import <objc/runtime.h>
#import "UIView+Tap.h"
#import "UIView+Layer.h"
#import "MJRefresh.h"
#import "MBRefreshUtil.h"

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define kSeperatorColor [UIColor colorWithRed:0.918 green:0.929 blue:0.941 alpha:1.000]
#define kWhiteColor [UIColor whiteColor]

//const char MBBaseTableVcNavRightItemHandleKey;
//const char MBBaseTableVcNavLeftItemHandleKey;

@interface MBBaseTableViewController ()
@property (nonatomic, copy) MBTableVcCellSelectedHandle handle;
@property (nonatomic, weak) UIImageView *refreshImg;
@end

@implementation MBBaseTableViewController
@synthesize needCellSepLine = _needCellSepLine;
@synthesize sepLineColor = _sepLineColor;

@synthesize hiddenStatusBar = _hiddenStatusBar;
@synthesize barStyle = _barStyle;
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

/**
 *  加载tableview
 */
- (MBBaseTableView *)tableView {
    if(!_tableView){
        UITableViewStyle style = UITableViewStylePlain;
        
        if (self.tableViewType == MBBaseTableViewTypeGroup) {
            style = UITableViewStyleGrouped;
        }
        
        MBBaseTableView *tab = [[MBBaseTableView alloc] initWithFrame:self.view.bounds style:style];
        [self.view addSubview:tab];
        _tableView = tab;
        tab.dataSource = self;
        tab.delegate = self;
        tab.backgroundColor = [UIColor colorWithWhite:0.940 alpha:1.000];
        tab.separatorColor = kSeperatorColor;
        //        WeakSelf(weakSelf);
        //        [tab emptyTableViewTapHandler:^(UIScrollView *scroollView, UIView *tapView) {
        //            [weakSelf loadData];
        //        }];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/** 监听通知*/
- (void)MB_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:notiName object:nil];
}

/** 设置刷新类型*/
- (void)MB_addRefreshControlWithRefreshType:(MBBaseTableVcRefreshType)refreshType headerType:(MBBaseTableVcHeaderRefreshType)headerType dropDownImageName:(NSString *)dropDownImageName dropDownImageCount:(NSUInteger)dropDownImageCount loadingImageName:(NSString *)loadingImageName loadingImageCount:(NSUInteger)loadingImageCount {
    self.refreshType = refreshType;
    switch (refreshType) {
        case MBBaseTableVcRefreshTypeNone: // 没有刷新
            break ;
        case MBBaseTableVcRefreshTypeOnlyCanRefresh: { // 只有下拉刷新
            [self MB_addRefreshWithHeaderType:headerType dropDownImageName:dropDownImageName dropDownImageCount:dropDownImageCount loadingImageName:loadingImageName loadingImageCount:loadingImageCount];
        } break ;
        case MBBaseTableVcRefreshTypeOnlyCanLoadMore: { // 只有上拉加载
            [self MB_addLoadMore];
        } break ;
        case MBBaseTableVcRefreshTypeRefreshAndLoadMore: { // 下拉和上拉都有
            [self MB_addRefreshWithHeaderType:headerType dropDownImageName:dropDownImageName dropDownImageCount:dropDownImageCount loadingImageName:loadingImageName loadingImageCount:loadingImageCount];
            [self MB_addLoadMore];
        } break ;
        default:
            break ;
    }
}
//- (void)setRefreshType:(MBBaseTableVcRefreshType)refreshType {
//    _refreshType = refreshType;
//    switch (refreshType) {
//        case MBBaseTableVcRefreshTypeNone: // 没有刷新
//            break ;
//        case MBBaseTableVcRefreshTypeOnlyCanRefresh: { // 只有下拉刷新
//            [self MB_addRefresh];
//        } break ;
//        case MBBaseTableVcRefreshTypeOnlyCanLoadMore: { // 只有上拉加载
//            [self MB_addLoadMore];
//        } break ;
//        case MBBaseTableVcRefreshTypeRefreshAndLoadMore: { // 下拉和上拉都有
//            [self MB_addRefresh];
//            [self MB_addLoadMore];
//        } break ;
//        default:
//            break ;
//    }
//}

- (NSString *)navItemTitle {
    return self.navigationItem.title;
}

/** statusBar是否隐藏*/
- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)hiddenStatusBar {
    return _hiddenStatusBar;
}

- (void)setBarStyle:(UIStatusBarStyle)barStyle {
    if (_barStyle == barStyle) return ;
    _barStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.hiddenStatusBar;
}

- (void)setShowRefreshIcon:(BOOL)showRefreshIcon {
    _showRefreshIcon = showRefreshIcon;
    self.refreshImg.hidden = !showRefreshIcon;
}

- (UIImageView *)refreshImg {
    if (!_refreshImg) {
        UIImageView *refreshImg = [[UIImageView alloc] init];
        [self.view addSubview:refreshImg];
        _refreshImg = refreshImg;
        [self.view bringSubviewToFront:refreshImg];
        refreshImg.image = [UIImage imageNamed:@"refresh"];
        
        [refreshImg setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        //子view的左边缘离父view的左边缘15个像素
        NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
        
        //子view的下边缘离父view的下边缘40个像素
        NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20.0];
        
        //子view的宽度为300
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
        
        //子view的高度为200
        NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:refreshImg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
        //把约束添加到父视图上
        NSArray *array = [NSArray arrayWithObjects:constraintLeft, constraintBottom, constraintWidth, constraintHeight, nil];
        
        [self.view addConstraints:array];
        WeakSelf(weakSelf);
        refreshImg.layerCornerRadius = 22;
        refreshImg.backgroundColor = kWhiteColor;
        
        [refreshImg setTapActionWithBlock:^{
            [self startAnimation];
            [weakSelf MB_beginRefresh];
        }];
    }
    return _refreshImg;
}

- (void)startAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.refreshImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endRefreshIconAnimation {
    [self.refreshImg.layer removeAnimationForKey:@"rotationAnimation"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}

/** 需要系统分割线*/
- (void)setNeedCellSepLine:(BOOL)needCellSepLine {
    _needCellSepLine = needCellSepLine;
    self.tableView.separatorStyle = needCellSepLine ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
}

- (BOOL)needCellSepLine {
    return self.tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLine;
}

- (void)MB_addRefreshWithHeaderType:(MBBaseTableVcHeaderRefreshType)headerType dropDownImageName:(NSString *)dropDownImageName dropDownImageCount:(NSUInteger)dropDownImageCount loadingImageName:(NSString *)loadingImageName loadingImageCount:(NSUInteger)loadingImageCount {
    MBRefreshUtilHeaderRefreshType type = MBRefreshUtilHeaderRefreshTypeNormal;
    switch (headerType) {
        case MBBaseTableVcHeaderRefreshTypeNormal:
            type = MBRefreshUtilHeaderRefreshTypeNormal;
            break;
        case MBBaseTableVcHeaderRefreshTypeGif:
            type = MBRefreshUtilHeaderRefreshTypeGif;
            break;
            
        default:
            break;
    }
    [MBRefreshUtil addPullRefreshForScrollView:self.tableView isChat:self.isChat headerType:type dropDownImageName:dropDownImageName dropDownImageCount:dropDownImageCount loadingImageName:loadingImageName loadingImageCount:loadingImageCount pullRefreshCallBack:^{
        [self MB_refresh];

    }];
}

- (void)MB_addLoadMore {
    [MBRefreshUtil addLoadMoreForScrollView:self.tableView loadMoreCallBack:^{
        [self MB_loadMore];
    }];
}

/** 表视图偏移*/
- (void)setTableEdgeInset:(UIEdgeInsets)tableEdgeInset {
    _tableEdgeInset = tableEdgeInset;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    //    WeakSelf(weakSelf);
    //    // update
    ////    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
    ////        make.edges.equalTo(weakSelf.view).mas_offset(weakSelf.tableEdgeInset);
    ////    }];
    self.tableView.contentInset = self.tableEdgeInset;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    [self.view sendSubviewToBack:self.tableView];
}
/** 分割线颜色*/
- (void)setSepLineColor:(UIColor *)sepLineColor {
    if (!self.needCellSepLine) return;
    _sepLineColor = sepLineColor;
    
    if (sepLineColor) {
        self.tableView.separatorColor = sepLineColor;
    }
}

- (UIColor *)sepLineColor {
    return _sepLineColor ? _sepLineColor : [UIColor whiteColor];
}

/** 刷新数据*/
- (void)MB_reloadData {
    [self.tableView reloadData];
}

/** 开始下拉*/
- (void)MB_beginRefresh {
    if (self.refreshType == MBBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == MBBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [MBRefreshUtil beginPullRefreshForScrollView:self.tableView];
    }
}

/** 刷新*/
- (void)MB_refresh {
    if (self.refreshType == MBBaseTableVcRefreshTypeNone || self.refreshType == MBBaseTableVcRefreshTypeOnlyCanLoadMore) {
        return ;
    }
    self.isRefresh = YES; self.isLoadMore = NO;
}

/** 上拉加载*/
- (void)MB_loadMore {
    if (self.refreshType == MBBaseTableVcRefreshTypeNone || self.refreshType == MBBaseTableVcRefreshTypeOnlyCanRefresh) {
        return ;
    }
    if (self.dataArray.count == 0) {
        return ;
    }
    self.isRefresh = NO; self.isLoadMore = YES;
    
}

/** 停止刷新*/
- (void)MB_endRefresh {
    if (self.refreshType == MBBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == MBBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [MBRefreshUtil endRefreshForScrollView:self.tableView];
    }
}

/** 停止上拉加载*/
- (void)MB_endLoadMore {
    if (self.refreshType == MBBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == MBBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [MBRefreshUtil endLoadMoreForScrollView:self.tableView];
    }
}

/** 隐藏刷新*/
- (void)MB_hiddenRrefresh {
    if (self.refreshType == MBBaseTableVcRefreshTypeOnlyCanRefresh || self.refreshType == MBBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [MBRefreshUtil hiddenHeaderForScrollView:self.tableView];
    }
}

/** 隐藏上拉加载*/
- (void)MB_hiddenLoadMore {
    if (self.refreshType == MBBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == MBBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [MBRefreshUtil hiddenFooterForScrollView:self.tableView];
    }
}

/** 提示没有更多信息*/
- (void)MB_noticeNoMoreData {
    if (self.refreshType == MBBaseTableVcRefreshTypeOnlyCanLoadMore || self.refreshType == MBBaseTableVcRefreshTypeRefreshAndLoadMore) {
        [MBRefreshUtil noticeNoMoreDataForScrollView:self.tableView];
    }
}

/** 头部正在刷新*/
- (BOOL)isHeaderRefreshing {
    return [MBRefreshUtil headerIsRefreshForScrollView:self.tableView];
}

//* 尾部正在刷新
- (BOOL)isFooterRefreshing {
    return [MBRefreshUtil footerIsLoadingForScrollView:self.tableView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
// 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(MB_numberOfSections)]) {
        return self.MB_numberOfSections;
    }
    return 0;
}

// 指定组返回的cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(MB_numberOfRowsInSection:)]) {
        return [self MB_numberOfRowsInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(MB_headerAtSection:)]) {
        return [self MB_headerAtSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(MB_footerAtSection:)]) {
        return [self MB_footerAtSection:section];
    }
    return nil;
}

// 每一行返回指定的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self respondsToSelector:@selector(MB_cellAtIndexPath:)]) {
        return [self MB_cellAtIndexPath:indexPath];
    }
    // 1. 创建cell
    MBBaseTableViewCell *cell = [MBBaseTableViewCell cellWithTableView:self.tableView];
    
    // 2. 返回cell
    return cell;
}

// 点击某一行 触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.navigationController) {
        if (![self.navigationController.topViewController isEqual:self]) {
            return;
        }
    }
    
    MBBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self respondsToSelector:@selector(MB_didSelectCellAtIndexPath:cell:)]) {
        [self MB_didSelectCellAtIndexPath:indexPath cell:cell];
    }
}

- (UIView *)refreshHeader {
    return self.tableView.mj_header;
}

// 设置分割线偏移间距并适配
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.needCellSepLine) return ;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([self respondsToSelector:@selector(MB_sepEdgeInsetsAtIndexPath:)]) {
        edgeInsets = [self MB_sepEdgeInsetsAtIndexPath:indexPath];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) [tableView setSeparatorInset:edgeInsets];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) [tableView setLayoutMargins:edgeInsets];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:edgeInsets];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) [cell setLayoutMargins:edgeInsets];
    
    if ([self respondsToSelector:@selector(MB_cellWillDisplay:forRowAtIndexPath:)]) {
        [self MB_cellWillDisplay:(MBBaseTableViewCell *)cell forRowAtIndexPath:indexPath];
    }
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(MB_cellheightAtIndexPath:)]) {
        return [self MB_cellheightAtIndexPath:indexPath];
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(MB_sectionHeaderHeightAtSection:)]) {
        return [self MB_sectionHeaderHeightAtSection:section];
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(MB_sectionFooterHeightAtSection:)]) {
        return [self MB_sectionFooterHeightAtSection:section];
    }
    return 0.01;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(MB_sectionIndexTitles)]) {
        return [self MB_sectionIndexTitles];
    }
    return @[];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(MB_titleForHeaderInSection:)]) {
        return [self MB_titleForHeaderInSection:section];
    }
    return @"";
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self respondsToSelector:@selector(MB_sectionForSectionIndexTitle:atIndex:)]) {
        return [self MB_sectionForSectionIndexTitle:title atIndex:index];
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(MB_canEditActionForRowAtIndexPath:)]) {
        return [self MB_canEditActionForRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(MB_commitEditActionWithStyle:atIndexPath:)]) {
        [self MB_commitEditActionWithStyle:editingStyle atIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(MB_titleForDeleteAtIndexPath:)]) {
        return [self MB_titleForDeleteAtIndexPath:indexPath];
    }
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)MB_numberOfSections {
    return 1;
}

- (NSInteger)MB_numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)MB_cellAtIndexPath:(NSIndexPath *)indexPath {
    return [MBBaseTableViewCell cellWithTableView:self.tableView];
}

- (CGFloat)MB_cellheightAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (void)MB_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(MBBaseTableViewCell *)cell {
}

- (UIView *)MB_headerAtSection:(NSInteger)section {
    return [MBBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView];
}

- (UIView *)MB_footerAtSection:(NSInteger)section {
    return [MBBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView];
}

- (CGFloat)MB_sectionHeaderHeightAtSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)MB_sectionFooterHeightAtSection:(NSInteger)section {
    return 0.01;
}

- (UIEdgeInsets)MB_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

- (NSArray *)MB_sectionIndexTitles {
    return @[];
}

- (NSString *)MB_titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)MB_sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

- (NSArray<UITableViewRowAction *> *)MB_editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}

- (BOOL)MB_canEditActionForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(NSString *)MB_titleForDeleteAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)MB_commitEditActionWithStyle:(UITableViewCellEditingStyle)style atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)MB_cellWillDisplay:(MBBaseTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
