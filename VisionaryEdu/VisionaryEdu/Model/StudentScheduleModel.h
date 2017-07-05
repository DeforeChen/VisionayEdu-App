//
//  StudentScheduleModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/28.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark Request
@interface StudentScheduleReq : NSObject
@property (copy, nonatomic) NSString *student_username;
@property (copy, nonatomic) NSString *start_date;
@property (copy, nonatomic) NSString *end_date;

+(instancetype)initStudentScheduleReqWithStartDate:(NSString*)start
                                           endDate:(NSString*)end
                                   studentUsername:(NSString*)username;
@end

#pragma mark Response

@interface Tasks :NSObject
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * task_file;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * due_date;
@property (nonatomic , assign) BOOL              whether_submit;

@end

@interface FutureTests :NSObject
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , assign) NSInteger              test_type;
@property (nonatomic , assign) BOOL              whether_record_score;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , assign) NSInteger              pk;

@end

@interface CheckInRecords :NSObject
@property (nonatomic , copy) NSString              * staff_real_name;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * topic;
@property (nonatomic , copy) NSString              * staff_username;
@property (nonatomic , assign) NSInteger              pk;

@end

typedef enum : NSUInteger {
    TaskType = 0,
    FutureTestType,
    CheckInRecordsType,
} ScheduleType;
@interface StudentScheduleResponse :NSObject
@property (nonatomic , strong) NSArray<Tasks *>           * Tasks;
@property (nonatomic , strong) NSArray<FutureTests *>     * FutureTests;
@property (nonatomic , strong) NSArray<CheckInRecords *>  * CheckInRecords;


/**
 让model根据日期重组一个查询的字典，键值对为 日期 - 二维数组
 例如：
 @"2017-12-18":@[ @[task1,task2,task3],
 @[test1,test2,test3],
 @[record1,record2,record3]
 ]
 @return LUT
 */
-(NSDictionary*)fetchScheduleLUT ;
@end
