//
//  YuriCodeScanView.h
//  YuriCodeScanner
//
//  Created by 张晓飞 on 16/3/11.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

/**
 *  二维码扫描框的宽度（正方形）
 */
#define kScanViewWidth  kScreenWidth * 0.65

#define kScanOriginY    kScreenHeight * 0.2

#define KBackgroundViewColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f]

typedef void(^ResultBlock)(NSString *result);

@interface YuriCodeScanView : UIView
/**
 *  扫描框下方提示文字
 */
@property (nonatomic, copy) NSString *tipMessage;

@property (nonatomic, assign) BOOL autoRemoveScanView;

/**
 *  默认Frame为整个屏幕的尺寸
 *
 */
+ (instancetype)scanView;

/**
 *  创建自定义Frame的扫描框
 *
 */
+ (instancetype)scanViewWithFrame:(CGRect)frame;

/**
 *  开始扫描
 */
- (void)beginScanning;

/**
 *  输出结果
 */
- (void)outputResultString:(ResultBlock)result;

- (void)hidScanView;

@end
