//
//  LKAlertView.h
//  TTTTTText
//
//  Created by yunjing on 2017/2/3.
//  Copyright © 2017年 yunjing. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface LKAlertView : UIAlertView<UIAlertViewDelegate>

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
 cancelButtonWithTitle:(NSString *)cancelTitle
           cancelBlock:(void (^)())cancelblock
confirmButtonWithTitle:(NSString *)confirmTitle
          confrimBlock:(void (^)())confirmBlock;

@end
#pragma clang diagnostic pop
