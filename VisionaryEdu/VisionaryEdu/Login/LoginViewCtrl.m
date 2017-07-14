//
//  LoginViewCtrl.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/20.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "LoginViewCtrl.h"
#import "SysTool.h"
#import "SYHttpTool.h"
#import "LoginInfoModel.h"
#import <MJExtension/MJExtension.h>
#import <JPush/JPUSHService.h>

@interface LoginViewCtrl ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation LoginViewCtrl
+(instancetype)initMyView {
    LoginViewCtrl *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
-(BOOL)judgeInputLegal {
    return [SysTool judgeRegExWithType:Judge_EnglishOrNum String:self.usernameTF.text];
}

#pragma mark UserInteraction
- (IBAction)login:(UIButton *)sender {
    if ([self judgeInputLegal]) {
        [SysTool showLoadingHUDWithMsg:@"登录中..." duration:0];
        NSString *jpushID = [JPUSHService registrationID];
        [[SYHttpTool sharedInstance] fetchTokenWithUserName:self.usernameTF.text password:self.pwdTF.text registration_id:jpushID completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                LoginInfoModel *info = [LoginInfoModel mj_objectWithKeyValues:responseObject];
                if (info.retCode == 0) {
                    [info saveLoginInfoIntoSandbox:self.usernameTF.text];
                    NSLog(@"token = %@",info.token);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSString *errorMsg = (info.retCode == 1)?@"用户名不存在":@"密码错误";
                    [SysTool showErrorWithMsg:errorMsg duration:1];
                }
            } else {
                [SysTool showErrorWithMsg:msg duration:1];
            }
        }];
        
    } else {
        [SysTool showErrorWithMsg:@"用户名仅包含数字、英文、下划线" duration:1];
    }
}

@end
