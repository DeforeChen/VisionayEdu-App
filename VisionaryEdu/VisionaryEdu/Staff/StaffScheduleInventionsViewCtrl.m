//
//  StaffScheduleInventionsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/10.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StaffScheduleInventionsViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import "UIColor+expanded.h"

#import "StaffListModel.h"
#import "StudentListModel.h"


@interface StaffScheduleInventionsViewCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *TagContainerView;

@property (weak, nonatomic) IBOutlet UILabel *selectTitleLB;
@property (weak, nonatomic) IBOutlet UITableView *inventGuysList;

@property (weak, nonatomic) IBOutlet UILabel *meetingLB;
@property (weak, nonatomic) IBOutlet UILabel *checkInRecordsLB;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic,copy) NSString *StaffNextURL;
@property (nonatomic,copy) NSString *StudentNextURL;

@property (strong, nonatomic) NSMutableArray *staffCanBeAppointedListArray;
@property (strong, nonatomic) NSMutableArray *studentListArray;
@property (copy, nonatomic) NSArray *guysListArray;//最后回传的选好的人员名单

@property (strong ,nonatomic) NSMutableArray *selectedStaffArray;
@property (strong ,nonatomic) NSMutableArray *selectedStudentArray;

@property (copy, nonatomic) SelectionInfoUnderCreateMode createBlk;
@property (copy, nonatomic) SelectionInfoUnderModifyMode modifyBlk;
@property (assign,nonatomic) UseMode mode;
@property (assign,nonatomic) StaffScheduleType scheduleType;//日程种类，约见或会议
@end

@implementation StaffScheduleInventionsViewCtrl
+(instancetype)initMyViewCtrlWithUseMode:(UseMode)mode
             scheduleTypeUnderModifyMode:(StaffScheduleType)type
                    guysHaveBeenIncluded:(NSArray*)hasBeenIncludedGuys
                          createCallback:(SelectionInfoUnderCreateMode)createBlk
                          modifyCallback:(SelectionInfoUnderModifyMode)modifyBlk {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StaffScheduleInventionsViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];

    vc.createBlk    = createBlk;
    if (type == MeetingType) {
        vc.selectedStaffArray = [hasBeenIncludedGuys mutableCopy];
    } else if(type == StaffCheckInRecordsType)
        vc.selectedStudentArray = [hasBeenIncludedGuys mutableCopy];
    vc.modifyBlk    = modifyBlk;
    vc.scheduleType = type;
    vc.mode         = mode;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.confirmBtn.layer.cornerRadius = 6.0f;
    self.confirmBtn.clipsToBounds = YES;
    
    if (self.mode == ModifyMode) { // 修改模式
        self.TagContainerView.hidden = YES;
        // 根据日程类型去获取对应的guys列表
        if (self.scheduleType == MeetingType) {
            [self selectMeeting:nil];
        } else
            [self selectCheckInRecord:nil];
    } else { // 新增模式下，默认选择茶话会
        [self selectMeeting:nil];
    }
    
    self.inventGuysList.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getter
-(NSMutableArray *)staffCanBeAppointedListArray {
    if (_staffCanBeAppointedListArray == nil)
        _staffCanBeAppointedListArray = [NSMutableArray new];
    return _staffCanBeAppointedListArray;
}

-(NSMutableArray *)studentListArray {
    if (_studentListArray == nil)
        _studentListArray = [NSMutableArray new];
    return _studentListArray;
}

-(NSArray *)guysListArray {
    if (_guysListArray == nil)
        _guysListArray = [NSArray new];
    return _guysListArray;
}

-(NSMutableArray *)selectedStaffArray {
    if (_selectedStaffArray == nil)
        _selectedStaffArray = [NSMutableArray new];
    return _selectedStaffArray;
}

-(NSMutableArray *)selectedStudentArray {
    if (_selectedStudentArray == nil)
        _selectedStudentArray = [NSMutableArray new];
    return _selectedStudentArray;
}

