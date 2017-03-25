//
//  CKAlertViewController.h
//  自定义警告框
//
//  Created by 陈凯 on 16/8/24.
//  Copyright © 2016年 陈凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler;

@property (nonatomic, readonly) NSString *title;

@end


@interface CKAlertViewController : UIViewController

@property (nonatomic, readonly) NSArray<CKAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;

/**
 新增Block回调形式 by.Xiaofei Zhang

 @param targetViewController 显示目标控制器
 @param title 标题
 @param message 内容
 @param cancelTitle 取消
 @param otherTitles 其他按钮组合
 @param handler 回调
 */
+ (void)showAlertIn:(UIViewController *)targetViewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray <NSString *>*)otherTitles handler:(void (^)(CKAlertViewController *alert, NSUInteger index))handler;

- (void)addAction:(CKAlertAction *)action;

@end
