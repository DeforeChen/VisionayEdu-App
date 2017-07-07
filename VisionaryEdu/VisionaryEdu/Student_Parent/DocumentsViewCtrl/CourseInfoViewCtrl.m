//
//  CourseInfoViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CourseInfoViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "CourseInfoModel.h"
#import "TabBarManagerViewCtrl.h"
#import "UIColor+expanded.h"

@interface CourseInfoViewCtrl ()
@property (copy,nonatomic) NSArray<ElectiveCoure*> *electiveCourseArray;
@property (copy,nonatomic) NSArray *HS_CourseArray;
@end

@implementation CourseInfoViewCtrl
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
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_COURSE token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            [CourseInfoModel initModelWithResponse:responseObject callback:^(NSArray<ElectiveCoure *> *electiveCourse, NSArray<NSString *> *HS_Course) {
                self.electiveCourseArray = electiveCourse;
                self.HS_CourseArray = HS_Course;
                [self.tableView reloadData];
            }];
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

#pragma mark getter
-(NSArray *)HS_CourseArray {
    if (_HS_CourseArray == nil) {
        _HS_CourseArray = [NSArray new];
    }
    return _HS_CourseArray;
}

-(NSArray<ElectiveCoure*> *)electiveCourseArray {
    if (_electiveCourseArray == nil) {
        _electiveCourseArray = [NSArray new];
    }
    return _electiveCourseArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.electiveCourseArray.count == 0)?1:self.electiveCourseArray.count;
    } else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 165;;
    } else
        return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ElectiveCoureCell *cell = (ElectiveCoureCell*)[tableView dequeueReusableCellWithIdentifier:@"electiveCell"];
        if (self.electiveCourseArray.count == 0) {
            cell.courseLB.text = @"";
            cell.courseDescriptionLB.text = @"";
        } else {
            cell.courseLB.text = self.electiveCourseArray[indexPath.row].elective_course;
            cell.courseDescriptionLB.text = self.electiveCourseArray[indexPath.row].elective_course_description;
        }
        return cell;
    } else {
        HS_CourseCell *cell = (HS_CourseCell*)[tableView dequeueReusableCellWithIdentifier:@"hsCourseCell"];
        cell.HS_CourseLB.text = [self.HS_CourseArray componentsJoinedByString:@"   "];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"electiveHeader"];
        return cell.contentView;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hsCourse"];
        return cell.contentView;
    }
}

@end

@implementation ElectiveCoureCell

@end

@implementation HS_CourseCell

@end
