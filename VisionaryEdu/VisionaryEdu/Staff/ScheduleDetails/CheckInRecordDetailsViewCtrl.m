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

@interface CheckInRecordDetailsViewCtrl ()
@property (assign,nonatomic) BOOL whether_editMode;
@property (weak, nonatomic) IBOutlet UIButton *editTopicBtn;
@property (weak, nonatomic) IBOutlet UIButton *editDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *editCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *editInventedStudentBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentSelectBtn;

@property (weak, nonatomic) IBOutlet UITextView *topicTextView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UITextView *studentListTextView;
@property (weak, nonatomic) IBOutlet UIButton *comittBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteScheduleBtn;
@end

@implementation CheckInRecordDetailsViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.whether_editMode = NO;
    self.comittBtn.layer.cornerRadius = 10.0f;
    self.comittBtn.layer.borderColor  = [UIColor colorWithHexString:@"#43434D"].CGColor;
    self.comittBtn.layer.borderWidth  = 1.0f;
    self.comittBtn.clipsToBounds      = YES;
    
    [self switchEditModeUI];
    
    self.topicTextView.text = self.recordModel.topic;
    self.commentTextView.text = self.recordModel.staff_comment;
    self.dateLB.text = [NSString stringWithFormat:@"%@ %@",self.recordModel.date,[self.recordModel.time substringToIndex:5]];
    self.studentListTextView.text = self.recordModel.student_username;//[self.recordModel.student_real_name componentsJoinedByString:@" "];
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

    self.editCommentBtn.hidden = (edit == YES)?NO:YES;
    self.comittBtn.hidden      = (edit == YES)?NO:YES;
    self.editInventedStudentBtn.hidden = (edit == YES)?NO:YES;
    self.deleteScheduleBtn.hidden = (edit == YES)?NO:YES;
    
    self.topicTextView.editable = (edit)?YES:NO;
    self.dateSelectBtn.userInteractionEnabled = (edit)?YES:NO;
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

- (IBAction)jumpToSelectGuysViewCtrl:(UIButton *)sender {
    StaffScheduleInventionsViewCtrl *vc = [StaffScheduleInventionsViewCtrl initMyViewCtrlWithUseMode:ModifyMode scheduleTypeUnderModifyMode:StaffCheckInRecordsType guysHaveBeenIncluded:@[self.recordModel.student_username] createCallback:nil modifyCallback:^(NSArray *selectGuys) {
        self.studentListTextView.text = [selectGuys componentsJoinedByString:@" "];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteSchedule:(UIButton *)sender {
    [SysTool showTipWithMsg:@"确认要删除当前事件吗?" handler:^(UIAlertAction *action) {
        
    } viewCtrl:self];
}

@end
