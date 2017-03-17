//
//  LKCustomTextView.h
//  LKProject
//
//  Created by ZhangXiaofei on 16/9/14.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKCustomPlaceHolderTextView;
@protocol LKCustomPlaceHolderTextViewDelegate <NSObject>
/** 文本改变回调*/
- (void)customPlaceHolderTextViewTextDidChange:(LKCustomPlaceHolderTextView *)textView;

@end

@interface LKCustomPlaceHolderTextView : UITextView
@property (nonatomic, strong) id <LKCustomPlaceHolderTextViewDelegate> del;
@property (nonatomic,copy) NSString *placehoder;
@property (nonatomic,strong)UIColor *placehoderColor;
@property (nonatomic, assign) CGFloat placeholderTopMargin;
@property (nonatomic, assign) CGFloat placeholderLeftMargin;
@property (nonatomic, strong) UIFont *placeholderFont;
@end
