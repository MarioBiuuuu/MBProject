//
//  UIButton+CenterImageAndTitle.m
//  Dangdang
//
//  Created by Yuri on 16/4/22.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "UIButton+CenterImageAndTitle.h"

@implementation UIButton (CenterImageAndTitle)

- (void)centerImageAndTitle:(CGFloat)spacing {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

- (void)horizontalImageAndTitle:(CGFloat)space{
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, space);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,space, 0.0,0.0);
}

@end
