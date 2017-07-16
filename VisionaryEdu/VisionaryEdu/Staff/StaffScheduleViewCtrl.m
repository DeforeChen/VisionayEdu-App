//
//  StaffScheduleViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/29.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StaffScheduleViewCtrl.h"
#import "config.h"
#import <FSCalendar/FSCalendar.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "UIColor+expanded.h"
#import "ScheduleRangeManager.h"
#import "StaffScheduleModel.h"
#import "StaffScheduleCellManager.h"

#import "MeetingDetailsViewCtrl.h"
#import "CheckInRecordDetailsViewCtrl.h"

#define MeetingColor [UIColor colorWithHexString:@"#FFB679"]
#define CheckInRecordsColor [UIColor colorWithHexString:@"#4ED6BB"]

@interface StaffScheduleViewCtrl ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UITableView *scheduleListTB;

@property (strong, nonatomic) NSCalendar *systemCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) ScheduleRangeManager *manager;
@property (copy, nonatomic) NSString *selectDate;

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectDateLB;
@property (weak, nonatomic) IBOutlet UILabel *totalEventsLB;

@property (copy,nonatomic) NSArray *dayCheckInRecordsArray;// 某天的 record 日程数组
@property (copy,nonatomic) NSArray *dayMeetingArray;// 某天的 meeting 日程数组
@property (strong,nonatomic) NSMutableDictionary *scheduleLUT ;// 查询日历，从model的 fetchScheduleLUT获取
@end

@implementation StaffScheduleViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshBtn.layer.cornerRadius = 10.0f;
    self.refreshBtn.layer.borderColor  = [UIColor colorWithHexString:@"#3E3D4E"].CGColor;
    self.refreshBtn.layer.borderWidth = 1.0f;
    self.refreshBtn.clipsToBounds = YES;
    // Do any additional setup after loading the view.
    self.systemCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.selectDate = [self.dateFormatter stringFromDate:[NSDate new]];
    self.scheduleListTB.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshScheduleWhenEmpty:)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.scheduleLUT removeAllObjects];
    self.manager = [ScheduleRangeManager initWithDateFormatter:self.dateFormatter];

    NSDate *date = [self.dateFormatter dateFromString:self.selectDate];
    [self requestStaffScheduleInfo:date];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getter
-(NSArray *)dayMeetingArray {
    if (_dayMeetingArray == nil)
        _dayMeetingArray = [NSArray new];
    return _dayMeetingArray;
}

-(NSArray *)dayCheckInRecordsArray {
    if (_dayCheckInRecordsArray == nil)
        _dayCheckInRecordsArray = [NSArray new];
    return _dayCheckInRecordsArray;
}

-(NSMutableDictionary *)scheduleLUT {
    if (_scheduleLUT == nil)
        _scheduleLUT = [NSMutableDictionary new];
    return _scheduleLUT;
}

#pragma mark Setter
-(void)setSelectDate:(NSString *)selectDate {
    _selectDate = selectDate;
    NSDate *date = [self.dateFormatter dateFromString:_selectDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日";
    
    self.selectDateLB.text = [formatter stringFromDate:date];
    [self updateDayScheduleWhenSelectionChange];
}

#pragma mark Private Methods
- (IBAction)refreshScheduleWhenEmpty:(UIButton *)sender {
    [self.scheduleLUT removeAllObjects];
    self.manager = nil;
    self.manager = [ScheduleRangeManager initWithDateFormatter:self.dateFormatter];
    [self requestStaffScheduleInfo:[self.dateFormatter dateFromString:self.selectDate]];
    if (self.scheduleListTB.hidden == NO) {
        [self.scheduleListTB.mj_header endRefreshing];
    }
}


/**
 根据传入的时间，判断这个时间是否在已显示的范围内，若超过，则开始申请数据
 @param date 日期
 */
-(void)requestStaffScheduleInfo:(NSDate*)date {
    [self.manager judgeDateBeyondRange:date callback:^(BOOL isBeyondRange, NSArray *newRange) {
        if (isBeyondRange == YES) {
            [SysTool showLoadingHUDWithMsg:@"员工日程加载中..." duration:0];
            NSDictionary *reqDict = [StaffScheduleRequest initStaffScheduleReqWithStartDate:newRange[START_DATE]
                                                                                    endDate:newRange[END_DATE]
                                                                             staff_username:[LoginInfoModel fetchAccountUsername]].mj_keyValues;
            
            [[SYHttpTool sharedInstance] getReqWithURL:QUERY_STAFF_SCHEDULE token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    StaffScheduleResponse *model = [StaffScheduleResponse mj_objectWithKeyValues:responseObject];
                    [self.scheduleLUT addEntriesFromDictionary:[model fetchStaffScheduleLUT]];
                    // 添加model返回的内容到各自的信息数组中
                    [self.calendar reloadData];
                    [self updateDayScheduleWhenSelectionChange];
                } else
                    [SysTool showErrorWithMsg:msg duration:1];
            }];
        }
    }];
}

