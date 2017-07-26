//
//  GradeDetailsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "GradeDetailsViewCtrl.h"
#import "config.h"

#import <MJExtension/MJExtension.h>
#import "TabBarManagerViewCtrl.h"
#import "UIColor+expanded.h"
#import "DatePickerViewController.h"
#import "RecordGradeViewCtrl.h"
#import "StudentScoreInDetailsModel.h"
#import "GradeModelForUpload.h"

@interface GradeDetailsViewCtrl ()
@property (assign,nonatomic) BOOL whetherEditMode;
@property (copy,nonatomic) NSString *testURL;
@property (nonatomic,assign) BOOL whetherFilled;
@property (nonatomic,assign) BOOL whetherUnderGradeCheckMode;//单独为了在“成绩”的查询详情页面跳转过来用的接口
@end

@implementation GradeDetailsViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F9"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(instancetype)initMyViewCtrlWithWhetherUnderGradeCheckMode:(BOOL)whether {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GradeDetailsViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.whetherUnderGradeCheckMode = whether;
    return vc;
}

#pragma mark Getter
-(NSMutableDictionary *)gradeDict {
    if (_gradeDict == nil)
        _gradeDict = [NSMutableDictionary new];
    return _gradeDict;
}

#pragma mark UserInteraction
- (IBAction)switchEditMode:(UIButton *)sender {
    self.whetherEditMode = !self.whetherEditMode;
    [sender setTitle:self.whetherEditMode?@"完成":@"编辑" forState:UIControlStateNormal];
    gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell switchEditMode:self.whetherEditMode];
}

- (IBAction)editDate:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDate *date = [NSDate new];
    if (cell.timeLB.text.length >0 )
        date = [formatter dateFromString:[cell.timeLB.text substringToIndex:16]];
    
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDate:date callback:^(NSString *selectDateStr) {
        cell.timeLB.text = selectDateStr;
    } pickerDateMode:UIDatePickerModeDateAndTime];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkOrRegisterGrade:(UIButton *)sender {
    if (self.whetherUnderGradeCheckMode) { // 页面跳转过来的查看详情时，这里的成绩必须是已经录入的了
        RecordGradeViewCtrl *vc = [RecordGradeViewCtrl initMyViewCtrlWithTestType:self.gradeModel.test_type gradeDict:self.gradeDict callback:^(BOOL whetherFilled, NSDictionary *gradeDetailsDict) {
            gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.whetherFilled = whetherFilled;
            [cell.checkOrRecordGradeBtn setTitle:whetherFilled?@"已填写，点击查看":@"录入" forState:UIControlStateNormal];
            self.gradeDict = [gradeDetailsDict mutableCopy];
        } whetherEditMode:self.whetherEditMode];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (self.gradeModel.whether_record_score == YES) {
            [SysTool showLoadingHUDWithMsg:@"查询成绩单..." duration:0];
            NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username,
                                      @"pk":[NSNumber numberWithInteger:self.gradeModel.test_info_pk]};//test_schedule
            //        NSString *url = [NSString stringWithFormat:@"%@%d/",self.testURL,(int)self.gradeModel.test_info_pk];
            [[SYHttpTool sharedInstance] getReqWithURL:self.testURL token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [self updateGradeDictWithResponseInfo:responseObject];
                    RecordGradeViewCtrl *vc = [RecordGradeViewCtrl initMyViewCtrlWithTestType:self.gradeModel.test_type gradeDict:self.gradeDict callback:^(BOOL whetherFilled, NSDictionary *gradeDetailsDict) {
                        gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        self.whetherFilled = whetherFilled;
                        [cell.checkOrRecordGradeBtn setTitle:whetherFilled?@"已填写，点击查看":@"录入" forState:UIControlStateNormal];
                        self.gradeDict = [gradeDetailsDict mutableCopy];
                    } whetherEditMode:self.whetherEditMode];
                    [self.navigationController pushViewController:vc animated:YES];
                } else
                    [SysTool showErrorWithMsg:msg duration:1];
            }];
        } else {
            RecordGradeViewCtrl *vc = [RecordGradeViewCtrl initMyViewCtrlWithTestType:self.gradeModel.test_type gradeDict:self.gradeDict callback:^(BOOL whetherFilled, NSDictionary *gradeDetailsDict) {
                gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                self.whetherFilled = whetherFilled;
                if (self.gradeModel.whether_record_score == NO) { //已录入
                    [cell.checkOrRecordGradeBtn setTitle:whetherFilled?@"已填写，点击查看":@"未录入" forState:UIControlStateNormal];
                }
                self.gradeDict = [gradeDetailsDict mutableCopy];
            } whetherEditMode:self.whetherEditMode];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)updateGradeDictWithResponseInfo:(id)responseObject {
    //    [self.gradeDict removeAllObjects];
    id info = [[responseObject objectForKey:@"results"] objectAtIndex:0];
    switch (self.gradeModel.test_type) {
        case ToeflType: {
            Toefl *toefl = [Toefl mj_objectWithKeyValues:info];
            self.gradeDict[@"A"] = [NSString stringWithFormat:@"%d",(int)toefl.listening_score] ;
            self.gradeDict[@"B"] = [NSString stringWithFormat:@"%d",(int)toefl.speaking_score ] ;
            self.gradeDict[@"C"] = [NSString stringWithFormat:@"%d",(int)toefl.reading_score  ] ;
            self.gradeDict[@"D"] = [NSString stringWithFormat:@"%d",(int)toefl.writing_score  ] ;
            self.gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)toefl.total_score  ] ;
        }
            break;
        case ieltsType:{
            Ielts *ielts = [Ielts mj_objectWithKeyValues:info];
            self.gradeDict[@"A"] = ielts.listening_score ;
            self.gradeDict[@"B"] = ielts.speaking_score  ;
            self.gradeDict[@"C"] = ielts.reading_score   ;
            self.gradeDict[@"D"] = ielts.writing_score   ;
            self.gradeDict[@"total"] = (NSString*)ielts.total_score;
        }
            break;
        case SatType: {
            Sat *sat = [Sat mj_objectWithKeyValues:info];
            self.gradeDict[@"A"]= [NSString stringWithFormat:@"%d",(int)sat.reading_writing_score];//sat.reading_writing_score ;
            self.gradeDict[@"B"]= [NSString stringWithFormat:@"%d",(int)sat.math_score];//sat.math_score            ;
            self.gradeDict[@"C"]= [NSString stringWithFormat:@"%d",(int)sat.essay_score];//sat.essay_score           ;
            self.gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)sat.total_score] ;
        }
            break;
        case ActType: {
            Act *act = [Act mj_objectWithKeyValues:info];
            self.gradeDict[@"A"]= [NSString stringWithFormat:@"%d",(int)act.english_score];
            self.gradeDict[@"B"]= [NSString stringWithFormat:@"%d",(int)act.science_score];
            self.gradeDict[@"C"]= [NSString stringWithFormat:@"%d",(int)act.reading_score];
            self.gradeDict[@"D"]= [NSString stringWithFormat:@"%d",(int)act.math_score];
            self.gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)act.total_score];
        }
            break;
        case Sat2Type: {
            Sat2 *sat2 = [Sat2 mj_objectWithKeyValues:info];
            self.gradeDict[@"A"] = sat2.subject;
            self.gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)sat2.total_score];
        }
            break;
        case APType: {
            Ap *ap = [Ap mj_objectWithKeyValues:info];
            self.gradeDict[@"A"] = ap.subject;
            self.gradeDict[@"total"] =  [NSString stringWithFormat:@"%d",(int)ap.total_score];
        }
            break;
    }
}

