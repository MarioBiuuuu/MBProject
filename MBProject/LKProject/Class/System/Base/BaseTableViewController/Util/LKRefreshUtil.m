//
//  LKRefreshUtil.m
//  LKBaseController
//
//  Created by 张晓飞 on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKRefreshUtil.h"

@interface LKChatRefreshHeader ()
@property (weak, nonatomic) UIActivityIndicatorView *loading;

@end

@implementation LKChatRefreshHeader

- (void)prepare {
    [super prepare];
    
    self.mj_h = 50;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    self.loading.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}

@end

@implementation LKGifRefreshHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=self.dropDownImageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd", self.dropDownImageName, i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=self.loadingImageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0%zd", self.loadingImageName, i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end


@implementation LKRefreshUtil
+ (NSInteger)totalDataCountForScrollView:(UIScrollView *)scrollView {
    NSInteger totalCount = 0;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)scrollView;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

/** 开始下拉刷新*/
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

/**判断头部是否在刷新*/
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView {
    
    BOOL flag =  scrollView.mj_header.isRefreshing;
    return flag;
}

/**判断是否尾部在刷新*/
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView {
    return  scrollView.mj_footer.isRefreshing;
}

/**提示没有更多数据的情况*/
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshingWithNoMoreData];
}

/**重置footer*/
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer resetNoMoreData];
}

/**停止下拉刷新*/
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
}

/**停止上拉加载*/
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshing];
}

/** 隐藏footer*/
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView {
    // 不确定是哪个类型的footer
    scrollView.mj_footer.hidden = YES;
}

/**隐藏header*/
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView {
    scrollView.mj_header.hidden = YES;
}

/**上拉*/
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(LKRefreshAndLoadMoreHandle)loadMoreCallBackBlock {
    
    if (scrollView == nil || loadMoreCallBackBlock == nil) {
        return ;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (loadMoreCallBackBlock) {
            loadMoreCallBackBlock();
        }
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor colorWithWhite:0.353 alpha:1.000];
    footer.stateLabel.font = [UIFont systemFontOfSize:13.f];
    //    footer.automaticallyHidden = YES;
    scrollView.mj_footer = footer;
    footer.backgroundColor = [UIColor clearColor];
    
    
}

/**下拉*/
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView
                             isChat:(BOOL)isChat
                         headerType:(LKRefreshUtilHeaderRefreshType)headerType
                  dropDownImageName:(NSString *)dropDownImageName
                 dropDownImageCount:(NSUInteger)dropDownImageCount
                   loadingImageName:(NSString *)loadingImageName
                  loadingImageCount:(NSUInteger)loadingImageCount
                pullRefreshCallBack:(LKRefreshAndLoadMoreHandle)pullRefreshCallBackBlock {
    __weak typeof(UIScrollView *)weakScrollView = scrollView;
    if (scrollView == nil || pullRefreshCallBackBlock == nil) {
        return ;
    }
    
    if (isChat) {
        LKChatRefreshHeader *header = [LKChatRefreshHeader headerWithRefreshingBlock:^{
            if (pullRefreshCallBackBlock) {
                pullRefreshCallBackBlock();
            }
            if (weakScrollView.mj_footer.hidden == NO) {
                [weakScrollView.mj_footer resetNoMoreData];
            }
        }];
        scrollView.mj_header = header;
        
    } else {
        switch (headerType) {
            case LKRefreshUtilHeaderRefreshTypeNormal: {
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    if (pullRefreshCallBackBlock) {
                        pullRefreshCallBackBlock();
                    }
                    if (weakScrollView.mj_footer.hidden == NO) {
                        [weakScrollView.mj_footer resetNoMoreData];
                    }
                    
                }];
                [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
                [header setTitle:@"正在更新" forState:MJRefreshStateRefreshing];
                [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
                header.stateLabel.font = [UIFont systemFontOfSize:13];
                header.stateLabel.textColor = [UIColor blackColor];
                
                header.lastUpdatedTimeLabel.hidden = YES;
                
                scrollView.mj_header = header;
            }
                break;
            case LKRefreshUtilHeaderRefreshTypeGif: {
                LKGifRefreshHeader *header = [LKGifRefreshHeader headerWithRefreshingBlock:^{
                    if (pullRefreshCallBackBlock) {
                        pullRefreshCallBackBlock();
                    }
                    if (weakScrollView.mj_footer.hidden == NO) {
                        [weakScrollView.mj_footer resetNoMoreData];
                    }
                }];
                header.dropDownImageName = dropDownImageName;
                header.dropDownImageCount = dropDownImageCount;
                header.loadingImageName = loadingImageName;
                header.loadingImageCount = loadingImageCount;
                [header beginRefreshing];
            }
                break;
                
            default:
                break;
        }
    }
    
}

@end
