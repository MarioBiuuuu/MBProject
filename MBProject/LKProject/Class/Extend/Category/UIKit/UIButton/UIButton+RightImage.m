//
//  UIButton+RightImage.m
//  Dangdang
//
//  Created by Yuri on 16/6/30.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "UIButton+RightImage.h"
#define kPADDING 5
@implementation UIButton (RightImage)

- (void)letImageToRight {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width + kPADDING)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width - kPADDING)];
    [self layoutIfNeeded];
}

@end
