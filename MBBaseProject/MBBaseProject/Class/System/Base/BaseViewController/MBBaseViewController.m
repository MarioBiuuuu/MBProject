//
//  BaseViewController.m
//  
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBBaseViewController.h"
#import "NSNotificationCenter+Addition.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MBCommonLoadingAnimationView.h"
#import "MBCommonNoNetworkingView.h"
#import <objc/runtime.h>

/** 当前纬度*/
NSString *const kUserCurrentLatitude = @"kUserCurrentLatitude";
/** 当前经度*/
NSString *const kUserCurrentLongitude = @"kUserCurrentLongitude";
/** 网络请求成功*/
NSString *const kRequestSuccessNotification = @"kRequestSuccessNotification";

const char MBBaseTableVcNavRightItemHandleKey;
const char MBBaseTableVcNavLeftItemHandleKey;

static NSNumber *s_appearanceBarTranslucent;

typedef NS_ENUM(NSInteger, HHViewAction) {
    HHViewAppear,
    HHViewDisappear
};

@interface MBBaseViewController ()
{
    UIImageView *_navShadowImageView;
}

@property (nonatomic, strong) UINavigationBar *bar;

@property (nonatomic, weak) MBCommonNoNetworkingView *noNetworkEmptyView;
@property (nonatomic, weak) MBCommonLoadingAnimationView *animationView;

@end

@implementation MBBaseViewController

@synthesize navItemTitle = _navItemTitle;
@synthesize navRightItem = _navRightItem;
@synthesize navLeftItem = _navLeftItem;

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.autoHiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    [UIView setAnimationsEnabled:YES];
    
    if (self.hiddenNavigationBarShadowImageView) {
        _navShadowImageView.hidden = YES;
    }

