//
//  StaffHomePageViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/24.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StaffHomePageViewCtrl.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "StudentBaseInfoManager.h"
#import "LoginViewCtrl.h"
#import "StudentInfoTableViewCell.h"
#import "StudentInstance.h"
#import "config.h"
#import "UIColor+expanded.h"

//#define MY_DEBUG
#ifdef MY_DEBUG
#import <JPush/JPUSHService.h>
#endif

@interface StaffHomePageViewCtrl ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *studentListTB;
@property (weak, nonatomic) IBOutlet UILabel *studentTotalNumLB;
@property (weak, nonatomic) IBOutlet UILabel *staff_nameLB;
@property (assign,nonatomic) BOOL isFirstRefresh;
//@property (copy,nonatomic) NSArray<NSArray<StudentInfoModel*>*> *studentInfoArray;
//@property (strong,nonatomic) NSMutableArray<NSArray<StudentInfoModel*>*> *displayArray;
@property (copy,nonatomic) NSArray<StudentInfoModel*> *studentInfoArray;
@property (strong,nonatomic) NSMutableArray<StudentInfoModel*> *displayArray;
@property (weak, nonatomic) IBOutlet UISearchBar *stuSearchBar;
@end

@implementation StaffHomePageViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.studentListTB.sectionIndexColor = [UIColor blackColor];
    self.studentListTB.sectionIndexBackgroundColor = [UIColor clearColor];
    self.studentListTB.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.isFirstRefresh = YES;
    // Do any additional setup after loading the view.
    
    self.stuSearchBar.layer.borderColor = [UIColor colorWithHexString:@"F4F4F4"].CGColor;
    self.stuSearchBar.layer.borderWidth = 1;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.staff_nameLB.text = [NSString stringWithFormat:@"Welcome, %@!",[LoginInfoModel fetchRealNameFromSandbox]];
    if ([LoginInfoModel isLogin] == NO) {
        LoginViewCtrl *vc = [LoginViewCtrl initMyView];
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
            // 下拉刷新
            self.studentListTB.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            if (self.isFirstRefresh) {
                self.isFirstRefresh = NO;
                [SysTool showLoadingHUDWithMsg:@"信息加载中..." duration:0];
                [self refresh];
            }
        } else { // 学生端
            [StudentInstance shareInstance].student_realname = [LoginInfoModel fetchRealNameFromSandbox];
            [StudentInstance shareInstance].student_username = [LoginInfoModel fetchAccountUsername];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabbarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarID"];
            [self presentViewController: tabbarVC animated:NO completion:nil];
        }
    }
#ifdef MY_DEBUG
    NSString *ID = [JPUSHService registrationID];
    [SysTool showAlertWithMsg:ID handler:nil viewCtrl:self];
#endif
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma getter
-(NSArray<StudentInfoModel *> *)studentInfoArray {
    if (_studentInfoArray == nil) {
        _studentInfoArray = [NSArray new];
    }
    return _studentInfoArray;
}

//-(NSArray<NSString *> *)gradeIndexArray {
//    if (_gradeIndexArray == nil) {
//        _gradeIndexArray = [NSArray new];
//    }
//    return _gradeIndexArray;
//}

-(NSMutableArray *)displayArray {
    if (_displayArray == nil) {
        _displayArray = [NSMutableArray new];
    }
    return _displayArray;
}

#pragma mark Private Methods
-(void)refresh {
    NSDictionary *paramDict = @{@"staff_username":[LoginInfoModel fetchAccountUsername]};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_STUDENT_BY_YEAR token:[LoginInfoModel fetchTokenFromSandbox] params:paramDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [self.studentListTB.mj_header endRefreshing];
        [SysTool dismissHUD];
        if (success) {
            StudentBaseInfo *info = [StudentBaseInfoManager fetchStudentInfoOfGradeFromResponseJSON:responseObject];
            //            self.studentInfoArray = info.studentInfoArray;
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSArray<StudentInfoModel *> *array in info.studentInfoArray) {
                for (StudentInfoModel *infoModel in array) {
                    [tempArray addObject:infoModel];
                }
            }
            self.studentInfoArray =tempArray;
            self.displayArray     = [self.studentInfoArray mutableCopy];
            //            self.gradeIndexArray  = info.gradeIndexArray;
            self.studentTotalNumLB.text = [NSString stringWithFormat:@"共%d人",(int)info.totalStudentNum];
            [self.studentListTB reloadData];
        } else {
            [SysTool showErrorWithMsg:msg duration:1];
        }
    }];
    //    }
}

#pragma mark Tableview Delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.whetherSearchMode?0:self.gradeIndexArray.count;
//}
//
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.whetherSearchMode?0:self.gradeIndexArray;
//}
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayArray.count; //[self.displayArray objectAtIndex:section].count;//二维数组，二级数组的大小
}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (self.whetherSearchMode == YES) {
//        GradeSectionTitileCell *cell = (GradeSectionTitileCell*)[tableView dequeueReusableCellWithIdentifier:@"sectionTitle"];
//        cell.gradeLB.text = self.gradeIndexArray[section];
//        return cell.contentView;
//    } else
//        return nil;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 50;
//    if(scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return self.whetherSearchMode?0:60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentInfoModel *info = self.displayArray[indexPath.row];//self.displayArray[indexPath.section][indexPath.row];
    
    ServiceType type;
    if (info.hs_guard == YES) {
        type = (info.undergrad)?Both:HighSchoolGuardiance;
    } else
        type = UnderGraduation;
    
    //    StudentInfoTableViewCell *cell = [StudentInfoTableViewCell fetchMyCellWithTableView:tableView studentName:info.full_name serviceType:type className:info.user_class registerTime:info.registration_date];
    StudentInfoTableViewCell *cell = [StudentInfoTableViewCell fetchMyCellWithTableView:tableView studentName:info.full_name serviceType:type className:info.user_class checkinTime:info.appointment_statistics registerTime:info.registration_date];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentInfoModel *info = self.displayArray[indexPath.row];//self.displayArray[indexPath.section][indexPath.row];
    [StudentInstance shareInstance].student_realname = info.full_name;
    [StudentInstance shareInstance].student_username = info.username;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabbarVC = [storyboard instantiateViewControllerWithIdentifier:@"tabBarID"];
    tabbarVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //    UINavigationController *nav = tabbarVC.viewControllers[1];
    [self presentViewController: tabbarVC animated:YES completion:nil];
}

#pragma mark UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    XLog(@"查询的参数====%@",searchText);
    [self searchFromTalbeView:searchText];
    //    self.whetherSearchMode = (searchText.length == 0)?NO:YES;
    self.studentListTB.mj_header.hidden = (searchText.length == 0)?NO:YES;
}

- (void)searchFromTalbeView:(NSString *)text {
    NSString *searchText=text;
    if (searchText.length>0) {
        self.studentListTB.mj_header.hidden = YES;
        [self.displayArray removeAllObjects];
        
        for (StudentInfoModel *model in self.studentInfoArray) {
            NSString *tempStr = model.full_name;
            NSRange titleResult=[tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0)
                [self.displayArray addObject:model];
        }
    } else
        self.displayArray=[self.studentInfoArray mutableCopy];
    [self.studentListTB reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    XLog(@"清空当前搜索");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar; {
    XLog(@"输入结束");
}


@end
