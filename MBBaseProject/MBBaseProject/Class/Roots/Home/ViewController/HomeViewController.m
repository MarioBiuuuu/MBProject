
//  HomeViewController.m
//  LKLBSDoubleForiOS
//
//  Created by ZhangXiaofei on 17/2/28.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "HomeViewController.h"
@interface HomeViewController () {
}

@end

@implementation HomeViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"这是个标题";
    MBBaseConfigure *conf = [[MBBaseConfigure alloc] init];
    conf.viewBackgroundColor = [UIColor redColor];
    conf.baseColor = [UIColor orangeColor];
    conf.statusBarStyle = UIStatusBarStyleLightContent;
    conf.navigationBar_barTintColor = [UIColor blueColor];
    conf.navigationBar_tintColor = [UIColor greenColor];
    self.baseConfigure = conf;
}

@end
