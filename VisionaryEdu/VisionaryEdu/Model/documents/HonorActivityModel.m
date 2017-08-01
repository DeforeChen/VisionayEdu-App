//
//  HonorActivityModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "HonorActivityModel.h"

@implementation HonorActivityModel
+(void)initModelWithResponse:(id)response callback:(HornorActivityInfo)block {
    id info = [response objectForKey:@"results"];
    if ([info count] == 0) {
        block([NSArray new],[NSArray new]);
        return;
    } else
        info = [[response objectForKey:@"results"] objectAtIndex:0];
    
    NSDictionary *infoDict = (NSDictionary*)info;
    NSMutableArray *HonorTempArray = [NSMutableArray new];
    NSMutableArray *ActivityTempArray = [NSMutableArray new];
    
    // 第一轮遍历，分离出 活动 / 荣誉
    for (NSString *key in [infoDict allKeys]) {
        if ([key containsString:@"honor"]) {
            [HonorTempArray addObject:key];
        } else if ([key containsString:@"activity"]) {
            [ActivityTempArray addObject:key];
        }
    }
    
    // 第二轮遍历 一 活动
    NSUInteger number = HonorTempArray.count/6;
    NSMutableArray<Honor*> *HonorArray = [NSMutableArray array];
    if (number > 0 && block != nil) {
        for (int index = 0; index < number; index++) {
            [HonorArray addObject:[Honor new]];
        }
        
        for (NSString *key in HonorTempArray) {
            int index = [[[key componentsSeparatedByString:@"_"] objectAtIndex:1] intValue]-1;
            if ([key containsString:@"title"]) {
                HonorArray[index].title = infoDict[key];
            } else if ([key containsString:@"rank"]) {
                HonorArray[index].rank = infoDict[key];
            } else if ([key containsString:@"date"]) {
                HonorArray[index].date = infoDict[key];
            } else if ([key containsString:@"place"]) {
                HonorArray[index].place = infoDict[key];
            } else if ([key containsString:@"organization"]) {
                HonorArray[index].organization = infoDict[key];
            } else {
                HonorArray[index].supplement = infoDict[key];
            }
        }
    }
    
    // 第二轮遍历 一 荣誉
    NSUInteger num = ActivityTempArray.count/6;
    NSMutableArray<Activity*> *ActivityArray = [NSMutableArray array];
    if (num > 0 && block != nil) {
        for (int index = 0; index < num; index++) {
            [ActivityArray addObject:[Activity new]];
        }

        for (NSString *key in ActivityTempArray) {
            int index = [[[key componentsSeparatedByString:@"_"] objectAtIndex:1] intValue]-1;
            if ([key containsString:@"title"]) {
                ActivityArray[index].title = infoDict[key];
            } else if ([key containsString:@"position"]) {
                ActivityArray[index].position = infoDict[key];
            } else if ([key containsString:@"time_period"]) {
                ActivityArray[index].time_period = infoDict[key];
            } else if ([key containsString:@"place"]) {
                ActivityArray[index].place = infoDict[key];
            } else if ([key containsString:@"actDescription"]) {
                ActivityArray[index].actDescription = infoDict[key];
            } else {
                ActivityArray[index].accomplishment = infoDict[key];
            }
        }
    }
    
    NSLog(@"活动数组个数 = %lu, 荣誉数组个数 = %lu",(unsigned long)ActivityArray.count, (unsigned long)HonorArray.count);
    block(HonorArray,ActivityArray);
}

@end

@implementation Honor

@end

@implementation Activity

@end
