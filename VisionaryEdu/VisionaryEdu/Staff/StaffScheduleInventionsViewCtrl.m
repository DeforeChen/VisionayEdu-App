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

@property (strong, nonatomic) NSMutableArray *inventedStaffArray;
@property (strong, nonatomic) NSMutableArray *inventedStudentArray;

@property (nonatomic,copy) NSString *StaffNextURL;
@property (nonatomic,copy) NSString *StudentNextURL;

@property (strong ,nonatomic) NSMutableArray<StaffList_Results*> *selectedStaffArray;
@property (strong ,nonatomic) NSMutableArray<StudentList_Results*> *selectedStudentArray;

@property (copy, nonatomic) NSArray *inventedGuysArray;

@property (copy, nonatomic) SelectionInfoUnderCreateMode createBlk;
@property (copy, nonatomic) SelectionInfoUnderModifyMode modifyBlk;
@property (assign,nonatomic) UseMode mode;
@property (assign,nonatomic) StaffScheduleType scheduleType;//日程种类，约见或会议
@end

@implementation StaffScheduleInventionsViewCtrl
+(instancetype)initMyViewCtrlWithUseMode:(UseMode)mode
             scheduleTypeUnderModifyMode:(StaffScheduleType)type
                          createCallback:(SelectionInfoUnderCreateMode)createBlk
                          modifyCallback:(SelectionInfoUnderModifyMode)modifyBlk {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StaffScheduleInventionsViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.createBlk    = createBlk;
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
-(NSMutableArray *)inventedStaffArray {
    if (_inventedStaffArray == nil)
        _inventedStaffArray = [NSMutableArray new];
    return _inventedStaffArray;
}

-(NSMutableArray *)inventedStudentArray {
    if (_inventedStudentArray == nil)
        _inventedStudentArray = [NSMutableArray new];
    return _inventedStudentArray;
}

-(NSArray *)inventedGuysArray {
    if (_inventedGuysArray == nil)
        _inventedGuysArray = [NSArray new];
    return _inventedGuysArray;
}

-(NSMutableArray<StaffList_Results *> *)selectedStaffArray {
    if (_selectedStaffArray == nil)
        _selectedStaffArray = [NSMutableArray new];
    return _selectedStaffArray;
}

-(NSMutableArray<StudentList_Results *> *)selectedStudentArray {
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
    
    if (self.inventedStaffArray.count == 0) {
        [SysTool showLoadingHUDWithMsg:@"获取员工列表" duration:0];
        NSDictionary *reqDict = @{@"staff_username":[LoginInfoModel fetchAccountUsername],
                                  @"for_appointment":@YES};
        [[SYHttpTool sharedInstance] getReqWithURL:STAFF_LIST token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                StaffListModel *model = [StaffListModel mj_objectWithKeyValues:responseObject];
                self.inventedStaffArray = [model.results mutableCopy];
                self.StaffNextURL = model.next;
                self.inventedGuysArray = self.inventedStaffArray;
                [self.inventGuysList reloadData];
            } else {
                [SysTool showErrorWithMsg:msg duration:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        self.inventedGuysArray = self.inventedStaffArray;
        [self.inventGuysList reloadData];
    }
}

- (IBAction)selectCheckInRecord:(UIButton *)sender {
    [self.inventGuysList.mj_footer resetNoMoreData];
    self.checkInRecordsLB.textColor = [UIColor colorWithHexString:@"#3FC6A0"];
    self.meetingLB.textColor = [UIColor colorWithHexString:@"#43434D"];
    self.selectTitleLB.text = @"请选择约谈学生";
    self.scheduleType = StaffCheckInRecordsType;
    
    if (self.inventedStudentArray.count == 0) {
        [SysTool showLoadingHUDWithMsg:@"获取学生列表" duration:0];
        NSDictionary *reqDict = @{@"staff_username":[LoginInfoModel fetchAccountUsername]};
        [[SYHttpTool sharedInstance] getReqWithURL:STUDENT_LIST token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                StudentListModel *model = [StudentListModel mj_objectWithKeyValues:responseObject];
                self.inventedStudentArray = [model.results mutableCopy];
                self.StudentNextURL = model.next;
                self.inventedGuysArray = self.inventedStudentArray;
                [self.inventGuysList reloadData];
            } else {
                [SysTool showErrorWithMsg:msg duration:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        self.inventedGuysArray = self.inventedStudentArray;
        [self.inventGuysList reloadData];
    }
}

- (IBAction)finishSelection:(UIButton *)sender {
    NSMutableArray *fullNameArray = [NSMutableArray new];
    if (self.mode == ModifyMode) {
        if (self.scheduleType == MeetingType) {
            for (StaffList_Results *info in self.selectedStaffArray) {
                [fullNameArray addObject:info.full_name];
            }
        } else {
            for (StudentList_Results *info in self.selectedStudentArray) {
                [fullNameArray addObject:info.full_name];
            }
        }
        if (self.modifyBlk != nil) self.modifyBlk(fullNameArray);
    } else { // 新增模式
        if (self.scheduleType == MeetingType) {
            for (StaffList_Results *info in self.selectedStaffArray) {
                [fullNameArray addObject:info.full_name];
            }
        } else {
            for (StudentList_Results *info in self.selectedStudentArray) {
                [fullNameArray addObject:info.full_name];
            }
        }
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
                    [self.inventedStaffArray addObjectsFromArray:model.results];
                    self.inventedGuysArray = self.inventedStaffArray;
                } else {
                    StudentListModel *model = [StudentListModel mj_objectWithKeyValues:responseObject];
                    self.StudentNextURL = model.next;
                    [self.inventedStudentArray addObjectsFromArray:model.results];
                    self.inventedGuysArray = self.inventedStudentArray;
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
    return self.inventedGuysArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.scheduleType == MeetingType) { // 会议，对应 Meeting Cell
        Schedule_MeetingCell *cell = (Schedule_MeetingCell*)[tableView dequeueReusableCellWithIdentifier:@"staffMeeting"];
        NSArray<StaffList_Results*> *array = self.inventedGuysArray;
        cell.nameLb.text = array[indexPath.row].full_name;
        cell.tipImg.hidden = [self.selectedStaffArray containsObject:self.inventedStaffArray[indexPath.row]]?NO:YES;
        return cell;
    } else {
        Schedule_RecordCell *cell = (Schedule_RecordCell*)[tableView dequeueReusableCellWithIdentifier:@"studentRecord"];
        NSArray<StudentList_Results*> *array = self.inventedGuysArray;
        cell.nameLB.text = array[indexPath.row].full_name;
        cell.tipImg.hidden = [self.selectedStudentArray containsObject:self.inventedStudentArray[indexPath.row]]?NO:YES;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.scheduleType == MeetingType) { // 会议，对应 Meeting Cell
        Schedule_MeetingCell *cell = [self.inventGuysList cellForRowAtIndexPath:indexPath];
        cell.tipImg.hidden = [self.selectedStaffArray containsObject:self.inventedStaffArray[indexPath.row]]?YES:NO;
        if ([self.selectedStaffArray containsObject:self.inventedStaffArray[indexPath.row]]) {
            [self.selectedStaffArray removeObject:self.inventedStaffArray[indexPath.row]];
        } else
            [self.selectedStaffArray addObject:self.inventedStaffArray[indexPath.row]];
    } else {
        Schedule_RecordCell *cell = [self.inventGuysList cellForRowAtIndexPath:indexPath];
        cell.tipImg.hidden = [self.selectedStudentArray containsObject:self.inventedStudentArray[indexPath.row]]?YES:NO;
        if ([self.selectedStudentArray containsObject:self.inventedStudentArray[indexPath.row]]) {
            [self.selectedStudentArray removeObject:self.inventedStudentArray[indexPath.row]];
        } else
            [self.selectedStudentArray addObject:self.inventedStudentArray[indexPath.row]];
    }
}
@end

@implementation Schedule_RecordCell


@end

@implementation Schedule_MeetingCell


@end
