//
//  CreateStaffScheduleViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/10.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CreateStaffScheduleViewCtrl.h"
#import "UIColor+expanded.h"
#import "StaffScheduleInventionsViewCtrl.h"
#import "StudentScheduleModel.h"
#import "config.h"
#import "StaffListModel.h"
#import "StudentListModel.h"
#import "DatePickerViewController.h"
#import <MJExtension/MJExtension.h>

#define TITILE_HOLDER @"请输入标题"
#define PLACE_HOLDER @"请输入地点"
#define DETAILS_HOLDER @"请输入描述"
#define TIME_HOLDER @"点击后选择时间"
#define TAG_HOLDER @"点击后选择标签"

@interface CreateStaffScheduleViewCtrl ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titleInput;
@property (weak, nonatomic) IBOutlet UITextView *locationInput;
@property (weak, nonatomic) IBOutlet UIButton *addEventBtn;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTypeLB;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectLastTimeBtn;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property (weak, nonatomic) IBOutlet UIView *consultantView;
@property (copy, nonatomic) NSString *consultantGuy;//顾问名称，只在约谈模式下有用
@property (weak, nonatomic) IBOutlet UIButton *editConsultantBtn;

@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSArray *selectGuysArray;
@property (assign,nonatomic) StaffScheduleType type;
@end

@implementation CreateStaffScheduleViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addEventBtn.layer.cornerRadius = 6.0;
    self.addEventBtn.clipsToBounds = YES;
    self.consultantGuy = [LoginInfoModel fetchRealNameFromSandbox];//默认为当前登录的账号
    [self.editConsultantBtn setTitle:[NSString stringWithFormat:@"%@(点击变更)",self.consultantGuy] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getter
-(NSArray *)selectGuysArray {
    if (_selectGuysArray == nil)
        _selectGuysArray = [NSArray new];
    return _selectGuysArray;
}

#pragma mark Userinteraction
- (IBAction)selectDate:(UIButton *)sender {
    [self.view endEditing:YES];
    NSDateFormatter *Dateformatter = [[NSDateFormatter alloc] init];
    [Dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date= [NSDate new];//[NSDate new];
    if (![self.selectTimeBtn.titleLabel.text isEqualToString:@"点击后选择时间"]) {
        date = [Dateformatter dateFromString:self.selectTimeBtn.titleLabel.text];
    } else
        date = nil;
    
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDate:date callback:^(NSString *selectDateStr) {
            NSString *dateTime = selectDateStr;
            self.date = [dateTime substringToIndex:10];
            self.time = [dateTime substringFromIndex:11];
            [self.selectTimeBtn setTitle:dateTime forState:UIControlStateNormal];
//        } else if(self.dateTimePicker.datePickerMode == UIDatePickerModeCountDownTimer) {
//            NSString *countTime = [NSString stringWithFormat:@"%.1f",self.dateTimePicker.countDownDuration/60/60];
//            [self.selectLastTimeBtn setTitle:countTime forState:UIControlStateNormal];
//        }
    } pickerDateMode:UIDatePickerModeDateAndTime];
    [self.navigationController pushViewController:vc animated:YES];
//    self.dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    self.dateTimePicker.minuteInterval = 15;
//    if (self.dateTimePicker.alpha == 0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.dateTimePicker.alpha = 1.0f;
//            self.confirmBtn.alpha = 1.0f;
//        }];
//    }
}

- (IBAction)selectLastTime:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSTimeInterval duration = 30*60;
    if (![self.selectLastTimeBtn.titleLabel.text isEqualToString:@"点击后选择时间"]) {
        duration = [self.selectLastTimeBtn.titleLabel.text floatValue]*60*60;
    }
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDuration:duration callback:^(NSString *lastTime) {
        [self.selectLastTimeBtn setTitle:lastTime forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)appendNewSchedule:(UIButton *)sender {
    if ([self judgeInputLegal]) {
        // 上送数据！
        [SysTool showLoadingHUDWithMsg:@"日程上送中" duration:0];
        NSString *url = (self.type == MeetingType)?UPLOAD_MEETING:UPLOAD_RECORD;
        NSDictionary *reqDict = (self.type == MeetingType)?[self fetchMeetingParams]:[self fetchRecordsParams];
        
        [[SYHttpTool sharedInstance] addEventWithURL:url token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                [SysTool showAlertWithMsg:@"上送日程成功" handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                } viewCtrl:self];
            } else
                [SysTool showAlertWithMsg:msg handler:nil viewCtrl:self];
        }];
    }
}

