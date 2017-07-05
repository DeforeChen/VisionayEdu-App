//
//  TabBarManagerViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "TabBarManagerViewCtrl.h"

@interface TabBarManagerViewCtrl ()

@end

@implementation TabBarManagerViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.customTabbar = [CustomTabbarView initMyViewWithTabBarCtrl:self];
    [self.customTabbar setInitialPage:2];
    [self.view addSubview:self.customTabbar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
