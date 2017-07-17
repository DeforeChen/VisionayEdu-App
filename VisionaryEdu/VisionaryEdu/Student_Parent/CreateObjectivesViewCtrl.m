//
//  CreateObjectivesViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/17.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CreateObjectivesViewCtrl.h"
#import "config.h"
#import "UIColor+expanded.h"

#define STARTDATE_HOLDER @"点击选择起始时间"
#define ENDDATE_HOLDER   @"点击选择结束时间"
#define COMNENT_HOLDER   @"请输入评价"

@interface CreateObjectivesViewCtrl ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *startTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLB;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UITextView *staffCommentTextView;

@property (weak, nonatomic) IBOutlet UIButton *addObjBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong,nonatomic) NSDateFormatter *dateformatter;
@property (assign,nonatomic) BOOL whetherSelectStart;
@end

@implementation CreateObjectivesViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addObjBtn.layer.cornerRadius = 6.0;
    self.addObjBtn.clipsToBounds = YES;
    
    self.datePicker.alpha = 0.0f;
    self.confirmBtn.alpha = 0.0f;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"#43434D"].CGColor;
    self.confirmBtn.layer.borderWidth = 1.0;
    self.confirmBtn.layer.cornerRadius = 10.0;
    self.confirmBtn.clipsToBounds = YES;

    self.dateformatter = [[NSDateFormatter alloc] init];
    [self.dateformatter setDateFormat:@"yyyy-MM-dd"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UserInteraction
- (IBAction)selectBeginDate:(id)sender {
    [self.view endEditing:YES];
    self.whetherSelectStart = YES;
    // 对当前datepicker 赋值
    NSString *currentDate = [SysTool fetchCurrentDateTimeWithFormat:@"yyyy-MM-dd"];
    if ([self.startTimeLB.text isEqualToString:STARTDATE_HOLDER]) {
        self.datePicker.date = [self.dateformatter dateFromString:currentDate];
    } else
        self.datePicker.date = [self.dateformatter dateFromString:self.startTimeLB.text];
    
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
    NSString *currentDate = [SysTool fetchCurrentDateTimeWithFormat:@"yyyy-MM-dd"];
    if ([self.endTimeLB.text isEqualToString:ENDDATE_HOLDER]) {
        self.datePicker.date = [self.dateformatter dateFromString:currentDate];
    } else
        self.datePicker.date = [self.dateformatter dateFromString:self.endTimeLB.text];
    
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
        self.startTimeLB.text = date;
    } else
        self.endTimeLB.text = date;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.datePicker.alpha = 0.0f;
        self.confirmBtn.alpha = 0.0f;
    }];
}

- (IBAction)appendNewObjectives:(UIButton *)sender {
    if ([self judgeLegalInput]) {
        [SysTool showTipWithMsg:@"确认上送吗?" handler:^(UIAlertAction *action) {
            [SysTool showLoadingHUDWithMsg:@"目标数据上送中..." duration:0];
            NSDictionary *reqDict = @{@"student_username":[StudentInstance shareInstance].student_realname,
                                      @"begin_date": self.startTimeLB.text,
                                      @"end_date": self.endTimeLB.text,
                                      @"objective": self.contentTF.text,
                                      @"staff_comment": self.staffCommentTextView.text
                                      };
            [[SYHttpTool sharedInstance] addEventWithURL:UPLOAD_OBJ token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"添加新目标成功!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } viewCtrl:self];
                } else {
                    [SysTool showErrorWithMsg:msg duration:1];
                }
            }];
        } viewCtrl:self];
    }
}


-(BOOL)judgeLegalInput {
    self.staffCommentTextView.text = [SysTool TrimSpaceString:self.staffCommentTextView.text];
    self.contentTF.text = [SysTool TrimSpaceString:self.contentTF.text];

    BOOL whetherStartDateEmpty = [self.startTimeLB.text isEqualToString:STARTDATE_HOLDER]?YES:NO;
    BOOL whetherEndDateEmpty   = [self.endTimeLB.text isEqualToString:ENDDATE_HOLDER]?YES:NO;
    BOOL whetherContentEmpty   = (self.contentTF.text.length == 0)?YES:NO;
    BOOL whetherStaffCommentEmpty = ([self.staffCommentTextView.text isEqualToString:COMNENT_HOLDER] || self.staffCommentTextView.text.length == 0)?YES:NO;
    
    if (whetherStartDateEmpty || whetherEndDateEmpty) {
        [SysTool showErrorWithMsg:@"起止日期不能为空!" duration:1];
        return NO;
    }
    
    // 判断起始时间是否超过结束时间
    NSDate *startDate = [self.dateformatter dateFromString:self.startTimeLB.text];
    NSDate *endDate = [self.dateformatter dateFromString:self.endTimeLB.text];
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
