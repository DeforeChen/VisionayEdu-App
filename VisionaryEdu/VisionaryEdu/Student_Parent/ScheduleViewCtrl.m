//
//  ScheduleViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/26.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ScheduleViewCtrl.h"
#import "StudentScheduleModel.h"
#import "config.h"
#import <FSCalendar/FSCalendar.h>
#import <MJExtension/MJExtension.h>
#import "UIColor+expanded.h"
#import "ScheduleRangeManager.h"
#import "StudentScheduleCellManager.h"

#define TestColor           [UIColor colorWithHexString:@"#E67291"]
#define CheckInRecordsColor [UIColor colorWithHexString:@"#4ED6BB"]
#define TaskColor           [UIColor colorWithHexString:@"#1ABFDF"]

@interface ScheduleViewCtrl ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate>
@property (weak,  nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UITableView *schedulelistTB;

@property (strong, nonatomic) NSCalendar *systemCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) ScheduleRangeManager *manager;
@property (copy, nonatomic) NSString *selectDate;
@property (weak, nonatomic) IBOutlet UILabel *selectDateLB;
@property (weak, nonatomic) IBOutlet UILabel *totalEventsLB;

@property (copy,nonatomic) NSArray *dayTasksArray;       // 某天的task 日程数组
@property (copy,nonatomic) NSArray *dayFutureTestArray;  // 某天的test 日程数组
@property (copy,nonatomic) NSArray *dayCheckInRecordsArray;// 某天的 record 日程数组
@property (strong,nonatomic) NSMutableDictionary *scheduleLUT ;// 查询日历，从model的 fetchScheduleLUT获取
@end

@implementation ScheduleViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.systemCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.manager = [ScheduleRangeManager initWithDateFormatter:self.dateFormatter];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.selectDate = [self.dateFormatter stringFromDate:[NSDate new]];
    [self requestStudentScheduleInfo:[NSDate new]];
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
-(NSArray *)dayTasksArray {
    if (_dayTasksArray == nil)
        _dayTasksArray = [NSArray new];
    return _dayTasksArray;
}

-(NSArray *)dayFutureTestArray {
    if (_dayFutureTestArray == nil)
        _dayFutureTestArray = [NSArray new];
    return _dayFutureTestArray;
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
/**
 根据传入的时间，判断这个时间是否在已显示的范围内，若超过，则开始申请数据
 @param date 日期
 */
-(void)requestStudentScheduleInfo:(NSDate*)date {
    [self.manager judgeDateBeyondRange:date callback:^(BOOL isBeyondRange, NSArray *newRange) {
        if (isBeyondRange == YES) {
            [SysTool showLoadingHUDWithMsg:@"学生日程加载中..." duration:0];
            NSDictionary *reqDict = [StudentScheduleReq initStudentScheduleReqWithStartDate:newRange[START_DATE]
                                                                                    endDate:newRange[END_DATE]
                                                                            studentUsername:@"student_1"].mj_keyValues;//[StudentInstance shareInstance].student_username

            [[SYHttpTool sharedInstance] getReqWithURL:QUERY_STUDENT_SCHEDULE token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    StudentScheduleResponse *model = [StudentScheduleResponse mj_objectWithKeyValues:responseObject];
                    [self.scheduleLUT addEntriesFromDictionary:[model fetchScheduleLUT]];
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
    if ([self.scheduleLUT[date][TaskType] count] > 0)
        typeNum++;
    if ([self.scheduleLUT[date][CheckInRecordsType] count] > 0)
        typeNum++;
    if ([self.scheduleLUT[date][FutureTestType] count] > 0)
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
    if (self.scheduleLUT[date][TaskType] != nil)
        self.dayTasksArray = self.scheduleLUT[date][TaskType];
    if (self.scheduleLUT[date][CheckInRecordsType] != nil)
        self.dayCheckInRecordsArray = self.scheduleLUT[date][CheckInRecordsType];
    if (self.scheduleLUT[date][FutureTestType] != nil)
        self.dayFutureTestArray = self.scheduleLUT[date][FutureTestType];
    
    // 根据选中天数的事件是否为空，判断底部的tableview是否显示
    if ([self calcTotalEventTypeWithDate:date] != 0) {
        self.schedulelistTB.hidden = NO;
        [self.schedulelistTB reloadData];
    } else {
        self.schedulelistTB.hidden = YES;
    }
}

#pragma mark User Interaction
- (IBAction)studentRecentObjectives:(UIButton *)sender {

}

- (IBAction)appendNewEvent:(UIButton *)sender {

}

- (IBAction)gotoToday:(UIButton *)sender {
    NSDate *date = [NSDate date];
    [self.calendar setCurrentPage:date animated:YES];
    [self.calendar selectDate:date];
}

- (IBAction)previousMonth:(UIButton *)sender {
    [self changePreviousPage:YES];
}

- (IBAction)nextMonth:(UIButton *)sender {
    [self changePreviousPage:NO];
}


#pragma mark <Tableview delegate>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case TaskType:
            return self.dayTasksArray.count;
            break;
        case FutureTestType:
            return self.dayFutureTestArray.count;
            break;
        case CheckInRecordsType:
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
        case TaskType:
            return [TasksCell initMyCellWithTableview:tableView taskModel:self.dayTasksArray[row]];
            break;
        case FutureTestType:
            return [FutureTestCell initMyCellWithTableview:tableView testModel:self.dayFutureTestArray[row]];
            break;
        case CheckInRecordsType:
            return [CheckInRecordsCell initMyCellWithTableview:tableView recordModel:self.dayCheckInRecordsArray[row]];
            break;
    }
    return nil;
}

#pragma mark FSCalendar delegate
-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    self.selectDate = [self.dateFormatter stringFromDate:calendar.currentPage];
    [self requestStudentScheduleInfo:calendar.currentPage];
}

#pragma mark - <FSCalendarDataSource>
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSInteger totalEventNum = [self calcTotalEventTypeWithDate:dateString];
    XLog(@"%@事件总数 %d",dateString,(int)totalEventNum);
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

    if ([self.scheduleLUT[dateString][TaskType] count] > 0)
        [eventColors addObject:TaskColor];
    if ([self.scheduleLUT[dateString][CheckInRecordsType] count] > 0)
        [eventColors addObject:CheckInRecordsColor];
    if ([self.scheduleLUT[dateString][FutureTestType] count] > 0)
        [eventColors addObject:TestColor];

    XLog(@"事件颜色总数 %d",(int)eventColors.count);
    return eventColors;
}

-(NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date {
    // 选中事件，颜色不改变
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSMutableArray *eventColors = [NSMutableArray new];
    if ([self.scheduleLUT[dateString][TaskType] count] > 0)
        [eventColors addObject:TaskColor];
    if ([self.scheduleLUT[dateString][CheckInRecordsType] count] > 0)
        [eventColors addObject:CheckInRecordsColor];
    if ([self.scheduleLUT[dateString][FutureTestType] count] > 0)
        [eventColors addObject:TestColor];
    return eventColors;
}

@end
