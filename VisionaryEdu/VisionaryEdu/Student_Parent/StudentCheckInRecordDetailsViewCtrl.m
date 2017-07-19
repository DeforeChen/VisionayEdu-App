//
//  StudentCheckInRecordDetailsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/18.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentCheckInRecordDetailsViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "TabBarManagerViewCtrl.h"
#import "DatePickerViewController.h"

@interface StudentCheckInRecordDetailsViewCtrl ()
@property (weak, nonatomic) IBOutlet UIButton *switchEditModeBtn;
@property (assign,nonatomic) BOOL whethetEditMode;
@end

@implementation StudentCheckInRecordDetailsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whethetEditMode = NO;
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        self.switchEditModeBtn.hidden = NO;
    } else
        self.switchEditModeBtn.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchEditMode:(UIButton *)sender {
    NSString *myName = [LoginInfoModel fetchRealNameFromSandbox];
    NSString *consultantName = self.recordModel.staff_real_name;
    if (![myName isEqualToString:consultantName]) {
        NSString *alterMsg = [NSString stringWithFormat:@"您不是%@本次约谈的顾问哦!",[StudentInstance shareInstance].student_realname];
        [SysTool showAlertWithMsg:alterMsg handler:nil viewCtrl:self];
        return;
    }
    
    self.whethetEditMode = !self.whethetEditMode;
    [self.switchEditModeBtn setTitle:self.whethetEditMode?@"完成":@"编辑"
                            forState:UIControlStateNormal];
    StudentCheckInRecordDetailsCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell switchOnEditMode:self.whethetEditMode];
}

- (IBAction)editOverTime:(UIButton *)sender {
    StudentCheckInRecordDetailsCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSTimeInterval duration = (NSTimeInterval)[cell.overTimeLB.text floatValue]*60*60;
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDuration:duration callback:^(NSString *lastTime) {
        cell.overTimeLB.text = lastTime;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)commitIndividualComment:(UIButton *)sender {
    StudentCheckInRecordDetailsCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell trimIndividualCmmtSpace];
    
    NSMutableDictionary *reqDict = [@{@"appointment":[NSNumber numberWithInteger:self.recordModel.pk],
                              @"student_username":[StudentInstance shareInstance].student_realname,
                              @"individual_comment":cell.individualComment.text,
                              @"extra_duration": (cell.overTimeLB.text.length == 0)?@"0":cell.overTimeLB.text,
                              @"pk":[NSNumber numberWithInteger:self.recordModel.student_schedule_pk],
                              @"username": [LoginInfoModel fetchAccountUsername]
                              } mutableCopy];
    if (self.recordModel.student_schedule_pk == -1) {
        [reqDict removeObjectForKey:@"pk"];
        XLog(@"从新添加");
        [SysTool showTipWithMsg:@"确认提交吗?" handler:^(UIAlertAction *action) {
            [SysTool showLoadingHUDWithMsg:@"正在上送单独评价..." duration:0];
            [[SYHttpTool sharedInstance] addEventWithURL:UPLOAD_INDIVIDUAL_CMMT token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"添加个人评论成功!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } viewCtrl:self];
                } else {
                    [SysTool showAlertWithMsg:msg handler:nil viewCtrl:self];
                }
            }];
        } viewCtrl:self];
    } else {
        XLog(@"修改添加");
        [SysTool showTipWithMsg:@"确认提交吗?" handler:^(UIAlertAction *action) {
            [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_INDIVIDUAL_CMMT primaryKey:self.recordModel.student_schedule_pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"添加个人评论成功!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } viewCtrl:self];
                } else {
                    [SysTool showAlertWithMsg:msg handler:nil viewCtrl:self];
                }
            }];
        } viewCtrl:self];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 566;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentCheckInRecordDetailsCell *cell = [StudentCheckInRecordDetailsCell initMyCellWithTableView:tableView CheckInRecord:self.recordModel];
    return cell;
}
@end


@interface StudentCheckInRecordDetailsCell()
@property (weak, nonatomic) IBOutlet UITextView *topicTextView;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UITextView *totalComment;
@property (weak, nonatomic) IBOutlet UIButton *editIndiCmmtImg;
@property (weak, nonatomic) IBOutlet UIImageView *editOverTimeImg;
@property (weak, nonatomic) IBOutlet UILabel *staff_realNameLB;
@property (weak, nonatomic) IBOutlet UIButton *editOverTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation StudentCheckInRecordDetailsCell
+(instancetype)initMyCellWithTableView:(UITableView *)tableview CheckInRecord:(StudentCheckInRecords *)recordModel {
    StudentCheckInRecordDetailsCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    cell.topicTextView.text  = recordModel.topic;
    cell.lastTimeLB.text     = recordModel.duration;
    cell.dateLB.text         = [NSString stringWithFormat:@"%@ %@",recordModel.date,recordModel.time];
    cell.totalComment.text       = recordModel.staff_comment;
    cell.individualComment.text  = recordModel.individual_comment;
    cell.individualComment.editable = NO;//默认先设置成NO
    cell.editOverTimeBtn.userInteractionEnabled = NO;
    cell.editIndiCmmtImg.hidden  = YES;
    cell.editOverTimeImg.hidden  = YES;
    cell.staff_realNameLB.text   = recordModel.staff_real_name;
    cell.overTimeLB.text         = (recordModel.extra_duration.length == 0)?@"0":recordModel.extra_duration;
    
    cell.commitBtn.alpha = 0.0f;
    cell.commitBtn.layer.cornerRadius = 6.0f;
    cell.commitBtn.clipsToBounds = YES;
    return cell;
}

-(void)switchOnEditMode:(BOOL)onEditMode {
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        self.editIndiCmmtImg.hidden = onEditMode?NO:YES;
        self.editOverTimeImg.hidden = onEditMode?NO:YES;
        self.individualComment.editable = onEditMode?YES:NO;
        self.editOverTimeBtn.userInteractionEnabled = onEditMode?YES:NO;
    } else {
        self.editIndiCmmtImg.hidden = YES;
        self.editOverTimeImg.hidden = YES;
        self.individualComment.editable = NO;
        self.editOverTimeBtn.userInteractionEnabled = NO;
    }

    if (onEditMode == YES && self.commitBtn.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.commitBtn.alpha = 1.0f;
        }];
    } else if(onEditMode == NO && self.commitBtn.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.commitBtn.alpha = 0.0f;
        }];
    }
}

-(void)trimIndividualCmmtSpace {
    self.individualComment.text = [SysTool TrimSpaceString:self.individualComment.text];
    self.topicTextView.text     = [SysTool TrimSpaceString:self.topicTextView.text];
}
@end
