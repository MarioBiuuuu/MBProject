//
//  MBTabBar.m
//  MBTabBarDemo
//
//  Created by ZhangXiaofei on 17/3/8.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBTabBar.h"

/** 间距 */
#define kBMagin 10

@interface MBTabBar () {
    /** 中间凸起按钮文字 */
    NSString *_bulgeTitleStr;
}

/**
 *  中间凸起按钮
 */
@property (nonatomic, strong) UIButton *bulgeBtn;

/**
 *  中间凸起按钮标题
 */
@property (nonatomic, strong) UILabel *bulgeLabel;

@end

@implementation MBTabBar
#pragma mark - initial
+ (instancetype)mb_tabBarWithStyle:(MBTabBarStyle)style bulgeBtnTitle:(NSString *)bulgeTitle bulgeBtnImage:(UIImage *)bulgeImage {
    return [self mb_tabBarWithStyle:style bulgeBtnTitle:bulgeTitle bulgeBtnImage:bulgeImage];
}

- (instancetype)initWithStyle:(MBTabBarStyle)style bulgeBtnTitle:(NSString *)bulgeTitle bulgeBtnImage:(UIImage *)bulgeImage {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setShadowImage:[self imageWithColor:[UIColor clearColor]]];
        _tabBarStyle = style;
        _bulgeTitleStr = bulgeTitle;
        if (style == MBTabBarStyleBulge) {
            self.bulgeBtn = ({
                UIButton *btn = [[UIButton alloc] init];
                [btn setBackgroundImage:bulgeImage forState:UIControlStateNormal];
                [btn setBackgroundImage:bulgeImage forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(bulgeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn;
            });
            
            self.bulgeLabel = ({
                UILabel *bulgeLabel = [[UILabel alloc] init];
                bulgeLabel.text = _bulgeTitleStr;
                bulgeLabel.textAlignment = NSTextAlignmentCenter;
                bulgeLabel.font = [UIFont systemFontOfSize:10];
                bulgeLabel.textColor = [UIColor grayColor];
                [self addSubview:bulgeLabel];
                bulgeLabel;
            });
            
            [self addSubview:self.bulgeBtn];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.tabBarStyle == MBTabBarStyleBulge) {
       
        self.bulgeLabel.frame = CGRectMake(self.center.x - CGRectGetWidth(self.frame) / (self.items.count + 1) * 0.5, CGRectGetHeight(self.frame) - 12, CGRectGetWidth(self.frame) / (self.items.count + 1), 12.f);
                
        //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
        Class class = NSClassFromString(@"UITabBarButton");
        
        self.bulgeBtn.frame = CGRectMake(0, 0, self.bulgeBtn.currentBackgroundImage.size.width, self.bulgeBtn.currentBackgroundImage.size.height);
        self.bulgeBtn.center = CGPointMake(self.center.x, self.frame.size.height * 0.5 - kBMagin - CGRectGetHeight(self.bulgeLabel.frame));
        
        int btnIndex = 0;
        for (UIView *btn in self.subviews) {//遍历tabbar的子控件
            if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
                //每一个按钮的宽度==tabbar的五分之一
                CGRect f = btn.frame;
                f.size.width = self.frame.size.width / (self.items.count + 1);
                f.origin.x = f.size.width * btnIndex;
                btn.frame = f;
                
                btnIndex++;
                //如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
                if (btnIndex == 2) {
                    btnIndex++;
                }
                
            }
        }
        
        [self bringSubviewToFront:self.bulgeBtn];
    }
}

/** 重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    // self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    // 在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    // 是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        
        // 将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.bulgeBtn];
        
        // 判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ([self.bulgeBtn pointInside:newP withEvent:event]) {
            if (self.showInCurrentView) {
                self.bulgeLabel.textColor = [[self.items.firstObject titleTextAttributesForState:UIControlStateSelected] objectForKey:NSForegroundColorAttributeName];
            }
            return self.bulgeBtn;
        } else {    // 如果点不在发布按钮身上，直接让系统处理就可以了
            if (self.showInCurrentView) {
                self.bulgeLabel.textColor = [[self.items.firstObject titleTextAttributesForState:UIControlStateNormal] objectForKey:NSForegroundColorAttributeName];
            }
            return [super hitTest:point withEvent:event];
        }
    } else {    // tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

/** 通过颜色生成图片 */
- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillRect(ctx, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/** 凸起按钮点击事件 */
- (void)bulgeBtnClick:(UIButton *)btn {
    if (self.centerBtnDelegate && [self.centerBtnDelegate respondsToSelector:@selector(mb_tabBar:bulgeBtnClick:)]) {
        [self.centerBtnDelegate mb_tabBar:self bulgeBtnClick:btn];
    }
}

@end
