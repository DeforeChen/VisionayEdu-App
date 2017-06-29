//
//  StudentScheduleCellManager.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/28.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentScheduleCellManager.h"
#import "StudentScheduleModel.h"
@interface FutureTestCell()
@property (weak, nonatomic) IBOutlet UILabel *testTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *testTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *testPlaceLB;
@end

typedef enum : NSUInteger {
    Toefl = 0,
    ielts = 1,
    SAT,
    ACT,
    SAT2,
    AP,
    IB
} testType;
@implementation FutureTestCell
+(FutureTestCell *)initMyCellWithTableview:(UITableView *)tableview testModel:(FutureTests*)test {
    FutureTestCell *cell = (FutureTestCell*)[tableview dequeueReusableCellWithIdentifier:@"futureTest"];
    switch (test.test_type) {
        case Toefl:
            cell.testTypeLB.text = @"托福";
            break;
        case ielts:
            cell.testTypeLB.text = @"雅思";
            break;
        case SAT:
            cell.testTypeLB.text = @"SAT";
            break;
        case ACT:
            cell.testTypeLB.text = @"ACT";
            break;
        case SAT2:
            cell.testTypeLB.text = @"SAT2";
            break;
        case AP:
            cell.testTypeLB.text = @"AP考试";
            break;
        case IB:
            cell.testTypeLB.text = @"IB考试";
            break;
    }
    return cell;
}
@end

@interface CheckInRecordsCell()
@property (weak, nonatomic) IBOutlet UILabel *topicLB;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLB;
@end

@implementation CheckInRecordsCell
+(CheckInRecordsCell *)initMyCellWithTableview:(UITableView *)tableview recordModel:(CheckInRecords*)record {
    CheckInRecordsCell *cell = (CheckInRecordsCell*)[tableview dequeueReusableCellWithIdentifier:@"checkInRecord"];
    cell.topicLB.text      = record.topic;
    cell.recordTimeLB.text = record.time;
    return cell;
}
@end


@interface TasksCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *taskTimeLB;
@end

@implementation TasksCell
+(TasksCell *)initMyCellWithTableview:(UITableView *)tableview taskModel:(Tasks*)task {
    TasksCell *cell = (TasksCell*)[tableview dequeueReusableCellWithIdentifier:@"tasks"];
    cell.titleLB.text = task.title;
    return cell;
}
@end

