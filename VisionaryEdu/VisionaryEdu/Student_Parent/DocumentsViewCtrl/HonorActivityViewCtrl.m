//
//  HonorActivityViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "HonorActivityViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "HonorActivityModel.h"
#import "TabBarManagerViewCtrl.h"
#import "UIColor+expanded.h"

@interface HonorActivityViewCtrl ()
@property(nonatomic,copy) NSArray<Honor *> *honorArray;
@property(nonatomic,copy) NSArray<Activity *> *activityArray;
@end

@implementation HonorActivityViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F9"];
    [SysTool showLoadingHUDWithMsg:@"获取课程信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_ACTIVITY token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            [HonorActivityModel initModelWithResponse:responseObject callback:^(NSArray<Honor *> *honorArray, NSArray<Activity *> *activityArray) {
                self.honorArray = honorArray;
                self.activityArray = activityArray;
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
-(NSArray<Honor *> *)honorArray {
    if (_honorArray == nil) {
        _honorArray = [NSArray new];
    }
    return _honorArray;
}

-(NSArray<Activity *> *)activityArray {
    if (_activityArray == nil) {
        _activityArray = [NSArray new];
    }
    return _activityArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160;;
    } else
        return 395;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.honorArray.count;
    } else
        return self.activityArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 荣誉部分
        if (self.honorArray.count > 0) {
            HonorCell *cell = (HonorCell*)[tableView dequeueReusableCellWithIdentifier:@"honorCell"];
            cell.titleLB.text = self.honorArray[indexPath.row].title;
            cell.rankLB.text = self.honorArray[indexPath.row].rank;
            cell.dateLB.text = self.honorArray[indexPath.row].date;
            cell.placeLB.text = self.honorArray[indexPath.row].place;
            cell.organizationLB.text = self.honorArray[indexPath.row].organization;
            return cell;
        } else
            return nil;
    } else {
        // 活动部分
        if (self.activityArray.count > 0) {
            ActivityCell *cell = (ActivityCell*)[tableView dequeueReusableCellWithIdentifier:@"activityCell"];
            cell.titleLB.text = self.activityArray[indexPath.row].title;
            cell.positionlB.text = self.activityArray[indexPath.row].position;
            cell.accomplishmentTextView.text = self.activityArray[indexPath.row].accomplishment;
            cell.accomplishmentTextView.editable = NO;
            cell.descriptionTextView.text = self.activityArray[indexPath.row].actDescription;
            cell.descriptionTextView.editable = NO;
            cell.placeLB.text = self.activityArray[indexPath.row].place;
            cell.timePeriodLB.text = self.activityArray[indexPath.row].time_period;
            return cell;
        } else
            return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"honorHeader"];
        return cell.contentView;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityHeader"];
        return cell.contentView;
    }
}
@end

@implementation HonorCell

@end

@implementation ActivityCell

@end
