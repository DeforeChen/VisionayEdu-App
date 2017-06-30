//
//  StudentScheduleModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/28.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentScheduleModel.h"
#import <MJExtension/MJExtension.h>
#pragma mark Request
@implementation StudentScheduleReq
+(instancetype)initStudentScheduleReqWithStartDate:(NSString*)start
                                           endDate:(NSString*)end
                                   studentUsername:(NSString*)username {
    StudentScheduleReq *req = [StudentScheduleReq new];
    req.student_username = username;
    req.start_date = start;
    req.end_date   = end;
    return req;
}

@end

#pragma mark Response

@implementation Tasks
@end

@implementation FutureTests

@end

@implementation CheckInRecords

@end

@interface StudentScheduleResponse()

@end

@implementation StudentScheduleResponse
+(NSDictionary *)objectClassInArray{ //这种方式用插件已经可以直接生成
    return @{@"Tasks"         : [Tasks class],
             @"FutureTests"   : [FutureTests class],
             @"CheckInRecords": [CheckInRecords class]
             };
}

#pragma mark Public Methods
/**
 让model根据日期重组一个查询的字典，键值对为 日期 - 二维数组
 例如：
 @"2017-12-18":@[ @[task1,task2,task3],
                  @[test1,test2,test3],
                  @[record1,record2,record3]
 ]
 @return LUT
 */
-(NSDictionary*)fetchScheduleLUT {
    NSMutableDictionary *dict = [NSMutableDictionary new];

    //3. 遍历model中的三个sub model类, 取出sub model的值，根据对应的日期，存储成一个新的字典
    for (Tasks *task in self.Tasks) {
        if (task.due_date.length > 0) {
            if ([[dict allKeys] containsObject:task.due_date] == NO)
                [dict setObject:[self CreatDayScheduleArray] forKey:task.due_date];
            
            [dict[task.due_date][TaskType] addObject:task];
        }
    }
    
    for (FutureTests *test in self.FutureTests) {
        if (test.date.length > 0) {
            if ([[dict allKeys] containsObject:test.date] == NO)
                [dict setObject:[self CreatDayScheduleArray] forKey:test.date];
            
            [dict[test.date][FutureTestType] addObject:test];
        }
    }

    for (CheckInRecords *record in self.CheckInRecords) {
        if (record.date.length > 0) {
            if ([[dict allKeys] containsObject:record.date] == NO)
                [dict setObject:[self CreatDayScheduleArray] forKey:record.date];
            
            [dict[record.date][CheckInRecordsType] addObject:record];
        }
    }
    
    NSLog(@"重组后的日程LUT = %@",dict);
    return dict;
}

-(NSArray<NSArray*>*)CreatDayScheduleArray {
    //1. 创建三个可变数组，各自存放某一天的三种日程
    NSMutableArray<Tasks*> *dayTaskScheduleArray            = [NSMutableArray new];
    NSMutableArray<FutureTests*> *dayTestScheduleArray      = [NSMutableArray new];
    NSMutableArray<CheckInRecords*> *dayRecordScheduleArray = [NSMutableArray new];
    //2. 创建一个可变的二维数组，存放这一天总的三种日程
    NSMutableArray *dayScheduleArray = [NSMutableArray new];
    dayScheduleArray[TaskType]           = dayTaskScheduleArray;
    dayScheduleArray[FutureTestType]     = dayTestScheduleArray;
    dayScheduleArray[CheckInRecordsType] = dayRecordScheduleArray;
    return dayScheduleArray;
}
@end
