//
//  MBTabBarViewController.m
//  LKBaseTabbarController
//
//  Created by ZhangXiaofei on 17/3/16.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBTabBarViewController.h"
#import "MBTabBar.h"
#import <UIKit/UIKit.h>

/** 生成所需图片 */
@interface UIImage (OriginalImage)
// Create a version of this image with the specified rendering mode. By default, images have a rendering mode of UIImageRenderingModeAutomatic.
+ (instancetype)renderingImageWithOriginalImage:(UIImage *)image;
// Create a version of this image with the specified rendering mode. By default, images have a rendering mode of UIImageRenderingModeAutomatic.
- (instancetype)renderingImage;

/**
 通过颜色生成图片

 @param color 颜色
 @param size 尺寸
 @return 图片
 */
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@implementation UIImage (OriginalImage)
+ (instancetype)renderingImageWithOriginalImage:(UIImage *)image {
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (instancetype)renderingImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat components[4];
    [self getRGBComponents:components forColor:color];
    
    CGContextSetRGBFillColor(ctx, components[0], components[1], components[2], components[3]);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++) {
        if (component == 3) {
            components[component] = resultingPixel[component];
        }else {
            components[component] = resultingPixel[component] / 255.0f;
        }
    }
}
@end


@interface MBTabBarViewController () <MBTabBarDelegate>

/**
 *  点击中间凸起按钮Block
 */
@property (nonatomic,copy) CenterButtonHandler centerButtonHandler;

/**
 *  MBTabbarViewControllerStyle
 */
@property (nonatomic, assign) MBTabbarViewControllerStyle tabbarStyle;

/**
 *  中间凸起部分标题
 */
@property (nonatomic, copy) NSString *bulgeTitle;

/**
 *  中间凸起部分图片
 */
@property (nonatomic, strong) UIImage *bulgeImage;

/**
 *  自定义TabBar
 */
@property (nonatomic, strong) MBTabBar *definedTabBar;

/**
 *  添加的tabBarItems的数量
 */
@property (nonatomic, assign) NSUInteger tabBarItemsCount;

/**
 *  添加的子视图控制器
 */
@property (nonatomic, strong) NSMutableArray <UIViewController *> *childViewControllers;

/**
 *  中间按钮添加视图导航控制器
 */
@property (nonatomic, strong) UINavigationController *centerNavigationController;

@end

@implementation MBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithTabBarStyle:(MBTabbarViewControllerStyle)style bulgeBtnTitle:(NSString *)bulgeTitle bulgeBtnImage:(UIImage *)bulgeImage {
    
    if (self = [super init]) {
        self.childViewControllers = [NSMutableArray array];
        self.tabbarStyle = style;
        self.bulgeTitle = bulgeTitle;
        self.bulgeImage = bulgeImage;
        [self initialTabBar];

    }
    
    return self;
}

- (void)initialTabBar {
    MBTabBarStyle style = MBTabBarStyleNormal;
    switch (self.tabbarStyle) {
        case MBTabbarViewControllerStyleNormal:
            self.tabBarItemsCount = 0;
            style = MBTabBarStyleNormal;
            break;
        case MBTabbarViewControllerStyleBulge:
            self.tabBarItemsCount = 1;
            style = MBTabBarStyleBulge;
            break;
        default:
            break;
    }
    
    MBTabBar *tabBar = [[MBTabBar alloc] initWithStyle:style bulgeBtnTitle:self.bulgeTitle bulgeBtnImage:self.bulgeImage];
    self.definedTabBar = tabBar;
    tabBar.translucent = NO;
    tabBar.centerBtnDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - 添加TabBarController的子视图控制器
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self.tabBarItemsCount += 1;
    [self.childViewControllers addObject:childVc];
    
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [image renderingImage];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [selectedImage renderingImage];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控制器
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
    
}

- (void)addChildVcs:(NSArray <UIViewController *>*)childVcs titles:(NSArray <NSString *>*)titles images:(NSArray <UIImage *>*)images selectedImages:(NSArray <UIImage *>*)selectedImages {
    NSAssert((childVcs.count == titles.count && childVcs.count == images.count && childVcs.count == selectedImages.count), @"You must set the same number of controller and properties. (你必须设置相同数量的属性和属性对应)");
    if (childVcs.count == titles.count && childVcs.count == images.count && childVcs.count == selectedImages.count) {
        for (int i = 0; i < childVcs.count; i ++) {
            UIViewController *child = childVcs[i];
            NSString *title = titles[i];
            UIImage *normalImage = images[i];
            UIImage *selectedImage = selectedImages[i];
            
            if (child) {
                [self addChildVc:child title:title image:normalImage selectedImage:selectedImage];
            }
        }
    }
}

