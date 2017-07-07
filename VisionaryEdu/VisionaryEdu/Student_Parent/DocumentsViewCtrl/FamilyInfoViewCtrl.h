//
//  FamilyInfoViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyInfoViewCtrl : UITableViewController

@end

@interface ParentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *emailLB;
@property (weak, nonatomic) IBOutlet UILabel *degreeLB;
@property (weak, nonatomic) IBOutlet UILabel *eduSchoolLB;
@property (weak, nonatomic) IBOutlet UILabel *eduYear;
@property (weak, nonatomic) IBOutlet UILabel *companyLB;
@property (weak, nonatomic) IBOutlet UILabel *workPhoneLB;
@property (weak, nonatomic) IBOutlet UILabel *workPositionLB;
@property (weak, nonatomic) IBOutlet UILabel *workYearLB;

@end

@interface RelativeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *genderLB;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLB;
@property (weak, nonatomic) IBOutlet UILabel *relationLB;
@property (weak, nonatomic) IBOutlet UILabel *degreeLB;

@end
