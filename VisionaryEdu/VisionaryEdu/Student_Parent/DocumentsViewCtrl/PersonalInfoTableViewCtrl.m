//
//  PersonalInfoTableViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "PersonalInfoTableViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "PersonalInfoModel.h"
#import "TabBarManagerViewCtrl.h"

@interface PersonalInfoTableViewCtrl ()
@property (strong,nonatomic) PersonalInfoModel *model;
@end

@implementation PersonalInfoTableViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SysTool showLoadingHUDWithMsg:@"获取个人信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_PERSONINFO token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            self.model = [PersonalInfoModel mj_objectWithKeyValues:responseObject];
            [self.tableView reloadData];
        } else {
            [SysTool showErrorWithMsg:msg duration:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 920;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalInfoCell *cell = (PersonalInfoCell*)[tableView dequeueReusableCellWithIdentifier:@"personalInfo" forIndexPath:indexPath];
    PersonalResults *info = self.model.results[0];
    cell.nameLB.text            = [StudentInstance shareInstance].student_realname;
    cell.genderLB.text          = info.gender;
    cell.natianalityLB.text     = info.nationality;
    cell.expectedDegreeLB.text  = info.expected_degree;
    cell.interested_majorLB.text = info.interested_major;
    cell.expectedJobLB.text     = info.expected_job;
    cell.hobbiesLB.text         = info.hobbies;
    cell.religiousPreferenceLB.text = info.religious_preference;
    cell.birthdayLB.text        = info.date_of_birth;
    cell.birthPlaceLB.text      = info.place_of_birth;
    cell.idNumberLB.text        = info.id_number;
    cell.usedNameLB.text        = info.used_name;
    cell.sexualOrientationLB.text = info.sexual_orientation;
    cell.EmailLB.text           = info.email;
    cell.phoneNumLB.text        = info.cellphone_number;
    cell.addressLB.text         = info.family_address;
    cell.mailAddressLB.text     = info.mail_address;
    cell.postCodeLB.text        = info.post_code;
    return cell;
}

@end

@implementation PersonalInfoCell

@end
