//
//  LKAlertView.m
//  TTTTTText
//
//  Created by yunjing on 2017/2/3.
//  Copyright © 2017年 yunjing. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#import "LKAlertView.h"
@interface LKAlertView()

@property(copy,nonatomic)void (^cancelClicked)();
@property(copy,nonatomic)void (^confirmClicked)();

@end

@implementation LKAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    if (self) {
        if (_cancelClicked != cancelblock) {
            _cancelClicked = cancelblock;
        }
        if (_confirmClicked != confirmBlock) {
            _confirmClicked = confirmBlock;
        }
    }
    return self;
}
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock {
    LKAlertView *alert = [[LKAlertView alloc]initWithTitle:title message:message cancelButtonWithTitle:cancelTitle cancelBlock:cancelblock confirmButtonWithTitle:confirmTitle confrimBlock:confirmBlock];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (self.confirmClicked) {
            self.confirmClicked();
        }
    }else {
        if (self.cancelClicked) {
            self.cancelClicked();
        }
    }
}
#pragma clang diagnostic pop
@end
