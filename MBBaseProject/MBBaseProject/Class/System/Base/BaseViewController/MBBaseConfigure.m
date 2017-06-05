//
//  MBBaseConfigure.m
//  MBBaseProject
//
//  Created by ZhangXiaofei on 2017/6/5.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBBaseConfigure.h"

@implementation MBBaseConfigure

- (UIColor *)viewBackgroundColor {
    if (!_viewBackgroundColor) {
        _viewBackgroundColor = [UIColor whiteColor];
    }
    return _viewBackgroundColor;
}

- (UIColor *)navigationBar_tintColor {
    if (!_navigationBar_tintColor) {
        _navigationBar_tintColor = [UIColor blackColor];
    }
    return _navigationBar_tintColor;
}

- (UIColor *)navigationBar_barTintColor {
    if (!_navigationBar_barTintColor) {
        _navigationBar_barTintColor = self.baseColor;
    }
    return _navigationBar_barTintColor;
}

- (NSString *)navigationBar_backTitle {
    if (!_navigationBar_backTitle) {
        _navigationBar_backTitle = @"";
    }
    return _navigationBar_backTitle;
}

- (UIBarStyle)navigationBar_barStyle {
    if (!_navigationBar_barStyle) {
        _navigationBar_barStyle = UIBarStyleDefault;
    }
    return _navigationBar_barStyle;
}

- (NSDictionary *)navigationBar_titleAttributes {
    if (!_navigationBar_titleAttributes) {
        _navigationBar_titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName : self.baseColor};
    }
    return _navigationBar_titleAttributes;
}

- (UIColor *)baseColor {
    if (!_baseColor) {
        _baseColor = [UIColor whiteColor];
    }
    return _baseColor;
}

- (UIStatusBarStyle)statusBarStyle {
    if (!_statusBarStyle) {
        _statusBarStyle = UIStatusBarStyleDefault;
    }
    
    return _statusBarStyle;
}

@end
