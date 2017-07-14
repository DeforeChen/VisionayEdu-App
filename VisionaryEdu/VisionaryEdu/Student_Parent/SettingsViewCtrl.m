//
//  SettingsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "SettingsViewCtrl.h"
#import "config.h"

#define LOGOUT_SUC @"Successfully logged out."
@interface SettingsViewCtrl ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation SettingsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoutBtn.layer.cornerRadius = 6.f;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UserInteraction
- (IBAction)logout:(UIButton *)sender {
    [SysTool showAlertWithMsg:@"登出成功" handler:^(UIAlertAction *action) {
        [LoginInfoModel clearLoginInfoInSandbox];
        [self.navigationController popToRootViewControllerAnimated:NO];
    } viewCtrl:self];
}

@end
