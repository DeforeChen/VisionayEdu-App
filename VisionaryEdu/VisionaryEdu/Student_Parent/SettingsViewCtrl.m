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
    [SysTool showLoadingHUDWithMsg:@"登出中..." duration:0];
    [[SYHttpTool sharedInstance] logoutRequest:LOGOUT token:[LoginInfoModel fetchTokenFromSandbox] completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            NSString *retDetails = [responseObject objectForKey:@"detail"];
            if ([retDetails isEqualToString:LOGOUT_SUC]) {
                [LoginInfoModel clearLoginInfoInSandbox];
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else
                [SysTool showErrorWithMsg:@"登出错误，请重试!" duration:1.5];
        } else {
            NSString *errMsg = [NSString stringWithFormat:@"登出失败\n%@",msg];
            [SysTool showErrorWithMsg:errMsg duration:1.5];
        }
    }];
}


@end