- (IBAction)commitGradeScheduleModification:(UIButton *)sender {
    NSString *tipMsg = @"";
    if (self.gradeModel.whether_record_score == NO && self.whetherFilled == NO) {
        tipMsg = @"您有成绩未填写，确认提交考试日程吗？";
        [SysTool showTipWithMsg:tipMsg handler:^(UIAlertAction *action) {
            //直接上送考试日程
            //2.继续上送日程
            [SysTool showLoadingHUDWithMsg:@"上送日程中" duration:0];
            gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            NSDictionary *futureTestScheduleDict = @{@"student_username":[StudentInstance shareInstance].student_realname,
                                                     @"test_type":[NSNumber numberWithInteger:self.gradeModel.test_type],
                                                     @"date":[cell.timeLB.text substringToIndex:10],
                                                     @"time":[cell.timeLB.text substringFromIndex:11],
                                                     @"place":cell.placeTF.text,
                                                     @"student_comment":cell.selfCommentLB.text,
                                                     @"staff_comment":cell.staffCommentLB.text,
                                                     @"details":cell.detailTextView.text};
            [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_FUTURETEST primaryKey:self.gradeModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:futureTestScheduleDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"修改成功!" handler:^(UIAlertAction *action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } viewCtrl:self];
                }else
                    [SysTool showErrorWithMsg:msg duration:1];
            }];
        } viewCtrl:self];
    } else  {// 剩下
        tipMsg = @"确认修改考试日程吗？";
        // 1. 先产生日程，然后用这个日程返回的test_schedule_pk去录入成绩
        [SysTool showTipWithMsg:tipMsg handler:^(UIAlertAction *action) {
            gradeDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [SysTool showLoadingHUDWithMsg:@"上送日程中..." duration:0];
            NSDictionary *dict = @{@"student_username":[StudentInstance shareInstance].student_realname,
                                   @"test_type":[NSNumber numberWithInteger:self.gradeModel.test_type],
                                   @"date":[cell.timeLB.text substringToIndex:10],//[self.dateBtn.titleLabel.text substringToIndex:10],
                                   @"time":[cell.timeLB.text substringFromIndex:11],
                                   @"student_comment":cell.selfCommentLB.text,
                                   @"staff_comment":cell.staffCommentLB.text,
                                   @"place":cell.placeTF.text,
                                   @"details":cell.detailTextView.text};
            [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_FUTURETEST primaryKey:self.gradeModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:dict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    //2.创建日程成功后，获取到pk然后再进一步去创建成绩
                    NSNumber *test_schedule_id = [responseObject objectForKey:@"pk"];
                    NSMutableDictionary *reqDict = [self generateCorrespondingTestInfo];
                    [reqDict setObject:test_schedule_id forKey:@"test_schedule"];
                    
                    [SysTool showLoadingHUDWithMsg:@"上送成绩中..." duration:0];
                    // 2.1 若是未登记的，就去POST，否则用Patch
                    if (self.gradeModel.whether_record_score == NO) {
                        [reqDict setObject:test_schedule_id forKey:@"test_schedule"];
                        [[SYHttpTool sharedInstance] addEventWithURL:self.testURL token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                            [SysTool dismissHUD];
                            if (success) {
                                [SysTool showAlertWithMsg:@"修改成功!" handler:^(UIAlertAction *action) {
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                } viewCtrl:self];
                            } else
                                [SysTool showErrorWithMsg:msg duration:1];
                        }];
                    } else { // 用patch 修改
                        [[SYHttpTool sharedInstance] patchEventWithURL:self.testURL primaryKey:self.gradeModel.test_info_pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                            if (success) {
                                [SysTool showAlertWithMsg:@"修改成功!" handler:^(UIAlertAction *action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                } viewCtrl:self];
                            } else
                                [SysTool showErrorWithMsg:msg duration:1];
                        }];
                    }
                }else
                    [SysTool showErrorWithMsg:msg duration:1];
            }];
        } viewCtrl:self];
    }
}

