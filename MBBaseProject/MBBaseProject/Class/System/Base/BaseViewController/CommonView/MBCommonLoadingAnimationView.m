//
//  MBCommonAnimationView.m
//  DBKit
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBCommonLoadingAnimationView.h"
#import "SplittingTriangle.h"
#import "GrasshopperLoadingView.h"
@interface MBCommonLoadingAnimationView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (strong, nonatomic) SplittingTriangle *st;
@property (nonatomic, strong) GrasshopperLoadingView *grasshopperLoading;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation MBCommonLoadingAnimationView
- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [view addSubview:self];
    //    self.frame = view.bounds;
    self.frame = [UIScreen mainScreen].bounds;
    
    //  帧动画
    self.imageView.frame = CGRectMake(0, 0, 100 * 1.04, 100);
    self.imageView.center = CGPointMake(self.center.x, self.center.y - 40);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView startAnimating];
    
    //  三角动画
    //    [self.st setPaused:NO];
    
    //  蚂蚱
    //    [self setupGrassHopperLoading];
    self.tipLabel.text = @"努力打开中...";
    
}

- (void)dismiss {
    [_imageArray removeAllObjects];
    [_imageView stopAnimating];
    [_imageView removeFromSuperview];
    
    [_grasshopperLoading removeFromSuperview];
    [_tipLabel removeFromSuperview];
    [self removeFromSuperview];
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _imageView = img;
        
        for (NSInteger i = 1; i < 7; i++) {
            NSString *name = [NSString stringWithFormat:@"refreshjoke_loading_%@", @(i)];
            UIImage *image = [UIImage imageNamed:name];
            [self.imageArray addObject:image];
        }
        self.imageView.animationDuration = 0.5;
        self.imageView.animationRepeatCount = 0;
        self.imageView.animationImages = self.imageArray;
    }
    return _imageView;
}

- (void)setupGrassHopperLoading {
    if (!self.grasshopperLoading) {
        self.grasshopperLoading = [[GrasshopperLoadingView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        [self.grasshopperLoading setCenter:CGPointMake(self.center.x, self.center.y - 70)];
        
        [self addSubview:self.grasshopperLoading];
    }
    
}

//- (SplittingTriangle *)st {
//    if (!_st) {
//        _st = [[SplittingTriangle alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//
//        [_st setForeColor:[UIColor colorWithRed:241.0 / 255.0 green:104.0 / 255.0 blue:108.0 / 255.0 alpha:1.0]
//                 andBackColor:[UIColor clearColor]];
//
//        [_st setDuration:0.8];
//        [_st setRadius:22];
//        [_st setCenter:CGPointMake(self.center.x, self.center.y - 30)];
//
//        [self addSubview:_st];
//    }
//
//    return _st;
//}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        if (self.grasshopperLoading) {
            _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.grasshopperLoading.frame) + 30, [UIScreen mainScreen].bounds.size.width, 25);
            
        } else if (self.st) {
            _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.st.frame) + 10, [UIScreen mainScreen].bounds.size.width, 25);
            
        } else {
            _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 10, [UIScreen mainScreen].bounds.size.width, 25);
        }
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:15.f];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
