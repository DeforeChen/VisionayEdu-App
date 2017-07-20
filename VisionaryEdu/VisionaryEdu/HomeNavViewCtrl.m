//
//  HomeNavViewCtrl.m
//  VisionaryEdu
//
//  Created by 李玉峰 on 2017/7/18.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "HomeNavViewCtrl.h"

@interface HomeNavViewCtrl ()

@end

@implementation HomeNavViewCtrl

+(instancetype)initMyView{
    UIStoryboard *sb     = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeNavViewCtrl * vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
