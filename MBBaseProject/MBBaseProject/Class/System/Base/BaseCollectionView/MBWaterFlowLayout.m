//
//  MBWaterFlowLayout.m
//  MBBaseProject
//
//  Created by ZhangXiaofei on 17/4/10.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBWaterFlowLayout.h"

@interface MBWaterFlowLayout ()
//用来记录每一列的最大y值
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
//保存每一个item的attributes
@property (nonatomic, strong) NSMutableArray *attributesArray;
@end

@implementation MBWaterFlowLayout

- (NSMutableDictionary *)maxYDict {
    if (!_maxYDict) {
        _maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.columnNumber = 3;
    }
    return self;
}

- (instancetype)initWithColumnCount:(NSInteger)columnCount {
    if (self = [super init]) {
        self.columnNumber = columnCount;
    }
    return self;
}

+ (instancetype)waterFallLayoutWithColumnCount:(NSInteger)columnCount {
    return [[self alloc] initWithColumnCount:columnCount];
}

- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset {
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSepacing;
    self.sectionEdgeInsets = sectionInset;
}

- (void)prepareLayout {
    for (int i = 0; i < self.columnNumber; i++) {
        self.maxYDict[@(i)] = @(self.sectionEdgeInsets.top);
    }
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    
    __block NSNumber *maxIndex = @0;
    
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([self.maxYDict[maxIndex] floatValue] < [obj floatValue]) {
            maxIndex = key;
        }
    }];
    
    return CGSizeMake(0, [self.maxYDict[maxIndex] floatValue] + self.sectionEdgeInsets.bottom);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat itemWidth = (collectionViewWidth - self.sectionEdgeInsets.left - self.sectionEdgeInsets.right - (self.columnNumber - 1) * self.columnSpacing) / self.columnNumber;
    
    CGFloat itemHeight = 0.0;
    
    if ([self.delegate respondsToSelector:@selector(waterfallLayout:itemHeightWithItemWidth:atIndexPath:)]) {
        itemHeight = [self.delegate waterfallLayout:self itemHeightWithItemWidth:itemWidth atIndexPath:indexPath];
    } else if (self.itemHeightBlock) {
        itemHeight = self.itemHeightBlock(itemWidth, indexPath);
    }
    //找最短
    __block NSNumber *minIndex = @0;
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([self.maxYDict[minIndex] floatValue] > [obj floatValue]) {
            minIndex = key;
        }
    }];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionEdgeInsets.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDict[minIndex] floatValue] + self.rowSpacing;
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.maxYDict[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
    
}

//返回rect范围内item的attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

@end
