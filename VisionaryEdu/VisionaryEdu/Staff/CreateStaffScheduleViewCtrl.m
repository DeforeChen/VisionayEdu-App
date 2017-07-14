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
#import <MJExtension/MJExtension.h>

@interface CreateStaffScheduleViewCtrl ()
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UIButton *addEventBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTypeLB;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeLB;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

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
    
    self.confirmBtn.alpha = 0.0f;
    self.confirmBtn.layer.borderColor = [UIColor colorWithHexString:@"#43434D"].CGColor;
    self.confirmBtn.layer.borderWidth = 1.0;
    self.confirmBtn.layer.cornerRadius = 10.0;
    self.confirmBtn.clipsToBounds = YES;
    
    self.dateTimePicker.alpha = 0.0f;
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
    if (self.dateTimePicker.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.dateTimePicker.alpha = 1.0f;
            self.confirmBtn.alpha = 1.0f;
        }];
    }
}

- (IBAction)confirmDateAndTime:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:self.dateTimePicker.date];
    self.date = [dateTime substringToIndex:10];
    self.time = [dateTime substringFromIndex:11];
    [self.selectTimeLB setTitle:dateTime forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.dateTimePicker.alpha = 0.0f;
        self.confirmBtn.alpha = 0.0f;
    }];
}

- (IBAction)appendNewSchedule:(UIButton *)sender {
    //判断输入不为空
    BOOL whetherTitleEmpty = (self.titleInput.text.length == 0)?YES:NO;
    BOOL whetherTimeEmpty  = (self.selectTimeLB.titleLabel.text.length == 0)?YES:NO;
    BOOL whetherTagEmpty   = [self.scheduleTypeLB.text isEqualToString:@"点击后选择标签"]?YES:NO;
    if (whetherTitleEmpty) {
        [SysTool showErrorWithMsg:@"日程主题不能为空!" duration:1];
        return;
    }
    if (whetherTimeEmpty) {
        [SysTool showErrorWithMsg:@"日程时间不能为空!" duration:1];
        return;
    }
    if (whetherTagEmpty) {
        [SysTool showErrorWithMsg:@"请选择日程类别!" duration:1];
        return;
    }
    
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

-(NSDictionary*)fetchMeetingParams {
    Meetings *meetingModel = [Meetings new];
    meetingModel.details = ([self.detailTextView.text isEqualToString:@"请输入描述"])?@"":self.detailTextView.text;
    meetingModel.time = self.time;
    meetingModel.date = self.date;
    meetingModel.topic = self.titleInput.text;
    meetingModel.place = self.locationInput.text;
    meetingModel.staff_all = self.selectGuysArray;
    NSMutableDictionary *dict = meetingModel.mj_keyValues;
    [dict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
    return dict;
}

-(NSDictionary*)fetchRecordsParams {
    // TEST
    Meetings *meetingModel = [Meetings new];
    meetingModel.details = ([self.detailTextView.text isEqualToString:@"请输入描述"])?@"":self.detailTextView.text;
    meetingModel.time = self.time;
    meetingModel.date = self.date;
    meetingModel.topic = self.titleInput.text;
    meetingModel.place = self.locationInput.text;
    meetingModel.staff_all = self.selectGuysArray;
    NSMutableDictionary *dict = meetingModel.mj_keyValues;
    [dict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
    return dict;
}

#pragma mark - Navigation
- (IBAction)jump:(UIButton *)sender {
    StaffScheduleInventionsViewCtrl *vc = [StaffScheduleInventionsViewCtrl initMyViewCtrlWithUseMode:CreateMode scheduleTypeUnderModifyMode:NoneType createCallback:^(StaffScheduleType type, NSArray *selectGuys) {
        if (type == MeetingType) {
            self.scheduleTypeLB.text = @"会议及茶话会";
        } else
            self.scheduleTypeLB.text = @"约谈";
        self.selectGuysArray = selectGuys;
        NSLog(@"赋值的 selectGuysArray = %@",self.selectGuysArray);
        self.type = type;
    } modifyCallback:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
