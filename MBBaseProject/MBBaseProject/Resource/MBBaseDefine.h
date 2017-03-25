//
//  MBBaseDefine.h
//  MBProject
//
//  Created by Yuri on 16/8/29.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#ifndef MBBaseDefine_h
#define MBBaseDefine_h

#import <Toast/UIView+Toast.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBBaseKeyDefine.h"

// 导航颜色
// B12323
#define DEF_NAVIGATIONBAR_COLOR [UIColor colorWithRed:56 / 255.0 green:166 / 255.0 blue:229 / 255.0 alpha:1]
#define DEF_NAVIGATIONBAR_TINTCOLOR [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1]
//#define DEF_NAVIGATIONBAR_COLOR [UIColor colorWithRed:190.0 / 255.0 green:48.0 / 255.0 blue:48.0 / 255.0 alpha:1.0]

//背景色
#define DEF_VIEWCONTROLLER_BGCOLOR [UIColor colorWithWhite:0.940 alpha:1.000]


//切换开发环境后不同的定义 0/1 = debug/release
#define AD_HOC_TEST 1

#if (defined(DEBUG) && AD_HOC_TEST == 0)

#else

#endif


//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

#define DEF_SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define DEF_SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define DEF_SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define DEF_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEF_SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEF_SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

//获取通知中心
#define DEF_NotificationCenter [NSNotificationCenter defaultCenter]

//NSUserdefault存取
#define DEF_SaveUserDefault(obj, key) [[NSUserDefaults standardUserDefaults] setValue:obj forKey:key]
#define DEF_GetUserDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

//设置随机颜色
#define DEF_RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//设置RGB颜色/设置RGBA颜色
#define DEF_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DEF_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define DEF_HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// clear背景颜色
#define DEF_YRClearColor [UIColor clearColor]

//自定义高效率的 NSLog
#ifdef DEBUG
#define DEF_Log(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DEF_Log(...)

#endif

#define DEF_Window [UIApplication sharedApplication].keyWindow
//弱引用/强引用
#define DEF_WeakSelf(type)  __weak typeof(type) weak##type = type;
#define DEF_StrongSelf(type)  __strong typeof(type) type = weak##type;

//设置 view 圆角和边框
#define DEF_ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//由角度转换弧度 由弧度转换角度
#define DEF_DegreesToRadian(x) (M_PI * (x) / 180.0)
#define DEF_RadianToDegrees(radian) (radian*180.0)/(M_PI)


//设置加载提示框（第三方框架：Toast）
#define DEF_Toast(str) \
\
CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
style.backgroundColor = [UIColor lightGrayColor]; \
style.titleColor = [UIColor whiteColor]; \
style.titleColor = [UIColor whiteColor]; \
style.titleFont = [UIFont systemFontOfSize:13]; \
style.messageFont = [UIFont systemFontOfSize:13]; \
[DEF_Window  makeToast:str duration:1.0 position:CSToastPositionBottom style:style]; \
DEF_Window.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
DEF_Window.userInteractionEnabled = YES; \
}); \


#define DEF_BackView         for (UIView *item in DEF_Window.subviews) { \
if(item.tag == 10000) \
{ \
[item removeFromSuperview]; \
UIView * aView = [[UIView alloc] init]; \
aView.frame = [UIScreen mainScreen].bounds; \
aView.tag = 10000; \
aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
[DEF_Window addSubview:aView]; \
} \
} \
//搜索无结果提示信息
#define DEF_NothingHint(str)         for (UIView *item in DEF_Window.subviews) { \
if(item.tag == 100000) \
{ \
[item removeFromSuperview]; \
} \
} \
UILabel *nothingHintLb = [[UILabel alloc] init]; \
nothingHintLb.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 20); \
nothingHintLb.textAlignment = NSTextAlignmentCenter; \
nothingHintLb.center = DEF_Window.center; \
nothingHintLb.tag = 100000; \
nothingHintLb.textColor =  DEF_RGBColor(153, 153, 153); \
nothingHintLb.text = str; \
nothingHintLb.font = [UIFont systemFontOfSize:17]; \
[DEF_Window addSubview:nothingHintLb]; \
//设置加载提示框（第三方框架：MBProgressHUD）

#define DEF_ShowHUDAndActivity(str)  DEF_BackView;\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:DEF_Window animated:YES]; \
hud.userInteractionEnabled = YES; \
hud.mode = MBProgressHUDModeIndeterminate; \
hud.color = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:226.0/255.0 alpha:0.8]; \
hud.activityIndicatorColor = [UIColor blackColor]; \
hud.labelColor = DEF_RGBColor(64.0, 64.0, 64.0); \
hud.labelFont = [UIFont systemFontOfSize:13]; \
if (str && str.length > 0) {    \
hud.labelText = str;\
} else {    \
hud.labelText = @"  加载中...  ";  \
}   \
//[MBProgressHUD showHUDAddedTo:DEF_Window animated:YES];

//#define DEF_HiddenMBHUD [MBProgressHUD hideAllHUDsForView:DEF_Window animated:YES]
#define DEF_HiddenMBHUD [MBProgressHUD hideHUDForView:DEF_Window animated:YES];

#define kRemoveBackView         for (UIView *item in DEF_Window.subviews) { \
if(item.tag == 10000) \
{ \
[UIView animateWithDuration:0.4 animations:^{ \
item.alpha = 0.0; \
} completion:^(BOOL finished) { \
[item removeFromSuperview]; \
}]; \
} \
} \

#define kRemoveNothingHint         for (UIView *item in DEF_Window.subviews) { \
if(item.tag == 100000) \
{ \
[item removeFromSuperview]; \
} \
} \

#define DEF_HiddenHUDAndAvtivity kRemoveBackView;kHiddenHUD;HideNetworkActivityIndicator()

//获取view的frame/图片资源
//获取view的frame（不建议使用）
#define DEF_GetViewWidth(view)  view.frame.size.width
#define DEF_GetViewHeight(view) view.frame.size.height
#define DEF_GetViewX(view)      view.frame.origin.x
#define DEF_GetViewY(view)      view.frame.origin.y

//获取图片资源
#define DEF_GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//获取当前语言
#define DEF_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//使用 ARC 和 MRC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif

//判断当前的iPhone设备/系统版本
//判断是否为iPhone
#define DEF_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define DEF_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define DEF_IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 5SE
#define DEF_iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

// 判断是否为iPhone 6/6s
#define DEF_iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

// 判断是否为iPhone 6Plus/6sPlus
#define DEF_iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

//获取系统版本
#define DEF_IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断 iOS 8 或更高的系统版本
#define DEF_IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//沙盒目录文件
//获取temp
#define DEF_PathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define DEF_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define DEF_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//GCD 的宏定义
//GCD - 一次性执行
#define DEF_DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define DEF_DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define DEF_DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

//网络提示符 （状态栏）
//是否开启网络标示符
#define DEF_ShowSystemNetworkActivityIndicator [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]
#define DEF_HidenSystemNetworkActivityIndicator [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]

//隐藏键盘
#define DEF_HidenKeyboard [[[UIApplication sharedApplication] keyWindow] endEditing:YES]

#endif /* MBBaseDefine_h */
