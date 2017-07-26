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
#import <JPUSHService.h>
#import <WebKit/WebKit.h>

@interface LoginViewCtrl ()<UITextFieldDelegate>
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
    self.usernameTF.text = [SysTool TrimSpaceString:self.usernameTF.text];
    if (self.pwdTF.text.length == 0) {
        [SysTool showErrorWithMsg:@"密码不能为空!" duration:1];
        return NO;
    }
    
    if (self.pwdTF.text.length == 16) {
        [SysTool showErrorWithMsg:@"密码太长!不能超过16个字" duration:1];
        return NO;
    }
    
    if (![SysTool judgeRegExWithType:Judge_EnglishOrNumOrPunctuation String:self.usernameTF.text]) {
         [SysTool showErrorWithMsg:@"用户名仅包含数字、英文、下划线" duration:1];
    }
    return YES;
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
    }
}

- (IBAction)checkUserProtocol:(UIButton *)sender {
    UIViewController *vc = [UIViewController new];
    WKWebView *web = [[WKWebView alloc] initWithFrame:vc.view.frame];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:USER_PROTOCOL_HTML]]];
    [vc.view addSubview:web];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark TextField Delegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.usernameTF)
        self.usernameTF.text = [SysTool TrimSpaceString:self.usernameTF.text];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    } else if (![SysTool judgeRegExWithType:Judge_EnglishOrNumOrPunctuation String:string]) {
        [SysTool showErrorWithMsg:@"请勿输入中文或非法字符!" duration:1];
        return NO;
    }
    return YES;
}
@end