-(BOOL)judgeInputLegal {
    //判断输入不为空
    self.titleInput.text = [SysTool TrimSpaceString:self.titleInput.text];
    self.locationInput.text = [SysTool TrimSpaceString:self.locationInput.text];
    self.detailTextView.text = [SysTool TrimSpaceString:self.detailTextView.text];

    BOOL whetherTitleEmpty = (self.titleInput.text.length == 0 || [self.titleInput.text isEqualToString:TITILE_HOLDER])?YES:NO;
    BOOL whetherTimeEmpty  = ([self.selectTimeBtn.titleLabel.text isEqualToString:TIME_HOLDER])?YES:NO;
    BOOL whetherTagEmpty   = [self.scheduleTypeLB.text isEqualToString:TAG_HOLDER]?YES:NO;
    BOOL whetherDetailEmpty = ([self.detailTextView.text isEqualToString:DETAILS_HOLDER] || self.detailTextView.text.length == 0)?YES:NO;
    BOOL whetherLastTimeEmpty = YES;
    if ([self.scheduleTypeLB.text isEqualToString:@"约谈"] && ![self.selectLastTimeBtn.titleLabel.text isEqualToString:TIME_HOLDER]) {
        whetherLastTimeEmpty = NO;
    } else if
        ([self.scheduleTypeLB.text isEqualToString:@"会议及茶话会"])
        whetherLastTimeEmpty = NO;
    
    if (whetherTitleEmpty) {
        [SysTool showErrorWithMsg:@"日程标题不能为空!" duration:1];
        return NO;
    }
    if (whetherTimeEmpty) {
        [SysTool showErrorWithMsg:@"日程时间不能为空!" duration:1];
        return NO;
    }
    if (whetherLastTimeEmpty) {
        [SysTool showErrorWithMsg:@"学生约谈预估时间不能为空!" duration:2];
        return NO;
    }
    if (whetherTagEmpty) {
        [SysTool showErrorWithMsg:@"请选择日程类别!" duration:1];
        return NO;
    }
    if (whetherDetailEmpty) {
        [SysTool showErrorWithMsg:@"日程详情不能为空!" duration:1];
        return NO;
    }
    
    // 判断输入是否超长
    if (![self.titleInput.text isEqualToString:TITILE_HOLDER] && self.titleInput.text.length > 15) {
        [SysTool showErrorWithMsg:@"标题长度不能超过15个字!" duration:1];
        return NO;
    }
    
    if (self.locationInput.text.length > 25) {
        [SysTool showErrorWithMsg:@"地址长度不能超过25个字！" duration:1];
        return NO;
    }
    return YES;
}

-(NSDictionary*)fetchMeetingParams {
    Meetings *meetingModel = [Meetings new];
    meetingModel.details = self.detailTextView.text;
    meetingModel.time = self.time;
    meetingModel.date = self.date;
    meetingModel.topic = self.titleInput.text;
    meetingModel.place = [self.locationInput.text isEqualToString:PLACE_HOLDER]?@"":self.locationInput.text;
    meetingModel.staff_all = self.selectGuysArray;
    NSMutableDictionary *dict = meetingModel.mj_keyValues;
    [dict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
    return dict;
}

-(NSDictionary*)fetchRecordsParams {
    StaffCheckInRecords *recordModel = [StaffCheckInRecords new];
    recordModel.time = self.time;
    recordModel.student_all = self.selectGuysArray;
    recordModel.date = self.date;
    recordModel.topic = self.titleInput.text;
    recordModel.duration = self.selectLastTimeBtn.titleLabel.text;
    recordModel.staff_username = self.consultantGuy;
    NSMutableDictionary *dict = recordModel.mj_keyValues;
    [dict setObject:self.consultantGuy forKey:@"username"];
    return dict;
}

#pragma mark - Navigation
- (IBAction)jump:(UIButton *)sender {
    StaffScheduleInventionsViewCtrl *vc = [StaffScheduleInventionsViewCtrl initMyViewCtrlWithUseMode:CreateMode scheduleTypeUnderModifyMode:NoneType guysHaveBeenIncluded:@[[LoginInfoModel fetchRealNameFromSandbox]] createCallback:^(StaffScheduleType type, NSArray *selectGuys) {
        if (type == MeetingType) {
            self.scheduleTypeLB.text = @"会议及茶话会";
        } else {
            self.scheduleTypeLB.text = @"约谈";
            self.consultantView.hidden = NO;
        }
        self.selectGuysArray = selectGuys;
        NSLog(@"赋值的 selectGuysArray = %@",self.selectGuysArray);
        self.type = type;
    } modifyCallback:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)modifyConsultant:(UIButton *)sender {
    StaffScheduleInventionsViewCtrl *vc = [StaffScheduleInventionsViewCtrl initMyViewCtrlWithUseMode:ModifyConsultantMode scheduleTypeUnderModifyMode:MeetingType guysHaveBeenIncluded:@[] createCallback:nil modifyCallback:^(NSArray *selectGuys) {
        self.consultantGuy = selectGuys[0];
        [self.editConsultantBtn setTitle:[NSString stringWithFormat:@"%@(点击变更)",self.consultantGuy] forState:UIControlStateNormal];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TextView Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.titleInput && [self.titleInput.text isEqualToString:TITILE_HOLDER]) {
        self.titleInput.text = @"";
    } else if(textView == self.locationInput && [self.locationInput.text isEqualToString:PLACE_HOLDER]) {
        self.locationInput.text = @"";
    } else if(textView == self.detailTextView && [self.detailTextView.text isEqualToString:DETAILS_HOLDER])
        self.detailTextView.text = @"";
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self.titleInput) {
        self.titleInput.text = [SysTool TrimSpaceString:self.titleInput.text];
        if ( [self.titleInput.text isEqualToString:@""]) {
            self.titleInput.text = TITILE_HOLDER;
        }
    } else if(textView == self.locationInput) {
        self.locationInput.text = [SysTool TrimSpaceString:self.locationInput.text];
        if ([self.locationInput.text isEqualToString:@""])
            self.locationInput.text = PLACE_HOLDER;
    } else if(textView == self.detailTextView) {
        self.detailTextView.text = [SysTool TrimSpaceString:self.detailTextView.text];
        if ([self.detailTextView.text isEqualToString:@""])
            self.detailTextView.text = DETAILS_HOLDER;
    }
    return YES;
}
@end