//    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
//    //当是侧滑手势的时候设置scrollview需要此手势失效才生效即可
//    for (UIGestureRecognizer *gesture in gestureArray) {
//        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//            
//            for (UIView *sub in self.view.subviews) {
//                if ([sub isKindOfClass:[UIScrollView class]]) {
//                    UIScrollView *sc = (UIScrollView *)sub;
//                    [sc.panGestureRecognizer requireGestureRecognizerToFail:gesture];
//                }
//            }
//        }
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.autoHiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _navShadowImageView.hidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadData];
    
    [UIView setAnimationsEnabled:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tabBarController.tabBar.translucent = NO;
    
    _navShadowImageView = [self findShadowImageViewUnder:self.navigationController.navigationBar];
    
    [NSNotificationCenter addObserver:self action:@selector(requestSuccessNotification) name:kRequestSuccessNotification];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName :[UIColor blackColor]}];

    self.view.backgroundColor = [UIColor whiteColor];

    [[UINavigationBar appearance] setBarTintColor: [UIColor whiteColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setBaseConfigure:(MBBaseConfigure *)baseConfigure {
    if (!baseConfigure) {
        return;
    }
    _baseConfigure = baseConfigure;
    
    self.navigationController.navigationBar.barTintColor = baseConfigure.navigationBar_barTintColor;
    
    self.navigationController.navigationBar.tintColor = baseConfigure.navigationBar_tintColor;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:baseConfigure.navigationBar_backTitle style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationController.navigationBar.barStyle = baseConfigure.navigationBar_barStyle;
    [self.navigationController.navigationBar setTitleTextAttributes:baseConfigure.navigationBar_titleAttributes];
    
    self.view.backgroundColor = baseConfigure.viewBackgroundColor;
    
    self.hiddenNavigationBarShadowImageView = baseConfigure.hiddeNavShadowImageView;
    
    [[UINavigationBar appearance] setBarTintColor: baseConfigure.navigationBar_barTintColor];
    
    [UIApplication sharedApplication].statusBarStyle = baseConfigure.statusBarStyle;

}

- (void)singlePush {
    if (self.navigationController) {
        if (![self.navigationController.topViewController isEqual:self]) {
            return;
        }
    }
}

- (void)requestSuccessNotification {
    [self hideLoadingAnimation];
}

- (void)createBackBarButton {
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [backBtn addTarget:self action:@selector(popGotBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)popGotBack {
    if (self.navigationController == nil) return ;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pop {
    if (self.navigationController == nil) return ;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootVc {
    if (self.navigationController == nil) return ;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popToVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissWithCompletion:(void(^)())completion {
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)presentVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentVc:vc completion:nil];
}

- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentViewController:vc animated:YES completion:completion];
}

- (void)pushVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    if (self.navigationController == nil) return ;
    if (vc.hidesBottomBarWhenPushed == NO) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removeChildVc:(UIViewController *)childVc {
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc.view removeFromSuperview];
    [childVc willMoveToParentViewController:nil];
    [childVc removeFromParentViewController];
}

- (void)addChildVc:(UIViewController *)childVc {
    if ([childVc isKindOfClass:[UIViewController class]] == NO) {
        return ;
    }
    [childVc willMoveToParentViewController:self];
    [self addChildViewController:childVc];
    [self.view addSubview:childVc.view];
    childVc.view.frame = self.view.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)navigationShouldPopOnBackButton {
    return YES;//返回NO 不会执行
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)showLoadingAnimation {
    MBCommonLoadingAnimationView *animation = [[MBCommonLoadingAnimationView alloc] init];
    [animation showInView:self.view];
    _animationView = animation;
    [self.view bringSubviewToFront:animation];
}

- (void)hideLoadingAnimation {
    [_animationView dismiss];
    _animationView = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.animationView];
}

- (void)setIsNetworkReachable:(BOOL)isNetworkReachable {
    _isNetworkReachable = isNetworkReachable;
    [self noNetworkEmptyView];
}

- (MBCommonNoNetworkingView *)noNetworkEmptyView {
    if (!_noNetworkEmptyView) {
        MBCommonNoNetworkingView *empty = [[MBCommonNoNetworkingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [self.view addSubview:empty];
        _noNetworkEmptyView = empty;
        
        __weak typeof(self)weakSelf = self;
        
        empty.customNoNetworkEmptyViewDidClickRetryHandle = ^(MBCommonNoNetworkingView *emptyView) {
            [weakSelf loadData];
            
        };
    }
    return _noNetworkEmptyView;
}

- (void)loadData {
    
}

/** 设置导航栏右边的item*/
- (void)MB_setUpNavRightItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *rightItemTitle))handle {
    if (attributes) {
        [self MB_setUpNavItemTitle:itemTitle attributes:attributes handle:handle leftFlag:NO];
    } else {
        [self MB_setUpNavItemTitle:itemTitle handle:handle leftFlag:NO];
        
    }
}

/** 设置导航栏左边的item*/
- (void)MB_setUpNavLeftItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *leftItemTitle))handle {
    if (attributes) {
        [self MB_setUpNavItemTitle:itemTitle attributes:attributes handle:handle leftFlag:YES];
        
    } else {
        [self MB_setUpNavItemTitle:itemTitle handle:handle leftFlag:YES];
        
    }
}

- (void)MB_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self MB_setUpNavRightItemTitle:itemTitle attributes:nil handle:handle];
}

- (void)MB_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self MB_setUpNavLeftItemTitle:itemTitle attributes:nil handle:handle];
}

/** 设置导航栏右边的item*/
- (void)MB_setUpNavRightItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *rightItemImage))handle {
    [self MB_setUpNavItemImage:itemImage handle:handle leftFlag:NO];
}


/** 设置导航栏左边的item*/
- (void)MB_setUpNavLeftItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *leftItemImage))handle {
    [self MB_setUpNavItemImage:itemImage handle:handle leftFlag:YES];
}

- (void)MB_navItemHandle:(UIBarButtonItem *)item {
    
    void (^handle)(NSString *);
    if ([item isEqual:self.navLeftItem]) {
        handle = objc_getAssociatedObject(self, &MBBaseTableVcNavLeftItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &MBBaseTableVcNavRightItemHandleKey);
    }
    
    if (handle) {
        handle(item.title);
    }
}