-(NSMutableDictionary*)generateCorrespondingTestInfo {
    NSMutableDictionary *reqDict = [@{@"username":[StudentInstance shareInstance].student_realname} mutableCopy];
    switch (self.gradeModel.test_type) {
        case ToeflType: {
            ToeflUpload *toefl = [ToeflUpload new];
            toefl.listening_score = [self.gradeDict[@"A"] integerValue];
            toefl.speaking_score  = [self.gradeDict[@"B"] integerValue];
            toefl.reading_score   = [self.gradeDict[@"C"] integerValue];
            toefl.writing_score   = [self.gradeDict[@"D"] integerValue];
            toefl.total_score     = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[toefl mj_keyValuesWithIgnoredKeys:@[@"color"]]];
        }
            break;
        case ieltsType:{
            IeltsUpload *ielts = [IeltsUpload new];
            ielts.listening_score = self.gradeDict[@"A"];
            ielts.speaking_score  = self.gradeDict[@"B"];
            ielts.reading_score   = self.gradeDict[@"C"];
            ielts.writing_score   = self.gradeDict[@"D"];
            ielts.total_score     = self.gradeDict[@"total"];
            [reqDict addEntriesFromDictionary:[ielts mj_keyValuesWithIgnoredKeys:@[@"color"]]];
        }
            break;
        case SatType: {
            SatUpload *sat = [SatUpload new];
            sat.reading_writing_score = [self.gradeDict[@"A"] integerValue];//批判性阅读写作
            sat.math_score            = [self.gradeDict[@"B"] integerValue];
            sat.essay_score           = [self.gradeDict[@"C"] integerValue];
            sat.total_score           = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[sat mj_keyValuesWithIgnoredKeys:@[@"color"]]];
        }
            break;
        case ActType: {
            ActUpload *act = [ActUpload new];
            act.english_score = [self.gradeDict[@"A"] integerValue];
            act.science_score = [self.gradeDict[@"B"] integerValue];
            act.reading_score = [self.gradeDict[@"C"] integerValue];
            act.math_score    = [self.gradeDict[@"D"] integerValue];
            act.total_score   = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[act mj_keyValuesWithIgnoredKeys:@[@"color"]]];
        }
            break;
        case Sat2Type: {
            Sat2Upload *sat2 = [Sat2Upload new];
            sat2.subject = self.gradeDict[@"A"];
            sat2.total_score  = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[sat2 mj_keyValuesWithIgnoredKeys:@[@"color"]]];
        }
            break;
        case APType: {
            ApUpload *ap = [ApUpload new];
            ap.subject = self.gradeDict[@"A"];
            ap.total_score     = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[ap mj_keyValuesWithIgnoredKeys:@[@"color"]]];
        }
            break;
    }
    XLog(@"上送的成绩信息内容 = %@",reqDict);
    return reqDict;
}

