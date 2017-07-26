//
//  CreateTestScheduleViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/21.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CreateTestScheduleViewCtrl.h"
#import "DatePickerViewController.h"
#import "HWDownSelectedView.h"
#import "StudentScheduleModel.h"
#import "StudentScoreInDetailsModel.h"
#import "UIColor+expanded.h"
#import "RecordGradeViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "TabBarManagerViewCtrl.h"
#import "GradeModelForUpload.h"

@interface CreateTestScheduleViewCtrl ()<HWDownSelectedViewDelegate>
@property (weak, nonatomic) IBOutlet HWDownSelectedView *testTypeSelectView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UIButton *GradeIndicatorBtn;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UIButton *createTestBtn;
@property (nonatomic,assign) TestType testType;
@property (copy,nonatomic) NSString *uploadTestURL;
@property (copy,nonatomic) NSDictionary *gradeDict;//录入的成绩信息
@end

@implementation CreateTestScheduleViewCtrl
+(instancetype)initMyViewCtrl {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateTestScheduleViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createTestBtn.layer.cornerRadius = 6.0f;
    self.createTestBtn.clipsToBounds = YES;
    self.testType = ToeflType;
    [self initOptionView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initOptionView {
        self.testTypeSelectView.placeholder = @"托福";
        self.testTypeSelectView.listArray   = @[@"托福",@"雅思",@"SAT",@"ACT",@"SAT2",@"AP",@"Custom"];
        self.testTypeSelectView.delegate    = self;
        [self.testTypeSelectView setTextColor:[UIColor colorWithHexString:@"#B0B1B8"]];
}

#pragma mark UserInteractions
- (IBAction)jumpToDatePicker:(UIButton *)sender {
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDate:[NSDate new] callback:^(NSString *selectDateStr) {
        [self.dateBtn setTitle:selectDateStr forState:UIControlStateNormal];
    } pickerDateMode:UIDatePickerModeDateAndTime];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkOrRecordGrade:(UIButton *)sender {
    RecordGradeViewCtrl *vc = [RecordGradeViewCtrl initMyViewCtrlWithTestType:self.testType gradeDict:self.gradeDict callback:^(BOOL whetherFilled, NSDictionary *gradeDetailsDict) {
        [self.GradeIndicatorBtn setTitle:whetherFilled?@"已填写，点击查看":@"点击填写" forState:UIControlStateNormal];
        self.gradeDict = gradeDetailsDict;
    } whetherEditMode:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)createTestSchedule:(UIButton *)sender {
    if ([self judgeLegalInput]) {
        NSString *tipMsg = @"";
        if ([self.GradeIndicatorBtn.titleLabel.text isEqualToString:@"已填写，点击查看"]) {
            tipMsg = @"确认提交考试日程吗？";
            // 1. 先产生日程，然后用这个日程返回的test_schedule_pk去录入成绩
            [SysTool showTipWithMsg:tipMsg handler:^(UIAlertAction *action) {
                [SysTool showLoadingHUDWithMsg:@"上送日程中..." duration:0];
                NSDictionary *dict = @{@"student_username":[StudentInstance shareInstance].student_realname,
                                       @"test_type":[NSNumber numberWithInteger:self.testType],
                                       @"date":[self.dateBtn.titleLabel.text substringToIndex:10],
                                       @"time":[self.dateBtn.titleLabel.text substringFromIndex:11],
                                       @"place":self.placeTF.text,
                                       @"details":self.detailsTextView.text};
               [[SYHttpTool sharedInstance] addEventWithURL:UPLOAD_FUTURETEST token:[LoginInfoModel fetchTokenFromSandbox] params:dict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                   [SysTool dismissHUD];
                   if (success) {
                       //2.创建日程成功后，获取到pk然后再进一步去创建成绩
                       NSNumber *test_schedule_id = [responseObject objectForKey:@"pk"];
                       [SysTool showLoadingHUDWithMsg:@"上送成绩中..." duration:0];
                       NSMutableDictionary *reqDict = [self generateCorrespondingTestInfo];
                       [reqDict setObject:test_schedule_id forKey:@"test_schedule"];
                       [[SYHttpTool sharedInstance] addEventWithURL:self.uploadTestURL token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                           [SysTool dismissHUD];
                           if (success) {
                               [SysTool showAlertWithMsg:@"创建成功!" handler:^(UIAlertAction *action) {
                                   [self.navigationController popViewControllerAnimated:YES];
                               } viewCtrl:self];
                           } else
                               [SysTool showErrorWithMsg:msg duration:1];
                       }];
                   }else
                       [SysTool showErrorWithMsg:msg duration:1];
               }];
            } viewCtrl:self];
        } else if([self.GradeIndicatorBtn.titleLabel.text isEqualToString:@"点击填写"]) {
            tipMsg = @"您有成绩未填写，确认提交考试日程吗？";
            [SysTool showTipWithMsg:tipMsg handler:^(UIAlertAction *action) {
                //直接上送考试日程
                //2.继续上送日程
                [SysTool showLoadingHUDWithMsg:@"上送日程中" duration:0];
                NSString *time = [NSString stringWithFormat:@"%@:00",[self.dateBtn.titleLabel.text substringFromIndex:11]];
                NSDictionary *dict = @{@"student_username":[StudentInstance shareInstance].student_realname,
                                       @"test_type":[NSNumber numberWithInteger:self.testType],
                                       @"date":[self.dateBtn.titleLabel.text substringToIndex:10],
                                       @"time":time,//[self.dateBtn.titleLabel.text substringFromIndex:11],
                                       @"place":self.placeTF.text,
                                       @"details":self.detailsTextView.text};
                [[SYHttpTool sharedInstance] addEventWithURL:UPLOAD_FUTURETEST token:[LoginInfoModel fetchTokenFromSandbox] params:dict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                    [SysTool dismissHUD];
                    if (success) {
                        [SysTool showAlertWithMsg:@"创建成功!" handler:^(UIAlertAction *action) {
                            [self.navigationController popViewControllerAnimated:YES];
                        } viewCtrl:self];
                    }else
                        [SysTool showErrorWithMsg:msg duration:1];
                }];
            } viewCtrl:self];
        }
    }
}

