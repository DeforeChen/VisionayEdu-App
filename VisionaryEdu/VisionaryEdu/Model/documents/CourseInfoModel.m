//
//  CourseInfoModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CourseInfoModel.h"

@implementation ElectiveCoure

@end

@implementation CourseInfoModel
+(void)initModelWithResponse:(id)response callback:(CourseInfo)block {
    id info = [response objectForKey:@"results"];
    if ([info count] == 0) {
        block([NSArray new],[NSArray new]);
        return;
    } else
        info = [[response objectForKey:@"results"] objectAtIndex:0];

    NSDictionary *infoDict = (NSDictionary*)info;
    NSMutableArray *HS_CourseArray = [NSMutableArray new];
    NSMutableArray *ElectiveCourseTempArray = [NSMutableArray new];
    
    // 第一轮遍历，获取到他的 高中必修课信息，及带有选修课名称和选修课描述一起组成的数组
    for (NSString *key in [infoDict allKeys]) {
        if ([key containsString:@"hs12_course_"]) {
            [HS_CourseArray addObject:infoDict[key]];
        } else if ([key containsString:@"elective_course_"]) {
            [ElectiveCourseTempArray addObject:key];
        }
    }
    
    // 第二轮遍历, temp数组中包含的必定是选修的内容，那么真正的数组值就应该对半，设为Num。如果这个值为空，那么就返回一个空的数组。
    // 创建一个num大小的数组，他的索引值对应 elective_course_XX,遍历temp数组，取出xx-1作为索引值，然后生成新的数组。
    NSUInteger number = ElectiveCourseTempArray.count/2;
    if (number > 0 && block != nil) {
        NSMutableArray<ElectiveCoure*> *ElectiveCourseArray = [NSMutableArray array];
        for (int index = 0; index < number; index++) {
            [ElectiveCourseArray addObject:[ElectiveCoure new]];
        }

        for (NSString *key in ElectiveCourseTempArray) {
            // elective_course_XX, 取出xx这个索引值
            int index = [[[key componentsSeparatedByString:@"_"] objectAtIndex:2] intValue]-1;
            if ([key containsString:@"description"]) {
                ElectiveCourseArray[index].elective_course_description = infoDict[key];
            } else {
                ElectiveCourseArray[index].elective_course = infoDict[key];
            }
            NSLog(@"index = %d, 选修课名 = %@, 选修课描述 = %@",index,ElectiveCourseArray[index].elective_course,ElectiveCourseArray[index].elective_course_description);
        }

        block(ElectiveCourseArray,HS_CourseArray);
    } else {
        block([NSArray new],HS_CourseArray);
    }
}
@end
