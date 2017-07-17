//
//  ObjDetailsUViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ObjDetailsUViewCtrl.h"
#import "config.h"
#import "UIColor+expanded.h"

#define COMNENT_HOLDER   @"请输入评价"

@interface ObjDetailsUViewCtrl ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *beginDateLB;
@property (weak, nonatomic) IBOutlet UILabel *endDateLB;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UITextView *staffCommentTextView;

@property (weak, nonatomic) IBOutlet UIButton *editStartDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *editEndDateBtn;

@property (weak, nonatomic) IBOutlet UIImageView *editStartDateImg;
@property (weak, nonatomic) IBOutlet UIImageView *editEndDateImg;
@property (weak, nonatomic) IBOutlet UIImageView *editContentImg;
@property (weak, nonatomic) IBOutlet UIImageView *editCommentImg;

@property (weak, nonatomic) IBOutlet UIButton *modifyObjBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *switchEditModeBtn;
@property (weak, nonatomic) IBOutlet UIView *modifyBtnContainerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteObjBtn;

@property (strong,nonatomic) NSDateFormatter *dateformatter;
@property (assign,nonatomic) BOOL whetherSelectStart;
@property (assign,nonatomic) BOOL whetherEditMode;
@end

@implementation ObjDetailsUViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whetherEditMode = NO;
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        [self switchOnEditMode:NO];
    } else { //家长模式或学生模式
        self.switchEditModeBtn.hidden = YES;
        [self switchOnEditMode:NO];
    }
    
    self.beginDateLB.text = self.objInfo.begin_date;
    self.endDateLB.text = self.objInfo.end_date;
    self.contentTF.text = self.objInfo.objective;
    self.staffCommentTextView.text = self.objInfo.staff_comment;
    // Do any additional setup after loading the view.
    self.modifyObjBtn.layer.cornerRadius = 6.0;
    self.modifyObjBtn.clipsToBounds = YES;
    
    self.confirmBtn.alpha = 0.0f;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"#43434D"].CGColor;
    self.confirmBtn.layer.borderWidth = 1.0;
    self.confirmBtn.layer.cornerRadius = 10.0;
    self.confirmBtn.clipsToBounds = YES;
    
    self.datePicker.alpha = 0.0f;
    self.dateformatter = [[NSDateFormatter alloc] init];
    [self.dateformatter setDateFormat:@"yyyy-MM-dd"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UserInertactions
- (IBAction)switchEditMode:(UIButton *)sender {
    self.whetherEditMode = !self.whetherEditMode;
    [self switchOnEditMode:self.whetherEditMode];
}

- (IBAction)selectBeginDate:(UIButton *)sender {
    [self.view endEditing:YES];
    self.whetherSelectStart = YES;
    // 对当前datepicker 赋值
    self.datePicker.date = [self.dateformatter dateFromString:self.beginDateLB.text];
    if (self.datePicker.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.datePicker.alpha = 1.0f;
            self.confirmBtn.alpha = 1.0f;
        }];
    }
}

- (IBAction)selectEndDate:(UIButton *)sender {
    [self.view endEditing:YES];
    self.whetherSelectStart = NO;
    // 对当前datepicker 赋值
    self.datePicker.date = [self.dateformatter dateFromString:self.endDateLB.text];
    
    if (self.datePicker.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.datePicker.alpha = 1.0f;
            self.confirmBtn.alpha = 1.0f;
        }];
    }
}

- (IBAction)confirmDate:(UIButton *)sender {
    NSString *date = [self.dateformatter stringFromDate:self.datePicker.date];
    if (self.whetherSelectStart == YES) {
        self.beginDateLB.text = date;
    } else
        self.endDateLB.text = date;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.datePicker.alpha = 0.0f;
        self.confirmBtn.alpha = 0.0f;
    }];
}

- (IBAction)modifyObjectives:(UIButton *)sender {
    if ([self judgeLegalInput]) {
        [SysTool showTipWithMsg:@"确定修改吗？" handler:^(UIAlertAction *action) {
            [SysTool showLoadingHUDWithMsg:@"目标数据上送中..." duration:0];
            NSDictionary *reqDict = @{@"student_username":[StudentInstance shareInstance].student_realname,
                                      @"begin_date": self.beginDateLB.text,
                                      @"end_date": self.endDateLB.text,
                                      @"objective": self.contentTF.text,
                                      @"staff_comment": self.staffCommentTextView.text
                                      };
            [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_OBJ primaryKey:self.objInfo.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"修改成功!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } viewCtrl:self];
                } else {
                    [SysTool showErrorWithMsg:msg duration:1];
                }
            }];
        } viewCtrl:self];
    }
}