-(NSMutableDictionary*)generateCorrespondingTestInfo {
    NSMutableDictionary *reqDict = [@{@"username":[StudentInstance shareInstance].student_realname} mutableCopy];
    switch (self.testType) {
        case ToeflType: {
            ToeflUpload *toefl = [ToeflUpload new];
            toefl.listening_score = [self.gradeDict[@"A"] integerValue];
            toefl.speaking_score  = [self.gradeDict[@"B"] integerValue];
            toefl.reading_score   = [self.gradeDict[@"C"] integerValue];
            toefl.writing_score   = [self.gradeDict[@"D"] integerValue];
            toefl.total_score     = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[toefl mj_keyValuesWithIgnoredKeys:@[@"color"]]];
            self.uploadTestURL = TEST_TOEFL;
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
            self.uploadTestURL = TEST_IELTS;
        }
            break;
        case SatType: {
            SatUpload *sat = [SatUpload new];
            sat.reading_writing_score = [self.gradeDict[@"A"] integerValue];//批判性阅读写作
            sat.math_score            = [self.gradeDict[@"B"] integerValue];
            sat.essay_score           = [self.gradeDict[@"C"] integerValue];
            sat.total_score           = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[sat mj_keyValuesWithIgnoredKeys:@[@"color"]]];
            self.uploadTestURL = TEST_SAT;
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
            self.uploadTestURL = TEST_ACT;
        }
            break;
        case Sat2Type: {
            Sat2Upload *sat2 = [Sat2Upload new];
            sat2.subject = self.gradeDict[@"A"];
            sat2.total_score  = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[sat2 mj_keyValuesWithIgnoredKeys:@[@"color"]]];
            self.uploadTestURL = TEST_SAT2;
        }
            break;
        case APType: {
            ApUpload *ap = [ApUpload new];
            ap.subject = self.gradeDict[@"A"];
            ap.total_score     = [self.gradeDict[@"total"] integerValue];
            [reqDict addEntriesFromDictionary:[ap mj_keyValuesWithIgnoredKeys:@[@"color"]]];
            self.uploadTestURL = TEST_AP;
        }
            break;
    }
    XLog(@"上送的成绩信息内容 = %@",reqDict);
    return reqDict;
}

-(BOOL)judgeLegalInput {
    if ([self.dateBtn.titleLabel.text isEqualToString:@"点击选择时间"]) {
        [SysTool showErrorWithMsg:@"时间未填写" duration:1];
        return NO;
    }
    return YES;
}

#pragma mark Getter
-(NSDictionary *)gradeDict {
    if (_gradeDict == nil)
        _gradeDict = [NSDictionary new];
    return _gradeDict;
}

#pragma mark HWDownSelectedViewDelegate
-(void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath {
    if (self.testType != indexPath.row+1) {
        self.gradeDict = nil;
        [self.GradeIndicatorBtn setTitle:@"点击填写" forState:UIControlStateNormal];
    }
    self.testType = indexPath.row+1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.testTypeSelectView close];
}



@end