/** buldge button control */
- (void)changeShowView {
    if (self.tabbarViewControllerBuldgeControl == MBTabbarViewControllerBuldgeControlChild) {
        UIViewController *currentVc = self.childViewControllers[self.selectedIndex];
        [currentVc.navigationController.navigationBar setHidden:YES];
        
        UINavigationController *navCenter = [[UINavigationController alloc] initWithRootViewController:self.centerViewController];
        self.centerNavigationController = navCenter;
        
        [currentVc addChildViewController:navCenter];
        [currentVc.view addSubview:navCenter.view];

    } else {
        [self presentViewController:self.centerViewController animated:YES completion:nil];
        
    }
}

/** 变换Item标题颜色 */
- (void)changeItemTintColor {
    if (self.tabbarViewControllerBuldgeControl == MBTabbarViewControllerBuldgeControlChild) {
        
        self.tabBar.selectionIndicatorImage = nil;
        
        for (UIViewController *childVc in self.childViewControllers) {
            [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : self.tabBarNormalTitleColor} forState:UIControlStateSelected];
        }
    }
}

#pragma mark - CenterButtonClick block
- (void)centerButtonClick:(CenterButtonHandler)handler {
    self.centerButtonHandler = handler;
}

#pragma mark - Override property setter
- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    _selectionIndicatorColor = selectionIndicatorColor;
    
    CGFloat itemW = self.tabBar.bounds.size.width / self.tabBarItemsCount;
    CGFloat itemH = self.tabBar.bounds.size.height;

    CGSize indicatorImageSize = CGSizeMake(itemW, itemH);
    
    self.tabBar.selectionIndicatorImage = [UIImage imageWithColor:selectionIndicatorColor size:indicatorImageSize];
}

- (void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage {
    _selectionIndicatorImage = selectionIndicatorImage;
    self.tabBar.selectionIndicatorImage = selectionIndicatorImage;
}

- (void)setTabBarBackgroundColor:(UIColor *)tabBarBackgroundColor {
    _tabBarBackgroundColor = tabBarBackgroundColor;
    [[UITabBar appearance] setBarTintColor:tabBarBackgroundColor];
}

- (void)setTabBarSelectedTitleColor:(UIColor *)tabBarSelectedTitleColor {
    
    _tabBarSelectedTitleColor = tabBarSelectedTitleColor;
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : tabBarSelectedTitleColor} forState:UIControlStateSelected];
    }
}

- (void)setTabBarNormalTitleColor:(UIColor *)tabBarNormalTitleColor {
    _tabBarNormalTitleColor = tabBarNormalTitleColor;
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : tabBarNormalTitleColor} forState:UIControlStateNormal];
    }
}

- (void)setTabbarViewControllerBuldgeControl:(MBTabbarViewControllerBuldgeControl)tabbarViewControllerBuldgeControl {
    _tabbarViewControllerBuldgeControl = tabbarViewControllerBuldgeControl;
    self.definedTabBar.showInCurrentView = tabbarViewControllerBuldgeControl == MBTabbarViewControllerBuldgeControlChild;
}


#pragma mark - MBTabBarDelegate
- (void)mb_tabBar:(MBTabBar *)tabBar bulgeBtnClick:(UIButton *)btn {
    [self changeItemTintColor];
    [self changeShowView];
    if (self.centerButtonDelegate && [self.centerButtonDelegate respondsToSelector:@selector(mb_tabBarViewController:centerButtonClick:)]) {
        [self.centerButtonDelegate mb_tabBarViewController:self centerButtonClick:btn];
    } else {
        if (self.centerButtonHandler) {
            self.centerButtonHandler(self, btn);
        }
    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    for (UIViewController *childVc in self.childViewControllers) {
        [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : self.tabBarSelectedTitleColor} forState:UIControlStateSelected];
        if (self.selectionIndicatorColor) {
            [self setSelectionIndicatorColor:self.selectionIndicatorColor];
        } else {
            [self setSelectionIndicatorImage:self.selectionIndicatorImage];
        }
    }
    [self.centerNavigationController removeFromParentViewController];
    [self.centerNavigationController.view removeFromSuperview];
    [self.centerViewController removeFromParentViewController];
    [self.centerViewController.view removeFromSuperview];
    
    UIViewController *currentVc = self.childViewControllers[self.selectedIndex];
    [currentVc.navigationController.navigationBar setHidden:NO];

}

@end
