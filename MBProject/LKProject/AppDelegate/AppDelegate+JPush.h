//
//  AppDelegate+JPush.h
//  LKProject
//
//  Created by ZhangXiaofei on 17/3/8.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate (JPush) <JPUSHRegisterDelegate>
/**
 *  注册极光推送SDK
 *
 *  @param appKey         应用申请的appKey
 *  @param channel        指明应用程序包的下载渠道，为方便分渠道统计，具体值自行定义，如：App Store。
 *  @param isProduction   用于标识当前应用所使用的APNs证书环境， 0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。 注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
 */
- (void)registerJPUSHServiceWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appKey:(NSString *)appKey channel:(NSString *)channel isProduction:(BOOL)isProduction;
@end