-(NSInteger)calcTotalEventTypeWithDate:(NSString*)date {
    NSInteger typeNum = 0;
    if ([self.scheduleLUT[date][MeetingType] count] > 0)
        typeNum++;
    if ([self.scheduleLUT[date][StaffCheckInRecordsType] count] > 0)
        typeNum++;
    return typeNum;
}

-(void)changePreviousPage:(BOOL)isPrevious {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *month = [self.systemCalendar dateByAddingUnit:NSCalendarUnitMonth value:isPrevious?-1:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:month animated:YES];
}

-(void)updateDayScheduleWhenSelectionChange {
    // 根据选中天数，取出对应的事件，若LUT中不包含这一天，则不赋值。array为空
    NSString *date = self.selectDate;
    if (self.scheduleLUT[date][MeetingType] != nil)
        self.dayMeetingArray = self.scheduleLUT[date][MeetingType];
    if (self.scheduleLUT[date][StaffCheckInRecordsType] != nil)
        self.dayCheckInRecordsArray = self.scheduleLUT[date][StaffCheckInRecordsType];
    
    // 显示总的事件
    NSInteger total = self.dayMeetingArray.count + self.dayCheckInRecordsArray.count;
    self.totalEventsLB.text = [NSString stringWithFormat:@"共%d事件",(int)total];
    
    // 根据选中天数的事件是否为空，判断底部的tableview是否显示
    if ([self calcTotalEventTypeWithDate:date] != 0) {
        self.scheduleListTB.hidden = NO;
        [self.scheduleListTB reloadData];
    } else {
        self.scheduleListTB.hidden = YES;
    }
}


#pragma mark UserInteraction
- (IBAction)backtoStaffHomepage:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoToday:(UIButton *)sender {
    NSDate *date = [NSDate date];
    [self.calendar setCurrentPage:date animated:YES];
    [self.calendar selectDate:date];
    [self calendar:self.calendar didSelectDate:date atMonthPosition:FSCalendarMonthPositionCurrent];
}

- (IBAction)addNewEvent:(UIButton *)sender {
}

- (IBAction)previousMonth:(UIButton *)sender {
    [self changePreviousPage:YES];
}

- (IBAction)nextMonth:(UIButton *)sender {
    [self changePreviousPage:NO];
}

#pragma mark <Tableview delegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case MeetingType:
            return self.dayMeetingArray.count;
            break;
        case StaffCheckInRecordsType:
            return self.dayCheckInRecordsArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row     = indexPath.row;
    switch (section) {
        case MeetingType:
            return [StaffMeetingCell initMyCellWithMeetingModel:self.dayMeetingArray[row] tableview:tableView];
            break;
        case StaffCheckInRecordsType:
            return [StaffCheckInRecordsCell initMyCellWithStaffRecordModel:self.dayCheckInRecordsArray[row] tableview:tableView];
            break;
    }
    return nil;
}

#pragma mark FSCalendar delegate
-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    self.selectDate = [self.dateFormatter stringFromDate:calendar.currentPage];
    [self requestStaffScheduleInfo:calendar.currentPage];
}

#pragma mark - <FSCalendarDataSource>
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSInteger totalEventNum = [self calcTotalEventTypeWithDate:dateString];
//    XLog(@"%@事件总数 %d",dateString,(int)totalEventNum);
    return totalEventNum;
}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    // 2.更新选中天
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    self.selectDate = dateStr;
}

#pragma mark - <FSCalendarDelegateAppearance>
- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSMutableArray *eventColors = [NSMutableArray new];

    if ([self.scheduleLUT[dateString][MeetingType] count] > 0)
        [eventColors addObject:MeetingColor];
    if ([self.scheduleLUT[dateString][StaffCheckInRecordsType] count] > 0)
        [eventColors addObject:CheckInRecordsColor];
    
    XLog(@"事件颜色总数 %d",(int)eventColors.count);
    return eventColors;
}

-(NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date {
    // 选中事件，颜色不改变
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSMutableArray *eventColors = [NSMutableArray new];
    if ([self.scheduleLUT[dateString][MeetingType] count] > 0)
        [eventColors addObject:MeetingColor];
    if ([self.scheduleLUT[dateString][StaffCheckInRecordsType] count] > 0)
        [eventColors addObject:CheckInRecordsColor];
    return eventColors;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[MeetingDetailsViewCtrl class]]) {
        MeetingDetailsViewCtrl *vc = destVC;
        NSIndexPath *path = [self.scheduleListTB indexPathForCell:sender];
        XLog(@"会议对应点击的行数 = %@",path);
        vc.meetingModel = self.dayMeetingArray[path.row];
    } else if([destVC isKindOfClass:[CheckInRecordDetailsViewCtrl class]]){
        CheckInRecordDetailsViewCtrl *vc = destVC;
        NSIndexPath *path = [self.scheduleListTB indexPathForCell:sender];
        XLog(@"约谈对应点击的行数 = %@",path);
        vc.recordModel = self.dayCheckInRecordsArray[path.row];
    }
}
@end
