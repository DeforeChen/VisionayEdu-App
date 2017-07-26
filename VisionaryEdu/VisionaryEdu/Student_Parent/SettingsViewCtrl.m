//
//  SettingsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "SettingsViewCtrl.h"
#import "config.h"
#import <WebKit/WebKit.h>

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
        if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else
            [self dismissViewControllerAnimated:NO completion:nil];
        [LoginInfoModel clearLoginInfoInSandbox];
    } viewCtrl:self];
}

- (IBAction)checkUserProtocol:(UIButton *)sender {
    UIViewController *vc = [UIViewController new];
    WKWebView *web = [[WKWebView alloc] initWithFrame:vc.view.frame];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:USER_PROTOCOL_HTML]]];
    [vc.view addSubview:web];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
