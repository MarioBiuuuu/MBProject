//
//  UIImage+Addition.h
//  NeiHan
//
//  Created by Charles on 16/9/1.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

+ (UIImage *)circleImageWithname:(NSString *)name
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor;

/**
 *  保持宽高比设置图片在多大区域显示
 */
- (UIImage *)sourceImage:(UIImage *)sourceImage
              targetSize:(CGSize)targetSize;

/**
 *  指定宽度按比例缩放
 */
- (UIImage *)sourceImage:(UIImage *)sourceImage
             targetWidth:(CGFloat)targetWidth;

/**
 *  等比例缩放
 */
- (UIImage *)sourceImage:(UIImage *)sourceImage
                   scale:(CGFloat)scale;


+ (UIImage *)resizableImageWithImageName:(NSString *)imageName;


/**
 *  获取视频第一帧截图
 *
 *  @param videoURL 视频url
 *  @param time 时间
 *
 *  @return 截图
 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;


/** 压缩图片到指定的物理大小*/
- (NSData *)compressImageDataWithMaxLimit:(CGFloat)maxLimit;

- (UIImage *)compressImageWithMaxLimit:(CGFloat)maxLimit;

@end
