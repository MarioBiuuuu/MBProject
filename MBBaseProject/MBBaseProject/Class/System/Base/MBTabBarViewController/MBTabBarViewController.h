//
//  MBTabBarViewController.h
//  LKBaseTabbarController
//
//  Created by ZhangXiaofei on 17/3/16.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
/** TabBar样式 */
typedef NS_ENUM(NSUInteger, MBTabbarViewControllerStyle) {
    MBTabbarViewControllerStyleNormal = 0,  // 默认为正常形式
    MBTabbarViewControllerStyleBulge  = 1   // 中间凸起TabBar
};

/** 点击凸起按钮出发视图切换类型 */
typedef NS_ENUM(NSUInteger, MBTabbarViewControllerBuldgeControl) {
    MBTabbarViewControllerBuldgeControlModally  = 0,    // 跳转/触发功能
    MBTabbarViewControllerBuldgeControlChild    = 1,    // 当前页面变更(subView)
};

@class MBTabBarViewController;

@protocol MBtabBarViewControllerDelegate <NSObject>

@optional
/**
 *  中间凸起按钮点击回调Delegate
 */
- (void)mb_tabBarViewController:(MBTabBarViewController *)tabBarViewController centerButtonClick:(UIButton *)centerBtn;

@end

/**
 *  中间凸起按钮点击回调Block
 */
typedef void(^CenterButtonHandler)(MBTabBarViewController *tabBarViewController, UIButton *centerBtn);

@interface MBTabBarViewController : UITabBarController

/**
 *  凸起按钮点击Delegate
 */
@property (nonatomic, weak) id<MBtabBarViewControllerDelegate> centerButtonDelegate;

/**
 *  TabBarItem点击状态颜色
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor;

/**
 *  TabBarItem点击状态图片
 */
@property (nonatomic, strong) UIImage *selectionIndicatorImage;

/**
 *  TabBar背景色
 */
@property (nonatomic, strong) UIColor *tabBarBackgroundColor;

/**
 *  TabBarItem未点击状态Title颜色
 */
@property (nonatomic, strong) UIColor *tabBarNormalTitleColor;

/**
 *  TabBarItem点击状态Title颜色
 */
@property (nonatomic, strong) UIColor *tabBarSelectedTitleColor;

/**
 *  点击凸起按钮出发视图切换类型
 */
@property (nonatomic, assign) MBTabbarViewControllerBuldgeControl tabbarViewControllerBuldgeControl;

/**
 *  点击凸起按钮添加的视图控制器
 */
@property (nonatomic, strong) UIViewController *centerViewController;

/**
 初始化

 @param style 枚举对象MBTabbarViewControllerBuldgeControlModally 跳转/出发功能, MBTabbarViewControllerBuldgeControlChild 当前页面变更(subView)
 @param bulgeTitle 凸起按钮标题
 @param bulgeImage 凸起按钮图片
 @return TaBarController
 */
- (instancetype)initWithTabBarStyle:(MBTabbarViewControllerStyle)style bulgeBtnTitle:(NSString *)bulgeTitle bulgeBtnImage:(UIImage *)bulgeImage;

/**
 单个添加TabBarController  childViewController

 @param childVc 子视图控制器
 @param title 标题
 @param image 图片
 @param selectedImage 选中图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

/**
 多个添加TabBarController  childViewController
 
 @param childVcs 子视图控制器数组
 @param titles 标题数组
 @param images 图片数组
 @param selectedImages 选中图片数组
 */
- (void)addChildVcs:(NSArray <UIViewController *>*)childVcs titles:(NSArray <NSString *>*)titles images:(NSArray <UIImage *>*)images selectedImages:(NSArray <UIImage *>*)selectedImages;

/**
 中间凸起按钮点击回调

 @param handler 回调Block
 */
- (void)centerButtonClick:(CenterButtonHandler)handler;
@end
