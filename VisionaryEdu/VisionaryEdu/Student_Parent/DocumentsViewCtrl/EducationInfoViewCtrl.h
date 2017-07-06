//
//  EducationInfoViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationInfoViewCtrl : UITableViewController

@end

@interface EducationInfoCell : UITableViewCell
// 当前学校信息
@property (weak, nonatomic) IBOutlet UILabel *currentScoolLB;
@property (weak, nonatomic) IBOutlet UILabel *currentGradeLB;
@property (weak, nonatomic) IBOutlet UILabel *AttendDateLB;
@property (weak, nonatomic) IBOutlet UILabel *graduateDateLB;
@property (weak, nonatomic) IBOutlet UILabel *currentSchoolAdrLB;
@property (weak, nonatomic) IBOutlet UILabel *currentPostCode;
@property (weak, nonatomic) IBOutlet UILabel *schoolSettingLB;
@property (weak, nonatomic) IBOutlet UILabel *currentGradePopulationLB;
@property (weak, nonatomic) IBOutlet UILabel *currentSchoolPhone;
@property (weak, nonatomic) IBOutlet UILabel *gpaGradeLB;
@property (weak, nonatomic) IBOutlet UILabel *gradeRankLB;
@property (weak, nonatomic) IBOutlet UILabel *studentID_LB;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLB;
@property (weak, nonatomic) IBOutlet UILabel *teacherPhoneLB;
@property (weak, nonatomic) IBOutlet UILabel *teacherMailLB;

// 上一所学校信息
@property (weak, nonatomic) IBOutlet UILabel *lastSchoolLB;
@property (weak, nonatomic) IBOutlet UILabel *lastAttendDateLB;
@property (weak, nonatomic) IBOutlet UILabel *lastGraduateDateLB;
@property (weak, nonatomic) IBOutlet UILabel *lastSchoolAdrLB;
@property (weak, nonatomic) IBOutlet UILabel *lastPostCodeLB;
@property (weak, nonatomic) IBOutlet UILabel *lastSchoolSetting;
@property (weak, nonatomic) IBOutlet UILabel *lastSchoolPhoneLB;

@end
