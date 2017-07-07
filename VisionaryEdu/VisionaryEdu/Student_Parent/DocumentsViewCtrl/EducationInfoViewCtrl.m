//
//  EducationInfoViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "EducationInfoViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "EduInfoModel.h"
#import "TabBarManagerViewCtrl.h"

@interface EducationInfoViewCtrl ()
@property (strong,nonatomic) EduInfoModel *model;
@end

@implementation EducationInfoViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SysTool showLoadingHUDWithMsg:@"获取账号信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_EDUINFO token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            self.model = [EduInfoModel mj_objectWithKeyValues:responseObject];
            [self.tableView reloadData];
        } else {
            [SysTool showErrorWithMsg:msg duration:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 830;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EducationInfoCell *cell = (EducationInfoCell*)[tableView dequeueReusableCellWithIdentifier:@"eduInfo"];
    if (self.model.results.count > 0) {
        Edu_Results *info = self.model.results[0];
        cell.currentScoolLB.text = info.current_school;
        cell.currentGradeLB.text = info.current_grade;
        cell.AttendDateLB.text = info.attended_class_grade;
        cell.graduateDateLB.text = info.date_of_current_graduate;
        cell.currentSchoolAdrLB.text = info.current_school_address;
        cell.currentPostCode.text = info.post_code;
        cell.schoolSettingLB.text = info.setting_of_current_school;
        cell.currentGradePopulationLB.text = info.current_class_grade_population;
        cell.currentSchoolPhone.text = info.current_school_phone;
        cell.gpaGradeLB.text = info.gpa_grade;
        cell.gradeRankLB.text = info.current_class_grade_rank;
        cell.studentID_LB.text = info.student_id;
        cell.teacherNameLB.text = info.teacher_name;
        cell.teacherPhoneLB.text = info.teacher_phone;
        cell.teacherMailLB.text = info.teacher_email;
        
        cell.lastSchoolLB.text = info.last_attending_school;
        cell.lastAttendDateLB.text = info.date_of_last_attending;
        cell.lastGraduateDateLB.text = info.date_of_last_graduate;
        cell.lastSchoolAdrLB.text = info.last_school_address;
        cell.lastPostCodeLB.text = info.last_post_code;
        cell.lastSchoolSetting.text = info.setting_of_last_school;
        cell.lastSchoolPhoneLB.text = info.last_school_phone;
    }
    return cell;
}
@end

@implementation EducationInfoCell

@end
