//
//  ApiUtil.h
//  LKProject
//
//  Created by yunjing on 2017/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TestModel, StoreInfoModel ,MerchantInfoModel ,AllIndustryModel ,MerchantRedItem ,RedpaketModel ,MessageListModel ,CreateRedEnvelopeModel,AssistantListModel;

@interface ApiUtil : NSObject

/**
 *  停止所有上传网络请求
 */
+ (void)cancelAllUploadTask;


@end