- (IBAction)deleteObjective:(UIButton *)sender {
   [SysTool showTipWithMsg:@"确认要删除当前目标吗" handler:^(UIAlertAction *action) {
       [SysTool showLoadingHUDWithMsg:@"删除中..." duration:0];
       NSMutableDictionary *reqDict = [NSMutableDictionary new];//self.meetingModel.mj_keyValues;
       [reqDict setObject:[StudentInstance shareInstance].student_realname forKey:@"student_username"];
       [[SYHttpTool sharedInstance] deleteEventWithURL:UPLOAD_OBJ primaryKey:self.objInfo.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
           [SysTool dismissHUD];
           if (success) {
               [SysTool showAlertWithMsg:@"删除成功!" handler:^(UIAlertAction *action) {
                   [self.navigationController popViewControllerAnimated:YES];
               } viewCtrl:self];
           } else {
               [SysTool showErrorWithMsg:msg duration:1];
           }
       }];
       
   } viewCtrl:self];
}


#pragma mark Private Methods
-(void)switchOnEditMode:(BOOL)whetherOn {
    [self.switchEditModeBtn setTitle:(whetherOn == YES)?@"完成":@"编辑" forState:UIControlStateNormal];
    self.staffCommentTextView.editable           = (whetherOn == YES)?YES:NO;
    self.contentTF.userInteractionEnabled        = (whetherOn == YES)?YES:NO;
    self.editStartDateBtn.userInteractionEnabled = (whetherOn == YES)?YES:NO;
    self.editEndDateBtn.userInteractionEnabled   = (whetherOn == YES)?YES:NO;
    
    self.editCommentImg.hidden   = (whetherOn == NO)?YES:NO;
    self.editContentImg.hidden   = (whetherOn == NO)?YES:NO;
    self.editStartDateImg.hidden = (whetherOn == NO)?YES:NO;
    self.editEndDateImg.hidden   = (whetherOn == NO)?YES:NO;
    self.modifyBtnContainerView.hidden = (whetherOn == NO)?YES:NO;
    self.deleteObjBtn.hidden     = (whetherOn == NO)?YES:NO;
}

-(BOOL)judgeLegalInput {
    self.staffCommentTextView.text = [SysTool TrimSpaceString:self.staffCommentTextView.text];
    self.contentTF.text = [SysTool TrimSpaceString:self.contentTF.text];
    BOOL whetherContentEmpty   = (self.contentTF.text.length == 0)?YES:NO;
    BOOL whetherStaffCommentEmpty = ([self.staffCommentTextView.text isEqualToString:COMNENT_HOLDER] || self.staffCommentTextView.text.length == 0)?YES:NO;
    
    // 判断起始时间是否超过结束时间
    NSDate *startDate = [self.dateformatter dateFromString:self.beginDateLB.text];
    NSDate *endDate = [self.dateformatter dateFromString:self.endDateLB.text];
    if ([startDate timeIntervalSinceDate:endDate] > 0) {
        [SysTool showErrorWithMsg:@"开始时间不能超过结束时间!" duration:2];
        return NO;
    }
    
    if (whetherContentEmpty) {
        [SysTool showErrorWithMsg:@"内容不能为空!" duration:1];
        return NO;
    } else if(self.contentTF.text.length > 15){
        [SysTool showErrorWithMsg:@"内容不能超过15个字!" duration:1];
        return NO;
    }
    
    if (whetherStaffCommentEmpty) {
        [SysTool showErrorWithMsg:@"员工评价不能为空!" duration:1];
        return NO;
    }
    
    return YES;
}


#pragma mark TextView Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.staffCommentTextView && [self.staffCommentTextView.text isEqualToString:COMNENT_HOLDER])
        self.staffCommentTextView.text = @"";
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self.staffCommentTextView) {
        self.staffCommentTextView.text = [SysTool TrimSpaceString:self.staffCommentTextView.text];
        if ([self.staffCommentTextView.text isEqualToString:@""])
            self.staffCommentTextView.text = COMNENT_HOLDER;
    }
    return YES;
}

@end
