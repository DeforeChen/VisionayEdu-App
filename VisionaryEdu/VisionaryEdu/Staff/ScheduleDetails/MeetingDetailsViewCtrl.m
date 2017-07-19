//
//  MeetingDetailsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/11.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "MeetingDetailsViewCtrl.h"
#import "StaffScheduleModel.h"
#import "UIColor+expanded.h"
#import "DatePickerViewController.h"
#import "StaffScheduleInventionsViewCtrl.h"
#import <MJExtension/MJExtension.h>
#import "config.h"

@interface MeetingDetailsViewCtrl ()
@property (assign,nonatomic) BOOL whether_editMode;
@property (weak, nonatomic) IBOutlet UIButton *editTopicBtn;
@property (weak, nonatomic) IBOutlet UIButton *editDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *editPlaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *editDetailsBtn;
@property (weak, nonatomic) IBOutlet UIButton *editInventedGuysBtn;
@property (weak, nonatomic) IBOutlet UIButton *guySelectBtn;

@property (weak, nonatomic) IBOutlet UITextView *topicTextView;
@property (weak, nonatomic) IBOutlet UITextView *placeTextView;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UITextView *staffListTextView;
@property (weak, nonatomic) IBOutlet UIButton *comittBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteScheduleBtn;

@end

@implementation MeetingDetailsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whether_editMode = NO;
    self.comittBtn.layer.cornerRadius = 6.0f;
    self.comittBtn.clipsToBounds      = YES;
    
    [self switchEditModeUI];
    
    self.topicTextView.text = self.meetingModel.topic;
    self.placeTextView.text = self.meetingModel.place;
    self.detailsTextView.text = self.meetingModel.details;
    self.dateLB.text = [NSString stringWithFormat:@"%@ %@",self.meetingModel.date,[self.meetingModel.time substringToIndex:5]];
    self.staffListTextView.text = [self.meetingModel.staff_all componentsJoinedByString:@" "];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchEditModeUI {
    BOOL edit = self.whether_editMode;
    self.staffListTextView.editable = NO;
    self.editTopicBtn.hidden   = (edit == YES)?NO:YES;
    self.editDateBtn.hidden    = (edit == YES)?NO:YES;
    self.editPlaceBtn.hidden   = (edit == YES)?NO:YES;
    self.editDetailsBtn.hidden = (edit == YES)?NO:YES;
    self.comittBtn.hidden      = (edit == YES)?NO:YES;
    self.editInventedGuysBtn.hidden = (edit == YES)?NO:YES;
    self.deleteScheduleBtn.hidden = (edit == YES)?NO:YES;
    
    self.detailsTextView.editable = (edit)?YES:NO;
    self.topicTextView.userInteractionEnabled = (edit)?YES:NO;
    self.placeTextView.userInteractionEnabled = (edit)?YES:NO;
    self.dateSelectBtn.userInteractionEnabled = (edit)?YES:NO;
    self.guySelectBtn.userInteractionEnabled = (edit)?YES:NO;
}

#pragma mark UserInteraction
- (IBAction)switchEditMode:(UIButton *)sender {
    self.whether_editMode = !self.whether_editMode;
    [self switchEditModeUI];
    if (self.whether_editMode == YES) { //进入编辑模式
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    } else
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
}

- (IBAction)commitAndUpload:(UIButton *)sender {
    if ([self juedgeInputLegal]) {
        [SysTool showTipWithMsg:@"确认上送吗?" handler:^(UIAlertAction *action) {
            self.meetingModel.topic = self.topicTextView.text;
            self.meetingModel.date = [self.dateLB.text substringToIndex:10];
            self.meetingModel.time = [self.dateLB.text substringFromIndex:11];
            self.meetingModel.place = self.placeTextView.text;
            self.meetingModel.details = self.detailsTextView.text;
            [SysTool showLoadingHUDWithMsg:@"正在上送新的会议日程信息..." duration:0];
            NSMutableDictionary *reqDict = self.meetingModel.mj_keyValues;
            [reqDict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
            [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_MEETING primaryKey:self.meetingModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
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
    StaffScheduleInventionsViewCtrl *vc = [StaffScheduleInventionsViewCtrl initMyViewCtrlWithUseMode:ModifyMode scheduleTypeUnderModifyMode:MeetingType guysHaveBeenIncluded:self.meetingModel.staff_all createCallback:nil modifyCallback:^(NSArray *selectGuys) {
        self.meetingModel.staff_all = selectGuys;
        self.staffListTextView.text = [selectGuys componentsJoinedByString:@" "];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteSchedule:(UIButton *)sender {
    [SysTool showTipWithMsg:@"确认要删除当前事件吗?" handler:^(UIAlertAction *action) {
        [SysTool showLoadingHUDWithMsg:@"上送删除信息中..." duration:0];
        NSMutableDictionary *reqDict = [NSMutableDictionary new];
        [reqDict setObject:[LoginInfoModel fetchAccountUsername] forKey:@"username"];
        [[SYHttpTool sharedInstance] deleteEventWithURL:UPLOAD_MEETING primaryKey:self.meetingModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
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


-(BOOL)juedgeInputLegal {
    self.topicTextView.text = [SysTool TrimSpaceString:self.topicTextView.text];
    self.placeTextView.text = [SysTool TrimSpaceString:self.placeTextView.text];
    self.detailsTextView.text = [SysTool TrimSpaceString:self.detailsTextView.text];
    
    if (self.topicTextView.text.length == 0) {
        [SysTool showErrorWithMsg:@"主题不能为空!" duration:1];
        return NO;
    }
    
    if (self.detailsTextView.text.length == 0) {
        [SysTool showErrorWithMsg:@"详情不能为空!" duration:1];
        return NO;
    }
    
    // 判断长度
    if (self.topicTextView.text.length > 15) {
        [SysTool showErrorWithMsg:@"主题长度不能超过15!" duration:1];
        return NO;
    }
    
    if (self.placeTextView.text.length > 25) {
        [SysTool showErrorWithMsg:@"地点长度不能超过25!" duration:1];
        return NO;
    }
    
    return YES;
}

@end
