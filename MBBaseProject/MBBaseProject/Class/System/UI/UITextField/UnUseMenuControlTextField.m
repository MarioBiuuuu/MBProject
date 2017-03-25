//
//  UnUseMenuControl.m
//  LKProject
//
//  Created by ZhangXiaofei on 16/12/6.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "UnUseMenuControlTextField.h"
#
@implementation UnUseMenuControlTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if(menuController) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}

@end
