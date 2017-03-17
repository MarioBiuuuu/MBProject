//
//  UIViewController+BackButtonHandler.h
//  Dangdang
//
//  Created by Yuri on 16/6/27.
//  Copyright © 2016年 Eric MiAo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end
@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>
@end
