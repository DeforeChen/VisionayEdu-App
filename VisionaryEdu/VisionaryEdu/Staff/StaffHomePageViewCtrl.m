//
//  StaffHomePageViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/24.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StaffHomePageViewCtrl.h"
#import "SysTool.h"
#import "SYHttpTool.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "StudentBaseInfoManager.h"
#import "LoginViewCtrl.h"
#import "LoginInfoModel.h"
#import "StudentInfoTableViewCell.h"
#import "config.h"

@interface StaffHomePageViewCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *studentListTB;
@property (weak, nonatomic) IBOutlet UILabel *studentTotalNumLB;
@property (assign,nonatomic) BOOL isFirstRefresh;
@property (copy,nonatomic) NSArray<NSArray<StudentInfoModel*>*> *studentInfoArray;
@property (copy,nonatomic) NSArray<NSString*> *gradeIndexArray;
@end

@implementation StaffHomePageViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.studentListTB.sectionIndexColor = [UIColor blackColor];
    self.studentListTB.sectionIndexBackgroundColor = [UIColor clearColor];
    self.studentListTB.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.isFirstRefresh = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([LoginInfoModel isLogin] == NO) {
        LoginViewCtrl *vc = [LoginViewCtrl initMyView];
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        // 下拉刷新
        self.studentListTB.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        if (self.isFirstRefresh) {
            self.isFirstRefresh = NO;
            [SysTool showLoadingHUDWithMsg:@"信息加载中..." duration:0];
            [self refresh];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma getter
-(NSArray<NSArray<StudentInfoModel *> *> *)studentInfoArray {
    if (_studentInfoArray == nil) {
        _studentInfoArray = [NSArray new];
    }
    return _studentInfoArray;
}

-(NSArray<NSString *> *)gradeIndexArray {
    if (_gradeIndexArray == nil) {
        _gradeIndexArray = [NSArray new];
    }
    return _gradeIndexArray;
}

#pragma mark Private Methods
-(void)refresh {
    NSDictionary *paramDict = @{@"staff_username":[LoginInfoModel fetchUsername]};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_STUDENT_BY_YEAR token:[LoginInfoModel fetchTokenFromSandbox] params:paramDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [self.studentListTB.mj_header endRefreshing];
        [SysTool dismissHUD];
        if (success) {
            StudentBaseInfo *info = [StudentBaseInfoManager fetchStudentInfoOfGradeFromResponseJSON:responseObject];
            self.studentInfoArray = info.studentInfoArray;
            self.gradeIndexArray  = info.gradeIndexArray;
            self.studentTotalNumLB.text = [NSString stringWithFormat:@"共%d人",(int)info.totalStudentNum];
            [self.studentListTB reloadData];
        } else {
            [SysTool showErrorWithMsg:msg duration:1];
        }
    }];
}

#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.gradeIndexArray.count;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.gradeIndexArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.studentInfoArray objectAtIndex:section].count;//二维数组，二级数组的大小
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GradeSectionTitileCell *cell = (GradeSectionTitileCell*)[tableView dequeueReusableCellWithIdentifier:@"sectionTitle"];
    cell.gradeLB.text = self.gradeIndexArray[section];
    return cell.contentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 60;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentInfoModel *info = self.studentInfoArray[indexPath.section][indexPath.row];
    
    ServiceType type;
    if (info.hs_guard == YES) {
        type = (info.undergrad)?Both:HighSchoolGuardiance;
    } else
        type = UnderGraduation;
    
    XLog(@"student type = %d",(int)type);
    StudentInfoTableViewCell *cell = [StudentInfoTableViewCell fetchMyCellWithTableView:tableView studentName:info.full_name serviceType:type className:info.user_class registerTime:info.registration_date];
    return cell;
}

@end