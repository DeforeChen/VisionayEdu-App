//
//  GradeDetailsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "GradeDetailsViewCtrl.h"
#import "config.h"

#import <MJExtension/MJExtension.h>
#import "TabBarManagerViewCtrl.h"
#import "UIColor+expanded.h"

@interface GradeDetailsViewCtrl ()

@end

@implementation GradeDetailsViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F9"];
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
    return 680;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    gradeDetailCell *cell = (gradeDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"gradeDetail"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 2. 设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:self.gradeModel.date];
    if ([[NSDate new] timeIntervalSinceDate:date] < 0.0f) {
        cell.whetherRecordLB.text = @"未考试";
    } else {
        if (self.gradeModel.whether_record_score == NO) {
            cell.whetherRecordLB.text      = @"未录入";
            cell.whetherRecordLB.textColor = [UIColor redColor];
        } else
            cell.whetherRecordLB.text      = @"已录入";
    } 
    
    switch (self.gradeModel.test_type) {
        case Toefl:
            cell.testTitleLB.text = @"托福";
            break;
        case ielts:
            cell.testTitleLB.text = @"雅思";
            break;
        case SAT:
            cell.testTitleLB.text = @"SAT";
            break;
        case ACT:
            cell.testTitleLB.text = @"ACT";
            break;
        case SAT2:
            cell.testTitleLB.text = @"SAT2";
            break;
        case AP:
            cell.testTitleLB.text = @"AP考试";
            break;
        case IB:
            cell.testTitleLB.text = @"IB考试";
            break;
    }

    cell.timeLB.text = [NSString stringWithFormat:@"%@ %@",self.gradeModel.date,self.gradeModel.time];
    cell.placeLB.text = self.gradeModel.place;

    cell.detailTextView.text = self.gradeModel.details;
    cell.detailTextView.editable = NO;
    cell.selfCommentLB.text = self.gradeModel.student_comment;
    cell.selfCommentLB.editable = NO;
    cell.staffCommentLB.text = self.gradeModel.staff_comment;
    cell.staffCommentLB.editable = NO;
    return cell;
}


@end


@implementation gradeDetailCell

@end
