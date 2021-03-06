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

@implementation FutureTestCell
+(FutureTestCell *)initMyCellWithTableview:(UITableView *)tableview testModel:(FutureTests*)test {
    FutureTestCell *cell = (FutureTestCell*)[tableview dequeueReusableCellWithIdentifier:@"futureTest"];
    cell.testTimeLB.text = [test.time substringToIndex:5];
    cell.testPlaceLB.text = test.place;
    switch (test.test_type) {
        case ToeflType:
            cell.testTypeLB.text = @"托福";
            break;
        case ieltsType:
            cell.testTypeLB.text = @"雅思";
            break;
        case SatType:
            cell.testTypeLB.text = @"SAT";
            break;
        case ActType:
            cell.testTypeLB.text = @"ACT";
            break;
        case Sat2Type:
            cell.testTypeLB.text = @"SAT2";
            break;
        case APType:
            cell.testTypeLB.text = @"AP考试";
            break;
//        case IBType:
//            cell.testTypeLB.text = @"IB考试";
//            break;
    }
    return cell;
}
@end

@interface CheckInRecordsCell()
@property (weak, nonatomic) IBOutlet UILabel *topicLB;

@property (weak, nonatomic) IBOutlet UILabel *consultantLB;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLB;
@end

@implementation CheckInRecordsCell
+(CheckInRecordsCell *)initMyCellWithTableview:(UITableView *)tableview recordModel:(StudentCheckInRecords*)record {
    CheckInRecordsCell *cell = (CheckInRecordsCell*)[tableview dequeueReusableCellWithIdentifier:@"checkInRecord"];
    cell.topicLB.text      = record.topic;
    cell.consultantLB.text = [NSString stringWithFormat:@"顾问: %@",record.staff_real_name];
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
    TasksCell *cell      = (TasksCell*)[tableview dequeueReusableCellWithIdentifier:@"tasks"];
    cell.titleLB.text    = task.title;
    cell.taskTimeLB.text = [task.due_date substringFromIndex:5];
    return cell;
}
@end

