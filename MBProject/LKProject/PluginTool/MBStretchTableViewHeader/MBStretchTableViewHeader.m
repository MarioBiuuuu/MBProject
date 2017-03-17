//
//  MBStretchTableViewHeader.m
//  MBStretchTableViewHeader
//
//  Created by ZhangXiaofei on 17/2/27.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBStretchTableViewHeader.h"

@interface MBStretchTableViewHeader() {
    // 表头初始Frame
    CGRect _stretchHeaderInitialFrame;
    
    // 表头初始高度
    CGFloat _stretchHeaderInitialHeight;
}

/**
 *  当前TableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  当前TableView表头
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  当前TableView表头子视图Y值
 */
@property (nonatomic, strong) NSMutableArray *subViewInitialOriginYArrM;

/**
 *  当前待移动子视图Y值
 */
@property (nonatomic, strong) NSMutableArray *holderSubViewsInitialOriginYArrM;

/**
 *  当前待移动子视图数组
 */
@property (nonatomic, strong) NSArray<UIView *> *holderSubViews;
@end


@implementation MBStretchTableViewHeader

- (instancetype)initWithTableView:(UITableView *)tableView headerView:(UIView *)headerView holderViews:(NSArray<UIView *> *)holderViews {
    if (self = [super init]) {
        self.headerSubViewMoving = YES;

        self.holderSubViews = holderViews;
        self.tableView = tableView;
        self.headerView = headerView;
        
        _stretchHeaderInitialFrame = self.headerView.frame;
        _stretchHeaderInitialHeight = _stretchHeaderInitialFrame.size.height;
        
        [self setupTableViewHeaderViewSubViews];
        [self configureTableViewHeader];
        
    }
    return self;
}

- (void)configureWithTableView:(UITableView *)tableView headerView:(UIView *)headerView holderViews:(NSArray<UIView *> *)holderViews {
    self.headerSubViewMoving = YES;
    
    self.holderSubViews = holderViews;
    self.tableView = tableView;
    self.headerView = headerView;
    
    _stretchHeaderInitialFrame = self.headerView.frame;
    _stretchHeaderInitialHeight = _stretchHeaderInitialFrame.size.height;
    
    [self setupTableViewHeaderViewSubViews];
    [self configureTableViewHeader];
}

/**
 *  获取当前随表头移动的子视图
 */
- (void)setupTableViewHeaderViewSubViews {
    self.subViewInitialOriginYArrM = [NSMutableArray array];
    self.holderSubViewsInitialOriginYArrM = [NSMutableArray array];
    // 表头的全部子视图
    for (UIView *subView in self.headerView.subviews) {
        [self.subViewInitialOriginYArrM addObject:@(subView.frame.origin.y)];
    }
    
    // 自定义可移动控件
    for (UIView *subView in self.holderSubViews) {
        [self.holderSubViewsInitialOriginYArrM addObject:@(subView.frame.origin.y)];
    }
}

/**
 *  配置TableView表头
 */
- (void)configureTableViewHeader {
    
    self.headerView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView.layer.masksToBounds = YES;

    // 设置当前操作Tableview 的表头
    UIView *emptyTableHeaderView = [[UIView alloc] initWithFrame:_stretchHeaderInitialFrame];
    self.tableView.tableHeaderView = emptyTableHeaderView;
    
    [self.tableView addSubview:self.headerView];
    
    //  监听UITableView的contentOffset变化
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context: nil];
}


/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGRect f = self.headerView.frame;
    f.size.width = self.tableView.frame.size.width;
    self.headerView.frame = f;
    
    if(self.tableView.contentOffset.y < 0) {
        CGFloat offsetY = (self.tableView.contentOffset.y + self.tableView.contentInset.top) * (-1);
        _stretchHeaderInitialFrame.origin.y = offsetY * (-1);
        _stretchHeaderInitialFrame.size.height = _stretchHeaderInitialHeight + offsetY;
        self.headerView.frame = _stretchHeaderInitialFrame;
        if (self.headerSubViewMoving) {
            [self subViewMoving:offsetY];
        }
    }
}

/**
 表头移动时, 子视图的移动方法

 @param offsetY 偏移量
 */
- (void)subViewMoving:(CGFloat)offsetY {
    if (self.holderSubViews && self.holderSubViews) {   // 当前自定义了可移动控件,默认不执行全部控件移动
        for (int i = 0; i < self.holderSubViews.count; i ++) {
            UIView *subView = self.holderSubViews[i];
            CGFloat y = [self.holderSubViewsInitialOriginYArrM[i] integerValue];
            CGRect f = subView.frame;
            f.origin.y = y - offsetY * (-1);
            subView.frame = f;
        }
    } else {    // 没设置可移动控件, 默认全部移动
        for (int i = 0; i < self.headerView.subviews.count; i ++) {
            UIView *subView = self.headerView.subviews[i];
            CGFloat y = [self.subViewInitialOriginYArrM[i] integerValue];
            CGRect f = subView.frame;
            f.origin.y = y - offsetY * (-1);
            subView.frame = f;
        }
    }
        
}

- (void)setHeaderSubViewMoving:(BOOL)headerSubViewMoving {
    _headerSubViewMoving = headerSubViewMoving;
}


@end
