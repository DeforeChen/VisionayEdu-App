//
//  StaffScheduleModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CheckInRecords;

#pragma mark Request
@interface StaffScheduleRequest : NSObject
@property (copy, nonatomic) NSString *staff_username;
@property (copy, nonatomic) NSString *start_date;
@property (copy, nonatomic) NSString *end_date;

+(instancetype)initStaffScheduleReqWithStartDate:(NSString*)start
                                         endDate:(NSString*)end
                                  staff_username:(NSString*)username;
@end

#pragma mark Response
@interface Meetings :NSObject
@property (nonatomic , strong) NSArray<NSString *>  * staff_all;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * topic;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , assign) NSInteger              pk;

@end

typedef enum : NSUInteger {
    MeetingType = 0,
    StaffCheckInRecordsType,
    NoneType = 99
} StaffScheduleType;
@interface StaffScheduleResponse :NSObject
@property (nonatomic , strong) NSArray<Meetings *>              * Meetings;
@property (nonatomic , strong) NSArray<CheckInRecords *>        * CheckInRecords;

/**
 让model根据日期重组一个查询的字典，键值对为 日期 - 二维数组
 例如：
 @"2017-12-18":@[ @[meeting1,meeting2,meeting3],
                  @[record1,record2,record3]
                ]
 @return LUT
 */
-(NSDictionary*)fetchStaffScheduleLUT ;
@end
