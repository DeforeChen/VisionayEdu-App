//
//  CheckInRecordDetailsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/11.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CheckInRecordDetailsViewCtrl.h"
#import "StudentScheduleModel.h"
#import "UIColor+expanded.h"
#import "DatePickerViewController.h"
#import "StaffScheduleInventionsViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>

@interface CheckInRecordDetailsViewCtrl ()
@property (assign,nonatomic) BOOL whether_editMode;
@property (weak, nonatomic) IBOutlet UIButton *editTopicBtn;
@property (weak, nonatomic) IBOutlet UIButton *editDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *editCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *editInventedStudentBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *editLastTimeBtn;

@property (weak, nonatomic) IBOutlet UITextView *topicTextView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLB;

@property (weak, nonatomic) IBOutlet UITextView *studentListTextView;
@property (weak, nonatomic) IBOutlet UIButton *comittBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastTimeSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteScheduleBtn;
@end

@implementation CheckInRecordDetailsViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.whether_editMode = NO;
    self.comittBtn.layer.cornerRadius = 6.0f;
    self.comittBtn.layer.borderWidth  = 1.0f;
    self.comittBtn.clipsToBounds      = YES;
    
    [self switchEditModeUI];

    self.lastTimeLB.text    = self.recordModel.duration;
    self.topicTextView.text = self.recordModel.topic;
    self.commentTextView.text = self.recordModel.staff_comment;
    self.dateLB.text = [NSString stringWithFormat:@"%@ %@",self.recordModel.date,[self.recordModel.time substringToIndex:5]];
    self.studentListTextView.text = [self.recordModel.student_all componentsJoinedByString:@","];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchEditModeUI {
    BOOL edit = self.whether_editMode;
    self.studentListTextView.editable = NO;
    self.editTopicBtn.hidden   = (edit == YES)?NO:YES;
    self.editDateBtn.hidden    = (edit == YES)?NO:YES;
    self.editLastTimeBtn.hidden = (edit == YES)?NO:YES;

    self.editCommentBtn.hidden = (edit == YES)?NO:YES;
    self.comittBtn.hidden      = (edit == YES)?NO:YES;
    self.editInventedStudentBtn.hidden = (edit == YES)?NO:YES;
    self.deleteScheduleBtn.hidden = (edit == YES)?NO:YES;
    
    self.topicTextView.editable = (edit)?YES:NO;
    self.dateSelectBtn.userInteractionEnabled = (edit)?YES:NO;
    self.lastTimeSelectBtn.userInteractionEnabled = (edit)?YES:NO;
    self.commentTextView.editable = (edit)?YES:NO;
    self.studentSelectBtn.userInteractionEnabled = (edit)?YES:NO;
}

#pragma mark Getter

#pragma mark UserInteraction
- (IBAction)switchEditMode:(UIButton *)sender {
    self.whether_editMode = !self.whether_editMode;
    [self switchEditModeUI];
    if (self.whether_editMode == YES) { //进入编辑模式
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    } else
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
}

- (IBAction)jumpToDatePickerViewCtrl:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:self.dateLB.text];
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDate:date callback:^(NSString *selectDateStr) {
        self.dateLB.text = selectDateStr;
    } pickerDateMode:UIDatePickerModeDateAndTime];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)jumpToDurationPickerViewCtrl:(UIButton *)sender {
    NSTimeInterval duration = (NSTimeInterval)[self.lastTimeLB.text floatValue]*60*60;
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDuration:duration callback:^(NSString *lastTime) {
        self.lastTimeLB.text = lastTime;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)jumpToSelectGuysViewCtrl:(UIButton *)sender {
    StaffScheduleInventionsViewCtrl *vc = [StaffScheduleInventionsViewCtrl initMyViewCtrlWithUseMode:ModifyMode scheduleTypeUnderModifyMode:StaffCheckInRecordsType guysHaveBeenIncluded:self.recordModel.student_all createCallback:nil modifyCallback:^(NSArray *selectGuys) {
        self.studentListTextView.text = [selectGuys componentsJoinedByString:@","];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)commitStaffRecordModification:(UIButton *)sender {
    self.topicTextView.text = [SysTool TrimSpaceString:self.topicTextView.text];
    self.commentTextView.text = [SysTool TrimSpaceString:self.commentTextView.text];
    
    if (self.topicTextView.text.length == 0) {
        [SysTool showErrorWithMsg:@"约谈主题不能为空!" duration:1];
        return;
    }
    if (self.topicTextView.text.length > 15) {
        [SysTool showErrorWithMsg:@"约谈主题长度不能超过15个字!" duration:1];
        return;
    }
    
    [SysTool showTipWithMsg:@"确认上送吗?" handler:^(UIAlertAction *action) {
        self.recordModel.topic = self.topicTextView.text;
        self.recordModel.date = [self.dateLB.text substringToIndex:10];
        self.recordModel.time = [self.dateLB.text substringFromIndex:11];
        self.recordModel.duration = self.lastTimeLB.text;
        self.recordModel.student_all = [self.studentListTextView.text componentsSeparatedByString:@","];
        [SysTool showLoadingHUDWithMsg:@"正在上送新的员工约谈日程信息..." duration:0];
        NSMutableDictionary *reqDict = self.recordModel.mj_keyValues;
        [reqDict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
        [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_RECORD primaryKey:self.recordModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                [SysTool showAlertWithMsg:@"修改成功!" handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                } viewCtrl:self];
            } else {
                [SysTool showAlertWithMsg:msg handler:nil viewCtrl:self];
            }
        }];
    } viewCtrl:self];
}


- (IBAction)deleteSchedule:(UIButton *)sender {
    [SysTool showTipWithMsg:@"确认要删除当前事件吗?" handler:^(UIAlertAction *action) {
        [SysTool showLoadingHUDWithMsg:@"上送删除信息中..." duration:0];
        NSMutableDictionary *reqDict = [NSMutableDictionary new];
        [reqDict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
        [[SYHttpTool sharedInstance] deleteEventWithURL:UPLOAD_RECORD primaryKey:self.recordModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                [SysTool showAlertWithMsg:@"删除成功!" handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                } viewCtrl:self];
            } else {
                [SysTool showAlertWithMsg:msg handler:nil viewCtrl:self];
            }
        }];
    } viewCtrl:self];
}

@end