#pragma mark UserInteraction
- (IBAction)selectMeeting:(UIButton *)sender {
    [self.inventGuysList.mj_footer resetNoMoreData];
    self.meetingLB.textColor = [UIColor colorWithHexString:@"#3FC6A0"];
    self.checkInRecordsLB.textColor = [UIColor colorWithHexString:@"#43434D"];
    self.selectTitleLB.text = @"请选择与会员工";
    self.scheduleType = MeetingType;
    
    if (self.staffCanBeAppointedListArray.count == 0) {
        [SysTool showLoadingHUDWithMsg:@"获取员工列表" duration:0];
        NSDictionary *reqDict = @{@"staff_username":[LoginInfoModel fetchAccountUsername],
                                  @"for_appointment":@YES};
        [[SYHttpTool sharedInstance] getReqWithURL:STAFF_LIST token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                StaffListModel *model = [StaffListModel mj_objectWithKeyValues:responseObject];
                for (StaffList_Results *info in model.results) {
                    [self.staffCanBeAppointedListArray addObject:info.full_name];
                }

                self.StaffNextURL = model.next;
                self.guysListArray = self.staffCanBeAppointedListArray;
                [self.inventGuysList reloadData];
            } else {
                [SysTool showErrorWithMsg:msg duration:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        self.guysListArray = self.staffCanBeAppointedListArray;
        [self.inventGuysList reloadData];
    }
}

- (IBAction)selectCheckInRecord:(UIButton *)sender {
    [self.inventGuysList.mj_footer resetNoMoreData];
    self.checkInRecordsLB.textColor = [UIColor colorWithHexString:@"#3FC6A0"];
    self.meetingLB.textColor = [UIColor colorWithHexString:@"#43434D"];
    self.selectTitleLB.text = @"请选择约谈学生";
    self.scheduleType = StaffCheckInRecordsType;
    
    if (self.studentListArray.count == 0) {
        [SysTool showLoadingHUDWithMsg:@"获取学生列表" duration:0];
        NSDictionary *reqDict = @{@"staff_username":[LoginInfoModel fetchAccountUsername]};
        [[SYHttpTool sharedInstance] getReqWithURL:STUDENT_LIST token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                StudentListModel *model = [StudentListModel mj_objectWithKeyValues:responseObject];
                for (StudentList_Results *info in model.results) {
                    [self.studentListArray addObject:info.full_name];
                }
                
                self.StudentNextURL = model.next;
                self.guysListArray = self.studentListArray;
                [self.inventGuysList reloadData];
            } else {
                [SysTool showErrorWithMsg:msg duration:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        self.guysListArray = self.studentListArray;
        [self.inventGuysList reloadData];
    }
}

- (IBAction)finishSelection:(UIButton *)sender {
    NSMutableArray *fullNameArray = [NSMutableArray new];
    fullNameArray = (self.scheduleType == MeetingType)?self.selectedStaffArray:self.selectedStudentArray;
    if (fullNameArray.count == 0) {
        [SysTool showErrorWithMsg:@"亲，您一个人都没有选可不能添加日程呀" duration:2];
        return;
    }
    
    if (self.scheduleType == MeetingType) {
        NSString *myName = [LoginInfoModel fetchRealNameFromSandbox];
        if (![fullNameArray containsObject:myName]) {
            [SysTool showErrorWithMsg:@"添加的日程必须包括您自己!" duration:2];
            return;
        }
        
        if (fullNameArray.count == 1 && [fullNameArray[0] isEqualToString:myName]) {
            [SysTool showErrorWithMsg:@"就你自己一个人开什么会?!" duration:2];
            return;
        }
    }
    
    if (self.mode == ModifyMode) {
        if (self.modifyBlk != nil) self.modifyBlk(fullNameArray);
    } else { // 新增模式
        if(self.createBlk != nil) self.createBlk(self.scheduleType, fullNameArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadMoreData {
    NSString *url = (self.scheduleType == MeetingType)?STAFF_LIST:STUDENT_LIST;
    NSString *nextURL = (self.scheduleType == MeetingType)?self.StaffNextURL:self.StudentNextURL;
    
    if (nextURL.length > 0) {
        [[SYHttpTool sharedInstance] getReqWithURL:url token:[LoginInfoModel fetchTokenFromSandbox] params:[self fetchLoadMoreDictFromURL:nextURL] completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            if (success) {
                XLog(@"RESPONSE = %@",responseObject);
                [self.inventGuysList.mj_footer endRefreshing];
                if (self.scheduleType == MeetingType) {
                    StaffListModel *model = [StaffListModel mj_objectWithKeyValues:responseObject];
                    self.StaffNextURL = model.next;
                    for (StaffList_Results *info in model.results) {
                        [self.staffCanBeAppointedListArray addObject:info.full_name];
                    }

                    self.guysListArray = self.staffCanBeAppointedListArray;
                } else {
                    StudentListModel *model = [StudentListModel mj_objectWithKeyValues:responseObject];
                    for (StudentList_Results *info in model.results) {
                        [self.studentListArray addObject:info.full_name];
                    }
                    
                    self.StudentNextURL = model.next;
                    self.guysListArray = self.studentListArray;
                }
                [self.inventGuysList reloadData];
            }  else {
                [self.inventGuysList.mj_footer endRefreshing];
                [SysTool showErrorWithMsg:msg duration:1];
            }
        }];
    } else {
        [self.inventGuysList.mj_footer endRefreshingWithNoMoreData];
    }
}

-(NSDictionary*)fetchLoadMoreDictFromURL:(NSString*)url {
    NSString *URLparams = [url componentsSeparatedByString:@"?"][1];//取出参数
    NSArray *paramArray = [URLparams componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *param in paramArray) {
        NSArray *keyValues = [param componentsSeparatedByString:@"="];
        [dict setObject:keyValues[1] forKey:keyValues[0]];
    }
    return dict;
}
#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.guysListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.scheduleType == MeetingType) { // 会议，对应 Meeting Cell
        Schedule_MeetingCell *cell = (Schedule_MeetingCell*)[tableView dequeueReusableCellWithIdentifier:@"staffMeeting"];
        
        cell.nameLb.text = self.staffCanBeAppointedListArray[indexPath.row];
        cell.tipImg.hidden = [self.selectedStaffArray containsObject:self.staffCanBeAppointedListArray[indexPath.row]]?NO:YES;
        return cell;
    } else {
        Schedule_RecordCell *cell = (Schedule_RecordCell*)[tableView dequeueReusableCellWithIdentifier:@"studentRecord"];
        cell.nameLB.text = self.studentListArray[indexPath.row];
        cell.tipImg.hidden = [self.selectedStudentArray containsObject:self.studentListArray[indexPath.row]]?NO:YES;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.scheduleType == MeetingType) { // 会议，对应 Meeting Cell
        Schedule_MeetingCell *cell = [self.inventGuysList cellForRowAtIndexPath:indexPath];
        cell.tipImg.hidden = [self.selectedStaffArray containsObject:self.staffCanBeAppointedListArray[indexPath.row]]?YES:NO;
        if ([self.selectedStaffArray containsObject:self.staffCanBeAppointedListArray[indexPath.row]]) {
            [self.selectedStaffArray removeObject:self.staffCanBeAppointedListArray[indexPath.row]];
        } else
            [self.selectedStaffArray addObject:self.staffCanBeAppointedListArray[indexPath.row]];
    } else {
        Schedule_RecordCell *cell = [self.inventGuysList cellForRowAtIndexPath:indexPath];
        cell.tipImg.hidden = [self.selectedStudentArray containsObject:self.studentListArray[indexPath.row]]?YES:NO;
        if ([self.selectedStudentArray containsObject:self.studentListArray[indexPath.row]]) {
            [self.selectedStudentArray removeObject:self.studentListArray[indexPath.row]];
        } else
            [self.selectedStudentArray addObject:self.studentListArray[indexPath.row]];
    }
}
@end

@implementation Schedule_RecordCell


@end

@implementation Schedule_MeetingCell


@end
