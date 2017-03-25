//
//  MBBaseTableView.m
//  MBBaseController
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBBaseTableView.h"
#import "UIScrollView+EmptyDataSet.h"

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface MBBaseTableView ()  <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation MBBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tableFooterView = [UIView new];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)MB_registerCellClass:(Class)cellClass identifier:(NSString *)identifier {
    if (cellClass && identifier.length) {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}

- (void)MB_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier {
    if (cellNib && nibIdentifier.length) {
        UINib *nib = [UINib nibWithNibName:[cellNib description] bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:nibIdentifier];
    }
}

- (void)MB_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier {
    if (headerFooterClass && identifier.length) {
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:identifier];
    }
}

- (void)MB_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier {
    if (headerFooterNib && nibIdentifier.length) {
        UINib *nib = [UINib nibWithNibName:[headerFooterNib description] bundle:nil];
        [self registerNib:nib forHeaderFooterViewReuseIdentifier:nibIdentifier];
    };
}

- (void)MB_updateWithUpdateBlock:(void (^)(MBBaseTableView *tableView))updateBlock {
    if (updateBlock) {
        [self beginUpdates];
        updateBlock(self);
        [self endUpdates];
    }
}

- (UITableViewCell *)MB_cellAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) return nil;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        return nil;
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        return nil;
    }
    return [self cellForRowAtIndexPath:indexPath];
}

- (void)MB_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self MB_reloadSingleRowAtIndexPath:indexPath animation:None];
}

- (void)MB_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(MBBaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
    } else {
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

- (void)MB_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self MB_reloadRowsAtIndexPaths:indexPaths animation:None];
}

- (void)MB_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(MBBaseTableViewRowAnimation)animation {
    if (!indexPaths.count) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf MB_reloadSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

- (void)MB_reloadSingleSection:(NSInteger)section {
    [self MB_reloadSingleSection:section animation:None];
}

- (void)MB_reloadSingleSection:(NSInteger)section animation:(MBBaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) { // section越界
        NSLog(@"刷新section: %ld 已经越界, 总组数: %ld", (long)section, (long)sectionNumber);
    } else {
        [self beginUpdates];
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

- (void)MB_reloadSections:(NSArray <NSNumber *>*)sections {
    [self MB_reloadSections:sections animation:None];
}

- (void)MB_reloadSections:(NSArray<NSNumber *> *)sections animation:(MBBaseTableViewRowAnimation)animation {
    if (!sections.count) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf MB_reloadSingleSection:obj.integerValue animation:animation];
        }
    }];
}

- (void)MB_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self MB_deleteSingleRowAtIndexPath:indexPath animation:Fade];
}

- (void)MB_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(MBBaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    
    NSLog(@"sectionNumber %ld  section%ld rowNumber%ld",(long)sectionNumber, (long)section , rowNumber);
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"删除section: %ld 已经越界, 总组数: %ld", (long)indexPath.section, (long)sectionNumber);
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"删除row: %ld 已经越界, 总行数: %ld 所在section: %ld", (long)indexPath.row, (long)rowNumber, section);
    } else {
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

- (void)MB_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self MB_deleteRowsAtIndexPaths:indexPaths animation:Fade];
}

- (void)MB_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(MBBaseTableViewRowAnimation)animation {
    if (!indexPaths.count) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf MB_deleteSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

- (void)MB_deleteSingleSection:(NSInteger)section {
    
    [self MB_deleteSingleSection:section animation:Fade];
}

- (void)MB_deleteSingleSection:(NSInteger)section animation:(MBBaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) { // section 越界
        NSLog(@"刷新section: %ld 已经越界, 总组数: %ld", (long)section, (long)sectionNumber);
    } else {
        [self beginUpdates];
        [self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

- (void)MB_deleteSections:(NSArray *)sections {
    [self MB_deleteSections:sections animation:Fade];
}

- (void)MB_deleteSections:(NSArray<NSNumber *> *)sections animation:(MBBaseTableViewRowAnimation)animation {
    if (!sections.count) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf MB_deleteSingleSection:obj.integerValue animation:animation];
        }
    }];
}

- (void)MB_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self MB_insertSingleRowAtIndexPath:indexPath animation:None];
}

- (void)MB_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(MBBaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (section > sectionNumber || section < 0) {
        // section 越界
        NSLog(@"section 越界 : %ld", (long)section);
    } else if (row > rowNumber || row < 0) {
        NSLog(@"row 越界 : %ld", (long)row);
    } else {
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
    
}

- (void)MB_insertSingleSection:(NSInteger)section {
    [self MB_insertSingleSection:section animation:None];
}

- (void)MB_insertSingleSection:(NSInteger)section animation:(MBBaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) {
        // section越界
        NSLog(@" section 越界 : %ld", (long)section);
    } else {
        [self beginUpdates];
        [self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

- (void)MB_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self MB_insertRowsAtIndexPaths:indexPaths animation:None];
}

- (void)MB_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(MBBaseTableViewRowAnimation)animation {
    if (indexPaths.count == 0) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf MB_insertSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

- (void)MB_insertSections:(NSArray <NSNumber *>*)sections {
    [self MB_insertSections:sections animation:None];
}

- (void)MB_insertSections:(NSArray <NSNumber *>*)sections animation:(MBBaseTableViewRowAnimation)animation {
    if (sections.count == 0) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf MB_insertSingleSection:obj.integerValue animation:animation];
        }
    }];
}

