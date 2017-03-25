//
//  UIButton+SwipMenuItem.m
//  SwipCellDemo
//
//  Created by ZhangXiaofei on 17/3/20.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "UIButton+SwipMenuItem.h"
#import "MBSwipCellMenuItem.h"

@interface UIButton (CenterImageAndTitle)

- (void)centerImageAndTitle:(CGFloat)spacing;
- (void)centerImageAndTitle;
- (void)horizontalImageAndTitle:(CGFloat)space;

@end

@implementation UIButton (CenterImageAndTitle)

- (void)centerImageAndTitle:(CGFloat)spacing {
//    CGSize imageSize = self.imageView.image.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    
//    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
//    
//    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
//    
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.image.size.height + 10, -self.imageView.image.size.width + 5, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [self setImageEdgeInsets:UIEdgeInsetsMake(-spacing - 10, 0.0, 0.0, -self.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)centerImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

- (void)horizontalImageAndTitle:(CGFloat)space {
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, space);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,space, 0.0,0.0);
}

@end

@implementation UIButton (SwipMenuItem)

+ (instancetype)buttonWithItem:(MBSwipCellMenuItem *)item {
    return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(MBSwipCellMenuItem *)item {
    if (self = [super init]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self initialUIWithItem:item];
    }
    return self;
}

- (void)initialUIWithItem:(MBSwipCellMenuItem *)item {
    if (item.itemBackgroundColor) {
        [self setBackgroundColor:item.itemBackgroundColor];
    }
    
    if (item.titleColor) {
        [self setTitleColor:item.titleColor forState:UIControlStateNormal];
        [self setTitleColor:item.titleColor forState:UIControlStateSelected];
    }
    
    if (item.titleFont) {
        self.titleLabel.font = item.titleFont;
    }
    
    [self setTitleAndImage:item];
    
}

- (void)setTitleAndImage:(MBSwipCellMenuItem *)item {
    switch (item.style) {
        case MBSwipCellItemStyleOnlyTitle:
        {
            NSAssert(item.itemTitle, @"You must set the item title while item.style == MBSwipCellItemStyleOnlyTitle. (当你选择MBSwipCellItemStyleOnlyTitle时, 必须设置一个itemTitle)");
            
            if (item.itemTitle) {
                [self setTitle:item.itemTitle forState:UIControlStateSelected];
                [self setTitle:item.itemTitle forState:UIControlStateNormal];
            }
        }
            break;
        case MBSwipCellItemStyleOnlyImage:
        {
            NSAssert(item.normalImage && item.selectedImage, @"You must set the item normalImage and selectedImage while item.style == MBSwipCellItemStyleOnlyImage. (当你选择MBSwipCellItemStyleOnlyImage时, 必须设置一个item的选中和默认状态下的图片)");
            if (item.normalImage && item.selectedImage) {
                [self setImage:item.normalImage forState:UIControlStateNormal];
                [self setImage:item.selectedImage forState:UIControlStateSelected];
            }
        }
            break;
            
        case MBSwipCellItemStyleCenter:
        {
            NSAssert(item.itemTitle, @"You must set the item title while item.style == MBSwipCellItemStyleNormal. (当你选择MBSwipCellItemStyleNormal时, 必须设置一个itemTitle)");
            NSAssert(item.normalImage && item.selectedImage, @"You must set the item normalImage and selectedImage while item.style == MBSwipCellItemStyleNormal. (当你选择MBSwipCellItemStyleNormal时, 必须设置一个item的选中和默认状态下的图片)");
            if (item.itemTitle && item.normalImage && item.selectedImage) {
                [self setTitle:item.itemTitle forState:UIControlStateSelected];
                [self setTitle:item.itemTitle forState:UIControlStateNormal];
                [self setImage:item.normalImage forState:UIControlStateNormal];
                [self setImage:item.selectedImage forState:UIControlStateSelected];
                [self centerImageAndTitle:0];
            }
        }
            break;
            
        case MBSwipCellItemStyleNormal:
        {
            NSAssert(item.itemTitle, @"You must set the item title while item.style == MBSwipCellItemStyleNormal. (当你选择MBSwipCellItemStyleNormal时, 必须设置一个itemTitle)");
            NSAssert(item.normalImage && item.selectedImage, @"You must set the item normalImage and selectedImage while item.style == MBSwipCellItemStyleNormal. (当你选择MBSwipCellItemStyleNormal时, 必须设置一个item的选中和默认状态下的图片)");
            if (item.itemTitle && item.normalImage && item.selectedImage) {
                [self setTitle:item.itemTitle forState:UIControlStateSelected];
                [self setTitle:item.itemTitle forState:UIControlStateNormal];
                [self setImage:item.normalImage forState:UIControlStateNormal];
                [self setImage:item.selectedImage forState:UIControlStateSelected];
            }
        }
            break;
            
            
        default:
            break;
    }
}
@end
