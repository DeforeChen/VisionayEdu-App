//
//  PwdModifyViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/26.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "PwdModifyViewCtrl.h"
#import "config.h"

@interface PwdModifyViewCtrl ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordConfirmTF;

@property (weak, nonatomic) IBOutlet UIImageView *visibleImg;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (assign,nonatomic) BOOL whetherNewPwdVisible;
@end

@implementation PwdModifyViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whetherNewPwdVisible = NO;
    self.confirmBtn.layer.cornerRadius = 6.0f;
    self.confirmBtn.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchNewPwdVisible:(UIButton *)sender {
    self.whetherNewPwdVisible = !self.whetherNewPwdVisible;
    
    self.visibleImg.image = [UIImage imageNamed:self.whetherNewPwdVisible == YES?@"view_selected":@"view_default"];
    self.NewPassWordTF.secureTextEntry        = self.whetherNewPwdVisible == YES?NO:YES;
    self.NewPassWordConfirmTF.secureTextEntry = self.whetherNewPwdVisible == YES?NO:YES;
}

- (IBAction)commitNewPwd:(UIButton *)sender {
    if ([self judegeInputLegal]) {
        [SysTool showTipWithMsg:@"确认修改密码吗?" handler:^(UIAlertAction *action) {
            [SysTool showLoadingHUDWithMsg:@"信息上送中..." duration:0];
            [[SYHttpTool sharedInstance] modifyPasswordWithNewPwd:self.NewPassWordTF.text confirmedNewPwd:self.NewPassWordConfirmTF.text oldPwd:self.oldPassWordTF.text completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"密钥修改成功，请重新登录!" handler:^(UIAlertAction *action) {
                        [LoginInfoModel clearLoginInfoInSandbox];
                        if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        } else // 学生端/家长端此时的根视图，不是staffHomePage，必须要调用类似于员工端"返回学生列表"的控件才行
                            [self dismissViewControllerAnimated:NO completion:nil];
                    } viewCtrl:self];
                } else
                    [SysTool showErrorWithMsg:msg duration:1];
            } token:[LoginInfoModel fetchTokenFromSandbox]];
        } viewCtrl:self];
    }
}

-(BOOL) judegeInputLegal {
    BOOL whether_Same = [self.NewPassWordTF.text isEqualToString:self.NewPassWordConfirmTF.text] ?YES:NO;
    if (whether_Same == NO) {
        [SysTool showErrorWithMsg:@"两次输入的密码不一致!" duration:1];
        return NO;
    }
    BOOL whether_longEnough = (self.NewPassWordTF.text.length >= 6 && self.NewPassWordConfirmTF.text.length >= 6)?YES:NO;
    if (whether_longEnough == NO) {
        [SysTool showErrorWithMsg:@"密码长度必须不小于6!" duration:1];
        return NO;
    }
    return YES;
}

#pragma mark TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {//允许删除
        return YES;
    } else if (textField.text.length >= 16) {
        [textField.text substringToIndex:16];
        [SysTool showErrorWithMsg:@"密码不能超过16个字" duration:1.5];
        return NO;
    } else if (![SysTool judgeRegExWithType:Judge_EnglishOrNumOrPunctuation String:string]) {
        [SysTool showErrorWithMsg:@"请不要使用中文或非法字符作为密码!" duration:1];
        return NO;
    }
    return YES;
}


@end
