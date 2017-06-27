//
//  ScheduleViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/26.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ScheduleViewCtrl.h"
#import <FSCalendar/FSCalendar.h>

@interface ScheduleViewCtrl ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate>
@property (weak,  nonatomic) IBOutlet FSCalendar *calendar;
@property (strong,nonatomic) NSCalendar *systemCalendar;
@end

@implementation ScheduleViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.systemCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
- (IBAction)studentRecentObjectives:(UIButton *)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.systemCalendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (IBAction)appendNewEvent:(UIButton *)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.systemCalendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}


#pragma mark Tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkInRecord"];
    return cell;
}

#pragma mark FSCalendar delegate
-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar {

}
@end
