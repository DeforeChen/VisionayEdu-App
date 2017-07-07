//
//  FamilyInfoModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "FamilyInfoModel.h"
#import <MJExtension/MJExtension.h>

@implementation Mother

@end

@implementation Fahter

@end

@implementation Sibling

@end

@implementation FamilyInfoModel

+(void)initModelWithResponse:(id)response callback:(FamilyInfo)block {
    id info = [response objectForKey:@"results"];
    if ([info count] == 0) {
        block([Fahter new],[Mother new],[NSArray array]);
        return;
    } else
        info = [[response objectForKey:@"results"] objectAtIndex:0];
    
    NSDictionary *infoDict = (NSDictionary*)info;
    Fahter *father = [Fahter new];
    Mother *mother = [Mother new];
    NSMutableArray *siblingTemp = [NSMutableArray new];
    NSMutableDictionary *fatherModel = [NSMutableDictionary new];
    NSMutableDictionary *motherModel = [NSMutableDictionary new];
    // 第一轮遍历，将所有的内容分类
    for (NSString *key in [infoDict allKeys]) {
        if ([key containsString:@"father"]) {
            [fatherModel setObject:infoDict[key] forKey:key];
        } else if ([key containsString:@"mother"]) {
            [motherModel setObject:infoDict[key] forKey:key];
        } else if ([key containsString:@"sibling"]) {
            [siblingTemp addObject:key];
        }
    }
    // 分类后，可以用MJExtension取出数据生成模型
    father = [Fahter mj_objectWithKeyValues:fatherModel];
    mother = [Mother mj_objectWithKeyValues:motherModel];
    
    // 第二轮遍历，整理 sibling数据
    NSUInteger number = siblingTemp.count/5;
    NSMutableArray<Sibling*> *siblingArray = [NSMutableArray new];
    if (number > 0 && block != nil) {
        for (int index = 0; index < number; index++) {
            [siblingArray addObject:[Sibling new]];
        }
        
        for (NSString *key in siblingTemp) {
            int index = [[[key componentsSeparatedByString:@"_"] objectAtIndex:1] intValue]-1;
            if ([key containsString:@"name"]) {
                siblingArray[index].name = infoDict[key];
            } else if ([key containsString:@"gender"]) {
                siblingArray[index].gender = infoDict[key];
            } else if ([key containsString:@"degree"]) {
                siblingArray[index].degree = infoDict[key];
            } else if ([key containsString:@"relation"]) {
                siblingArray[index].relation = infoDict[key];
            } else {
                siblingArray[index].birthday = infoDict[key];
            }
        }
    }
    
    block(father,mother,siblingArray);
}
@end
