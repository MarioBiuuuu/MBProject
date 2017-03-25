//
//  MBTabBar.h
//  MBTabBarDemo
//
//  Created by ZhangXiaofei on 17/3/8.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTabBar;
/** TabBar 类型 */
typedef NS_ENUM(NSInteger, MBTabBarStyle) {
    MBTabBarStyleNormal = 0,    // 默认类型
    MBTabBarStyleBulge  = 1     // 凸起按钮类型
};

@protocol MBTabBarDelegate <NSObject>

@optional
/** 中间凸起按钮点击回调Delegate */
- (void)mb_tabBar:(MBTabBar *)tabBar bulgeBtnClick:(UIButton *)btn;

@end

@interface MBTabBar : UITabBar

/**
 *  中间视图是否显示在当前视图上(subView), 默认NO
 */
@property (nonatomic, assign) BOOL showInCurrentView;

/**
 *  TabBar 类型
 */
@property (nonatomic, assign) MBTabBarStyle tabBarStyle;

/**
 *  MBTabBarDelegate
 */
@property (nonatomic, weak) id<MBTabBarDelegate> centerBtnDelegate;

/**
 初始化

 @param style MBTabBarStyle
 @param bulgeTitle 凸起Title
 @param bulgeImage 凸起图片
 @return TabBar
 */
+ (instancetype)mb_tabBarWithStyle:(MBTabBarStyle)style bulgeBtnTitle:(NSString *)bulgeTitle bulgeBtnImage:(UIImage *)bulgeImage;

/**
 初始化
 
 @param style MBTabBarStyle
 @param bulgeTitle 凸起Title
 @param bulgeImage 凸起图片
 @return TabBar
 */
- (instancetype)initWithStyle:(MBTabBarStyle)style bulgeBtnTitle:(NSString *)bulgeTitle bulgeBtnImage:(UIImage *)bulgeImage;

@end
