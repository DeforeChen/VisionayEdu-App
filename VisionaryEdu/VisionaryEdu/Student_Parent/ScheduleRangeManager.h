//
//  ScheduleRangeManager.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/29.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#define START_DATE 0
#define END_DATE  1

typedef void(^BeyondRangeBlk)(BOOL isBeyondRange,NSArray *newRange);
@interface ScheduleRangeManager : NSObject

/**
 根据日期格式初始化manager

 @param formatter 日期格式化格式
 @return manager
 */
+(instancetype)initWithDateFormatter:(NSDateFormatter*)formatter ;


/**
 判断给定的日期是否超过日程日期的范围。并作相应回调

 @param givenDate <#givenDate description#>
 @param blk <#blk description#>
 */
-(void)judgeDateBeyondRange:(NSDate*)givenDate callback:(BeyondRangeBlk)blk;
@end
