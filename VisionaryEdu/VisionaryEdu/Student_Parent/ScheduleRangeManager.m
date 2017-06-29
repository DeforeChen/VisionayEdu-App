//
//  ScheduleRangeManager.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/29.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ScheduleRangeManager.h"

@interface ScheduleRangeManager()
@property (strong,nonatomic) NSMutableArray *scheduleRangeArray;
@property (strong,nonatomic) NSDateFormatter *formatter;
@property (copy,nonatomic) BeyondRangeBlk callback;
@end

@implementation ScheduleRangeManager
-(NSMutableArray *)scheduleRangeArray {
    if (_scheduleRangeArray == nil) {
        _scheduleRangeArray = [NSMutableArray new];
    }
    return _scheduleRangeArray;
}

+(instancetype)initWithDateFormatter:(NSDateFormatter*)formatter {
    ScheduleRangeManager *manager = [ScheduleRangeManager new];
    manager.formatter = formatter;
    return manager;
}

-(void)judgeDateBeyondRange:(NSDate*)givenDate callback:(BeyondRangeBlk)blk {
    self.callback = blk;
    // 1.将日期转化成字符串
    NSString *date = [self.formatter stringFromDate:givenDate];
    
    // 2. 先根据日期去生成一个日程范围
    NSMutableArray *newRange = [self generateNewScheduleRangeWithDate:date];
    // 2.判断日期范围是否已存在，若不存在，就将刚刚创建的赋值进去
    if (self.scheduleRangeArray.count == 0) {
        self.scheduleRangeArray = newRange;
        // 2.1 返回“超过范围”，“新的范围”
        if (self.callback)
            self.callback(YES,self.scheduleRangeArray);
    } else {
        /* 2.2 若已存在范围，那么根据新的范围，求出新的并集。在并集函数中做判断，
        如果新旧范围一致，就不产生新的范围*/
        [self fetchUnionRangeWithNewRange:newRange];
    }
}

-(NSMutableArray*)generateNewScheduleRangeWithDate:(NSString*)date {
    int month = [[date substringWithRange:NSMakeRange(5, 2)] intValue];
    NSString *year = [date substringToIndex:4];
    NSMutableArray *rangeArray = [@[@"start",@"end"] mutableCopy];
    
    if (month > 6 && month <= 12) {
        rangeArray[START_DATE] = [NSString stringWithFormat:@"%@-07-01",year];
        rangeArray[END_DATE] = [NSString stringWithFormat:@"%@-12-31",year];
    } else if(month >= 1 && month <= 6) {
        rangeArray[START_DATE] = [NSString stringWithFormat:@"%@-01-01",year];
        rangeArray[END_DATE] = [NSString stringWithFormat:@"%@-06-30",year];
    } else {
        [rangeArray removeAllObjects];
        NSLog(@"非法的月份输入");
    }
    return rangeArray;
}

// 获取新旧范围的并集数组
-(void)fetchUnionRangeWithNewRange:(NSMutableArray*)newRange {
    NSDate *newStartDate = [self.formatter dateFromString:newRange[START_DATE]];
    NSDate *newEndDate   = [self.formatter dateFromString:newRange[END_DATE]];
    
    NSDate *oldStartDate = [self.formatter dateFromString:self.scheduleRangeArray[START_DATE]];
    NSDate *oldEndDate   = [self.formatter dateFromString:self.scheduleRangeArray[END_DATE]];
    /* 假设旧的范围是        [2015-01-01,2015-06-30],
     新的范围一定是紧跟着他的  前[2014-07-01,2014-12-31],或 后[2015-07-01,2015-12-31],
     原因是日历一定是按月份滑动产生的，因此不会突然跳跃半年去生成一个范围
     */
    
    // 新日期范围先于当前范围
    if ([newEndDate timeIntervalSinceDate:oldStartDate] < 0 ) {
        self.scheduleRangeArray[START_DATE] = [self.formatter stringFromDate:newStartDate];
        self.scheduleRangeArray[END_DATE]   = [self.formatter stringFromDate:oldEndDate];//这句其实不用写，但是为了方便阅读
        if (self.callback) self.callback(YES, newRange);
    } else if([oldEndDate timeIntervalSinceDate:newStartDate] < 0) {
        self.scheduleRangeArray[START_DATE] = [self.formatter stringFromDate:oldStartDate];//这句其实不用写，但是为了方便阅读
        self.scheduleRangeArray[END_DATE]   = [self.formatter stringFromDate:newEndDate];
        if (self.callback) self.callback(YES, newRange);
    } else if([newRange[START_DATE] isEqualToString:self.scheduleRangeArray[START_DATE]] && \
              [newRange[END_DATE] isEqualToString:self.scheduleRangeArray[END_DATE]]) {
        if (self.callback) self.callback(NO, nil);
    }
    
}
@end
