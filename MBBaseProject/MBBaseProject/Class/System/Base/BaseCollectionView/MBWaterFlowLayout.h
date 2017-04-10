//
//  MBWaterFlowLayout.h
//  MBBaseProject
//
//  Created by ZhangXiaofei on 17/4/10.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBWaterFlowLayout;

@protocol MBWaterFlowLayoutDelegate <NSObject>

//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)waterfallLayout:(MBWaterFlowLayout *)waterfallLayout itemHeightWithItemWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end

@interface MBWaterFlowLayout : UICollectionViewLayout
/**
 *  列数，默认值为3;
 */
@property (nonatomic, assign) NSInteger columnNumber;
/**
 *  列间距
 */
@property (nonatomic, assign) CGFloat columnSpacing;
/**
 *  行间距
 */
@property (nonatomic, assign) CGFloat rowSpacing;
/**
 *  每个section 与 collectionview的间距
 */
@property (nonatomic, assign) UIEdgeInsets sectionEdgeInsets;

@property (nonatomic, weak) id<MBWaterFlowLayoutDelegate> delegate;

@property (nonatomic, strong) CGFloat(^itemHeightBlock)(CGFloat itemWight, NSIndexPath *indexPath);

+ (instancetype)waterFallLayoutWithColumnCount:(NSInteger)columnCount;
- (instancetype)initWithColumnCount:(NSInteger)columnCount;
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;


@end