- (void)MB_navItemHandleImage:(UIBarButtonItem *)item {
    
    void (^handle)(UIImage *);
    if ([item isEqual:self.navRightItem]) {
        handle = objc_getAssociatedObject(self, &MBBaseTableVcNavRightItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &MBBaseTableVcNavLeftItemHandleKey);
    }
    
    if (handle) {
        handle(item.image);
    }
}
- (void)MB_navItemBtnHandle:(UIButton *)item {
    
    void (^handle)(NSString *);
    if (item.tag == 0) {
        handle = objc_getAssociatedObject(self, &MBBaseTableVcNavLeftItemHandleKey);
    } else {
        handle = objc_getAssociatedObject(self, &MBBaseTableVcNavRightItemHandleKey);
    }
    
    if (handle) {
        handle(item.titleLabel.text);
    }
}


- (void)MB_setUpNavItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *itemTitle))handle leftFlag:(BOOL)leftFlag {
    if (itemTitle.length == 0 || !handle) {
        if (itemTitle == nil) {
            itemTitle = @"";
        } else if ([itemTitle isKindOfClass:[NSNull class]]) {
            itemTitle = @"";
        }
        if (leftFlag) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
        }
        
    } else {
        if (leftFlag) {
            objc_setAssociatedObject(self, &MBBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(MB_navItemHandle:)];
        } else {
            objc_setAssociatedObject(self, &MBBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(MB_navItemHandle:)];
        }
    }
    
}

- (void)MB_setUpNavItemTitle:(NSString *)itemTitle attributes:(NSDictionary *)attributes handle:(void(^)(NSString *itemTitle))handle leftFlag:(BOOL)leftFlag {
    if (itemTitle.length == 0 || !handle) {
        if (itemTitle == nil) {
            itemTitle = @"";
        } else if ([itemTitle isKindOfClass:[NSNull class]]) {
            itemTitle = @"";
        }
        if (leftFlag) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        } else {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
        
    } else {
        if (leftFlag) {
            objc_setAssociatedObject(self, &MBBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            btn.tag = 0;
            [btn addTarget:self action:@selector(MB_navItemBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            
        } else {
            objc_setAssociatedObject(self, &MBBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:itemTitle attributes:attributes];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            [btn sizeToFit];
            btn.tag = 1;
            [btn addTarget:self action:@selector(MB_navItemBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
    }
    
}

- (void)MB_setUpNavItemImage:(UIImage *)itemImage handle:(void(^)(UIImage *itemImage))handle leftFlag:(BOOL)leftFlag {
    if (itemImage && !handle) {
        
        if (leftFlag) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:nil action:nil];        } else {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:nil action:nil];
            }
    } else if (itemImage && handle) {
        if (leftFlag) {
            objc_setAssociatedObject(self, &MBBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(MB_navItemHandleImage:)];
        } else {
            objc_setAssociatedObject(self, &MBBaseTableVcNavRightItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(MB_navItemHandleImage:)];
        }
    }
    
}


/** 右边item*/
- (void)setNavRightItem:(UIBarButtonItem *)navRightItem {
    _navRightItem = navRightItem;
    self.navigationItem.rightBarButtonItem = navRightItem;
}


- (UIBarButtonItem *)navRightItem {
    return self.navigationItem.rightBarButtonItem;
}
/** 左边item*/
- (void)setNavLeftItem:(UIBarButtonItem *)navLeftItem {
    
    _navLeftItem = navLeftItem;
    self.navigationItem.leftBarButtonItem = navLeftItem;
}

- (UIBarButtonItem *)navLeftItem {
    return self.navigationItem.leftBarButtonItem;
}

/** 导航栏标题*/
- (void)setNavItemTitle:(NSString *)navItemTitle {
    if ([navItemTitle isKindOfClass:[NSString class]] == NO) return ;
    if ([navItemTitle isEqualToString:_navItemTitle]) return ;
    _navItemTitle = navItemTitle.copy;
    self.navigationItem.title = navItemTitle;
}

/** 导航栏底部的隐形*/
- (UIImageView *)findShadowImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self findShadowImageViewUnder:subView];
        if (imageView) {
            return  imageView;
        }
    }
    return nil;
}

- (BOOL)isTranslucent {
    return NO;
}

- (void)setHiddenNavigationBarShadowImageView:(BOOL)hiddenNavigationBarShadowImageView {
    _hiddenNavigationBarShadowImageView = hiddenNavigationBarShadowImageView;
    
    if (hiddenNavigationBarShadowImageView) {
        _navShadowImageView.hidden = YES;
    }
}

@end