- (IBAction)deleteTestSchedule:(UIButton *)sender {
    [SysTool showTipWithMsg:@"确认删除当前考试吗?" handler:^(UIAlertAction *action) {
        [SysTool showLoadingHUDWithMsg:@"删除中..." duration:0];
        NSDictionary *reqDict = nil;//@{@"student_username":[LoginInfoModel fetchRealNameFromSandbox]};
        [[SYHttpTool sharedInstance] deleteEventWithURL:UPLOAD_FUTURETEST primaryKey:self.gradeModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                [SysTool showAlertWithMsg:@"删除成功" handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                } viewCtrl:self];
            } else
                [SysTool showErrorWithMsg:msg duration:1];
        }];
    } viewCtrl:self];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 850;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    gradeDetailCell *cell = (gradeDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"gradeDetail"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 2. 设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:self.gradeModel.date];
    if ([[NSDate new] timeIntervalSinceDate:date] < 0.0f) {
        [cell.checkOrRecordGradeBtn setTitle:@"未考试" forState:UIControlStateNormal];//= @"未考试";
    } else {
        if (self.gradeModel.whether_record_score == NO) {
            [cell.checkOrRecordGradeBtn setTitle:@"未填写，未录入" forState:UIControlStateNormal];
        } else
            [cell.checkOrRecordGradeBtn setTitle:@"已录入，点击查看" forState:UIControlStateNormal];
    }
    
    switch (self.gradeModel.test_type) {
        case ToeflType:
            cell.testTitleLB.text = @"托福";
            self.testURL = TEST_TOEFL;
            break;
        case ieltsType:
            cell.testTitleLB.text = @"雅思";
            self.testURL = TEST_IELTS;
            break;
        case SatType:
            cell.testTitleLB.text = @"SAT";
            self.testURL = TEST_SAT;
            break;
        case ActType:
            cell.testTitleLB.text = @"ACT";
            self.testURL = TEST_ACT;
            break;
        case Sat2Type:
            cell.testTitleLB.text = @"SAT2";
            self.testURL = TEST_SAT2;
            break;
        case APType:
            cell.testTitleLB.text = @"AP考试";
            self.testURL = TEST_AP;
            break;
            //        case IBType:
            //            cell.testTitleLB.text = @"IB考试";
            //            break;
    }
    
    cell.timeLB.text = [NSString stringWithFormat:@"%@ %@",self.gradeModel.date,self.gradeModel.time];
    cell.placeTF.text = self.gradeModel.place;
    
    cell.detailTextView.text = self.gradeModel.details;
    cell.detailTextView.editable = NO;
    cell.selfCommentLB.text = self.gradeModel.student_comment;
    cell.selfCommentLB.editable = NO;
    cell.staffCommentLB.text = self.gradeModel.staff_comment;
    cell.staffCommentLB.editable = NO;
    
    cell.commitEditBtn.layer.cornerRadius = 6.0f;
    cell.commitEditBtn.clipsToBounds = YES;
    [cell switchEditMode:NO];
    return cell;
}

@end


@implementation gradeDetailCell
-(void)switchEditMode:(BOOL)whetherOn {
    self.commitEditBtn.hidden = whetherOn?NO:YES;
    self.deleteBtn.hidden = whetherOn?NO:YES;
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        // 先将所有必定不可编辑的罗列出来
        self.editTimeBtn.userInteractionEnabled = NO;
        self.placeTF.userInteractionEnabled     = NO;
        //成绩录入的接口记得添加
        self.detailTextView.editable = NO;
        self.selfCommentLB.editable  = NO;
        self.staffCommentLB.editable = whetherOn?YES:NO;
        
        // 提示图标是否显示
        self.editTimeImg.hidden = YES;
        self.editPlaceImg.hidden = YES;
        self.editDetailsImg.hidden = YES;
        self.editSelfCmmtImg.hidden = YES;
        self.editStaffCmmtImg.hidden = whetherOn?NO:YES;
    } else {
        self.editTimeBtn.userInteractionEnabled = whetherOn?YES:NO;
        self.placeTF.userInteractionEnabled     = whetherOn?YES:NO;
        //成绩录入的接口记得添加
        self.detailTextView.editable = whetherOn?YES:NO;
        self.selfCommentLB.editable  = whetherOn?YES:NO;
        self.staffCommentLB.editable = NO;
        // 提示图标是否显示
        self.editTimeImg.hidden = whetherOn?NO:YES;
        self.editPlaceImg.hidden = whetherOn?NO:YES;
        self.editDetailsImg.hidden = whetherOn?NO:YES;
        self.editSelfCmmtImg.hidden = whetherOn?NO:YES;
        self.editStaffCmmtImg.hidden = YES;
    }
}
@end
