//
//  LKCommonNoNetworkingView.h
//  DBKit
//
//  Created by ZhangXiaofei on 16/9/13.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCommonNoNetworkingView : UIView
/** 没有网络，重试*/
@property (nonatomic, copy) void(^customNoNetworkEmptyViewDidClickRetryHandle)(LKCommonNoNetworkingView *view);

@end
