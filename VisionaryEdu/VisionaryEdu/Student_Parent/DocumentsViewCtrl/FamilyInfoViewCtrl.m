//
//  FamilyInfoViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "FamilyInfoViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "FamilyInfoModel.h"
#import "TabBarManagerViewCtrl.h"
#import "UIColor+expanded.h"

@interface FamilyInfoViewCtrl ()
@property (strong,nonatomic) Fahter *father;
@property (strong,nonatomic) Mother *mother;
@property (copy,nonatomic) NSArray<Sibling*> *siblingArray;
@end

@implementation FamilyInfoViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F9"];
    [SysTool showLoadingHUDWithMsg:@"获取家庭信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_FAMILY token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            [FamilyInfoModel initModelWithResponse:responseObject callback:^(Fahter *fatherInfo, Mother *motherInfo, NSArray<Sibling *> *siblingArray) {
                self.father = fatherInfo;
                self.mother = motherInfo;
                self.siblingArray = siblingArray;
                [self.tableView reloadData];
            }];
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

#pragma mark Getter
-(NSArray<Sibling *> *)siblingArray {
    if (_siblingArray == nil) {
        _siblingArray = [NSArray new];
    }
    return _siblingArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else
        return self.siblingArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 379;;
    } else
        return 171;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 77;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fatherHeader"];
        return cell.contentView;
    } else if(section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"motherHeader"];
        return cell.contentView;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ralativeHeader"];
        return cell.contentView;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ParentCell *cell = (ParentCell*)[tableView dequeueReusableCellWithIdentifier:@"parentCell"];
        cell.nameLB.text = self.father.father_name;
        cell.phoneLB.text = self.father.father_cellphone;
        cell.birthDateLB.text = self.father.father_birthday;
        cell.addressLB.text = self.father.father_address;
        cell.emailLB.text = self.father.father_email;
        cell.degreeLB.text = self.father.father_edu_degree;
        cell.eduSchoolLB.text = self.father.father_edu_school;
        cell.eduYear.text = self.father.father_edu_year;
        cell.companyLB.text = self.father.father_work_company;
        cell.workPhoneLB.text = self.father.father_workphone;
        cell.workPositionLB.text = self.father.father_work_position;
        cell.workYearLB.text = self.father.father_work_year;
        return cell;
    } else if (indexPath.section == 1) {
        ParentCell *cell = (ParentCell*)[tableView dequeueReusableCellWithIdentifier:@"parentCell"];
        cell.nameLB.text = self.mother.mother_name;
        cell.phoneLB.text = self.mother.mother_cellphone;
        cell.birthDateLB.text = self.mother.mother_birthday;
        cell.addressLB.text = self.mother.mother_address;
        cell.emailLB.text = self.mother.mother_email;
        cell.degreeLB.text = self.mother.mother_edu_degree;
        cell.eduSchoolLB.text = self.mother.mother_edu_school;
        cell.eduYear.text = self.mother.mother_edu_year;
        cell.companyLB.text = self.mother.mother_work_company;
        cell.workPhoneLB.text = self.mother.mother_workphone;
        cell.workPositionLB.text = self.mother.mother_work_position;
        cell.workYearLB.text = self.mother.mother_work_year;
        return cell;
    } else {
        if (self.siblingArray.count > 0) {
            RelativeCell *cell = (RelativeCell*)[tableView dequeueReusableCellWithIdentifier:@"relativeCell"];
            cell.nameLB.text = self.siblingArray[indexPath.row].name;
            cell.genderLB.text = self.siblingArray[indexPath.row].gender;
            cell.birthDateLB.text = self.siblingArray[indexPath.row].birthday;
            cell.relationLB.text = self.siblingArray[indexPath.row].relation;
            cell.degreeLB.text = self.siblingArray[indexPath.row].degree;
            return cell;
        } else
            return nil;
    }
}
@end

@implementation RelativeCell

@end

@implementation ParentCell

@end
