//
//  BaseViewController.h
//  Dangdang
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BackButtonHandler.h"
#import "UINavigationController_ShouldPopOnBackButton.h"
#import "MBBaseConfigure.h"

typedef void(^MBBaseViewControllerHandle)();

@interface MBBaseViewController : UIViewController
#pragma mark - property
/** 基类基础属性设置 */
@property (nonatomic, strong) MBBaseConfigure *baseConfigure;

/**
 *  设置无网络占位图
 */
@property (nonatomic, assign) BOOL isNetworkReachable;

/**
 *  隐藏导航栏底部线条阴影开关
 */
@property (nonatomic, assign) BOOL hiddenNavigationBarShadowImageView;


/**
 *  导航右边Item
 */
//@property (nonatomic, strong) UIBarButtonItem *navRightItem;
@property (nonatomic, strong) UIBarButtonItem *navRightItem;
/**
 *  导航左边Item
 */
//@property (nonatomic, strong) UIBarButtonItem *navLeftItem;
@property (nonatomic, strong) UIBarButtonItem *navLeftItem;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *navItemTitle;

/**
 *  自动隐藏导航栏, 实现过度效果
 */
@property (nonatomic, assign) BOOL autoHiddenNavigationBar;

#pragma mark - function
/**
 *  防止Cell多次点击造成多次跳转
 */
- (void)singlePush;

/**
 *  构造返回
 */
- (void)createBackBarButton;

/**
 *  出栈
 */
- (void)pop;

/**
 *  退回到Top
 */
- (void)popToRootVc;

/**
 退回到指定VC

 @param vc 指定控制器
 */
- (void)popToVc:(UIViewController *)vc;

/**
 *  Modal出的视图dismiss
 */
- (void)dismiss;

/**
 带回调的dismiss

 @param completion 回调
 */
- (void)dismissWithCompletion:(void(^)())completion;

/**
 modal出某个视图控制器

 @param vc 指定视图控制器
 */
- (void)presentVc:(UIViewController *)vc;

/**
 modal出某个视图控制器, 带回调

 @param vc 指定视图控制器
 @param completion 回调
 */
- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;

/**
 push到某指定视图控制器

 @param vc 指定视图控制器
 */
- (void)pushVc:(UIViewController *)vc;

/**
 移除子视图控制器

 @param childVc 指定视图控制器
 */
- (void)removeChildVc:(UIViewController *)childVc;

/**
 添加子视图控制器

 @param childVc 指定视图控制器
 */
- (void)addChildVc:(UIViewController *)childVc;

/**
 *  设置导航栏右边的item
 *
 *  @param itemTitle  <#itemTitle description#>
 *  @param attributes <#itemTitle description#>
 *  @param handle     <#handle description#>
 */
- (void)MB_setUpNavRightItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *rightItemTitle))handle;

/**
 *  设置导航栏左边的item
 *
 *  @param itemTitle  <#itemTitle description#>
 *  @param attributes <#itemTitle description#>
 *  @param handle     <#handle description#>
 */
- (void)MB_setUpNavLeftItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *rightItemTitle))handle;

/**
 *  设置导航栏右边的item
 *
 *  @param itemTitle <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)MB_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle __deprecated_msg("Use -MB_setUpNavRightItemTitle:attributes:handle:");

/**
 *  设置导航栏左边的item
 *
 *  @param itemTitle <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)MB_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle __deprecated_msg("Use -MB_setUpNavLeftItemTitle:attributes:handle:");

/**
 *  设置导航栏右边的item
 *
 *  @param itemTitle <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)MB_setUpNavRightItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *rightItemImage))handle;

/**
 *  设置导航栏左边的item
 *
 *  @param itemTitle <#itemTitle description#>
 *  @param handle    <#handle description#>
 */
- (void)MB_setUpNavLeftItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *leftItemImage))handle;

/**
 *  加载中
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)hideLoadingAnimation;

/**
 *  请求数据，子类实现
 */
- (void)loadData;

@end