/**
 *  当有输入框的时候 点击tableview空白处，隐藏键盘
 *
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id view = [super hitTest:point withEvent:event];
    if (![view isKindOfClass:[UITextField class]]) {
        [self endEditing:YES];
    }
    return view;
}

#pragma mark - DZNEmptyDataSet datasource && delegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    UIImage *emptyImage;
    switch (self.emptyImageType) {
        case MBBaseTableViewEmptyImageTypeNoNetwork:
            emptyImage = [UIImage imageNamed:@"empty_noNetwork"];
            break;
        case MBBaseTableViewEmptyImageTypeSendRedEnvelopeStatus:
            emptyImage = [UIImage imageNamed:@"empty_sendEnvelopeStatus"];
            break;
        case MBBaseTableViewEmptyImageTypeRedEnvelopeManagementCenter:
            emptyImage = [UIImage imageNamed:@"empty_managementCenter"];
            break;
        case MBBaseTableViewEmptyImageTypeVoucherAndKind:
            emptyImage = [UIImage imageNamed:@"empty_voucherAndKind"];
            break;
        case MBBaseTableViewEmptyOnlyString:
            emptyImage = nil;
            break;
        default:
            break;
    }
    
    return self.emptyImage ? self.emptyImage : emptyImage;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    if (self.emptyTipString && self.emptyTipString.length > 0) {
        text = self.emptyTipString;
    } else {
        text = @"";
    }
    UIFont *font = self.emptyTipStringFont ? self.emptyTipStringFont : [UIFont systemFontOfSize:14.f];
    UIColor *color = self.emptyTipStringColor ? self.emptyTipStringColor : [UIColor blackColor];
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : color}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (self.emptySubTipString && self.emptySubTipString.length > 0) {
        NSMutableAttributedString *attributedString;
        NSString *text = self.emptySubTipString;
        attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
        UIFont *font = self.emptySubTipStringFont ? self.emptySubTipStringFont : [UIFont systemFontOfSize:13.f];
        UIColor *color = self.emptySubTipStringColor ? self.emptySubTipStringColor : [UIColor grayColor];
        [attributedString addAttribute:NSFontAttributeName value:font range:[attributedString.string rangeOfString:text]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[attributedString.string rangeOfString:text]];
        return attributedString;
        
    } else {
        return nil;
    }
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.emptyBackgroundColor ? self.emptyBackgroundColor : [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.verticalSpace != 0) {
        return self.verticalSpace;
    }
    return -10.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.imageSpace != 0) {
        return self.imageSpace;
    }
    return 5.f;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return self.emptyViewScrollEnable;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"%s",__FUNCTION__);
    if (self.tapViewBlock) {
        self.tapViewBlock(scrollView, view);
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    NSLog(@"%s",__FUNCTION__);
}

- (void)emptyTableViewTapHandler:(TapViewHandler)handler {
    self.tapViewBlock = handler;
}

- (void)setIsShowEmptyView:(BOOL)isShowEmptyView {
    _isShowEmptyView = isShowEmptyView;
    if (isShowEmptyView) {
        self.emptyDataSetDelegate = self;
        self.emptyDataSetSource = self;
    }
}

- (void)setVerticalSpace:(CGFloat)verticalSpace {
    _verticalSpace = verticalSpace;
    [self reloadEmptyDataSet];
}

- (void)setImageSpace:(CGFloat)imageSpace {
    _imageSpace = imageSpace;
    [self reloadEmptyDataSet];
}

- (void)setEmptyTipString:(NSString *)emptyTipString {
    _emptyTipString = emptyTipString;
    [self reloadEmptyDataSet];
}

- (void)setEmptyTipStringFont:(UIFont *)emptyTipStringFont {
    _emptyTipStringFont = emptyTipStringFont;
    [self reloadEmptyDataSet];
}

- (void)setEmptyTipStringColor:(UIColor *)emptyTipStringColor {
    _emptyTipStringColor = emptyTipStringColor;
    [self reloadEmptyDataSet];
}

- (void)setEmptySubTipString:(NSString *)emptySubTipString {
    _emptySubTipString = emptySubTipString;
    [self reloadEmptyDataSet];
}

- (void)setEmptySubTipStringFont:(UIFont *)emptySubTipStringFont {
    _emptySubTipStringFont = emptySubTipStringFont;
    [self reloadEmptyDataSet];
}

- (void)setEmptySubTipStringColor:(UIColor *)emptySubTipStringColor {
    _emptySubTipStringColor = emptySubTipStringColor;
    [self reloadEmptyDataSet];
}

- (void)setEmptyViewScrollEnable:(BOOL)emptyViewScrollEnable {
    _emptyViewScrollEnable = emptyViewScrollEnable;
    [self reloadEmptyDataSet];
}
@end
