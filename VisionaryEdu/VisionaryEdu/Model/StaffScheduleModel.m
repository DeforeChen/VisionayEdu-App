//
//  StaffScheduleModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StaffScheduleModel.h"
#import <MJExtension/MJExtension.h>
#import "StudentScheduleModel.h"

#pragma mark Request
@implementation StaffScheduleRequest
+(instancetype)initStaffScheduleReqWithStartDate:(NSString *)start endDate:(NSString *)end staff_username:(NSString *)username {
    StaffScheduleRequest *req = [StaffScheduleRequest new];
    req.staff_username = username;
    req.start_date = start;
    req.end_date   = end;
    return req;
}

@end

#pragma mark Response
@implementation Meetings

@end

@implementation StaffCheckInRecords

@end

@implementation StaffScheduleResponse
+(NSDictionary *)objectClassInArray{ //这种方式用插件已经可以直接生成
    return @{@"Meetings"      : [Meetings class],
             @"CheckInRecords": [StaffCheckInRecords class]
             };
}

#pragma mark Public Methods
-(NSDictionary *)fetchStaffScheduleLUT {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    // 遍历model中的两个sub model类, 取出sub model的值，根据对应的日期，存储成一个新的字典
    for (Meetings *meeting in self.Meetings) {
        if (meeting.date.length > 0) {
            if ([[dict allKeys] containsObject:meeting.date] == NO)
                [dict setObject:[self CreatDayScheduleArray] forKey:meeting.date];
            
            [dict[meeting.date][MeetingType] addObject:meeting];
        }
    }
    
    for (StaffCheckInRecords *record in self.CheckInRecords) {
        if (record.date.length > 0) {
            if ([[dict allKeys] containsObject:record.date] == NO)
                [dict setObject:[self CreatDayScheduleArray] forKey:record.date];
            
            [dict[record.date][StaffCheckInRecordsType] addObject:record];
        }
    }
    
    NSLog(@"重组后的员工日程LUT = %@",dict);
    return dict;
}

-(NSArray<NSArray*>*)CreatDayScheduleArray {
    //1. 创建三个可变数组，各自存放某一天的两种日程
    NSMutableArray<Meetings*> *dayMeetingScheduleArray      = [NSMutableArray new];
    NSMutableArray<CheckInRecords*> *dayRecordScheduleArray = [NSMutableArray new];
    //2. 创建一个可变的二维数组，存放这一天总的两种日程
    NSMutableArray *dayScheduleArray = [NSMutableArray new];
    dayScheduleArray[MeetingType]             = dayMeetingScheduleArray;
    dayScheduleArray[StaffCheckInRecordsType] = dayRecordScheduleArray;
    return dayScheduleArray;
}
@end

