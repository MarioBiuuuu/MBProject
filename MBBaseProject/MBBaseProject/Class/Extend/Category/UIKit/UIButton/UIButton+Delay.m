//
//  UIControl+Delay.m
//  LKProject
//
//  Created by ZhangXiaofei on 17/3/21.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "UIButton+Delay.h"
#import <objc/runtime.h>

static const char *UIControl_acceptEventInterval = "UIControl_delay_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_delay_acceptEventTime";

//static const NSTimeInterval kDEFAULT_DELAY_TIME = 2;

#define kJUDGE_CLASS_ARR   @[@"UIButton", @"UIBarButtonItem"]

@implementation UIButton (Delay)

+ (void)load {
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method customMethod = class_getInstanceMethod(self, @selector(custom_sendAction:to:forEvent:));
    SEL customSEL = @selector(custom_sendAction:to:forEvent:);
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self, customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    } else {
        method_exchangeImplementations(systemMethod, customMethod);
    }
}

- (NSTimeInterval )custom_acceptEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setCustom_acceptEventInterval:(NSTimeInterval)custom_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )delay_acceptEventTime {
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setDelay_acceptEventTime:(NSTimeInterval)custom_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(custom_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"%@", @(self.custom_acceptEventInterval));
    
    if (self.delay_acceptEventTime <= 0) {
        self.custom_acceptEventInterval = 0;
        [self custom_sendAction:action to:target forEvent:event];
    } else {
        BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.delay_acceptEventTime >= self.custom_acceptEventInterval);
        self.custom_acceptEventInterval = NSDate.date.timeIntervalSince1970;
        if ([kJUDGE_CLASS_ARR containsObject:NSStringFromClass([self class])]) {
            if (needSendAction) {
                [self custom_sendAction:action to:target forEvent:event];
                
            }
        } else {
            [self custom_sendAction:action to:target forEvent:event];
        }
    }
}

@end
