//
//  YuriCreadeCodeImage.h
//  YuriScannerView
//
//  Created by 张晓飞 on 16/3/13.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YuriCreateCodeImage : NSObject

+ (CIImage *)createCodeImage:(NSString *)source;
+ (UIImage *)reSizeCodeImage:(CIImage *)image withSize:(CGFloat)size;
+ (UIImage *)resetColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
