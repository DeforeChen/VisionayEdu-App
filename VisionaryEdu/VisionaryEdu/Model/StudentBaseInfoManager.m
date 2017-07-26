//
//  StudentBaseInfo.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/5/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentBaseInfoManager.h"
#import <MJExtension/MJExtension.h>
#import "config.h"

@implementation StudentInfoModel

@end

@implementation StudentBaseInfo

@end

@implementation StudentBaseInfoManager
+(StudentBaseInfo*)fetchStudentInfoOfGradeFromResponseJSON:(id)responseObject {
    NSArray *gradeKeyArray = [[responseObject mutableCopy] allKeys];
    // 从返回的JSON数据中取出年级组成的keys，然后排序
    NSComparator cmptr = ^(NSString *obj1, NSString *obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    };
    gradeKeyArray = [gradeKeyArray sortedArrayUsingComparator:cmptr];
    XLog(@"排序后的属性列表 = %@",gradeKeyArray);
    
    // 用JSON中的key（年级字段），判断如果他的value非空，那么就把这个年级的索引组成一个数组
    NSMutableArray<NSString*> *validGradeIndexArray    = [[NSMutableArray alloc] init];
    NSMutableArray *totalInfoArray  = [[NSMutableArray alloc] init];
    NSUInteger totalNumber = 0;
    // 遍历所有非空的数组，然后存放为键值对字典
    for (NSString *grade in gradeKeyArray) {
        id gradeValueArray  = [responseObject objectForKey:grade];
        NSArray *currentGradeStudentsArray = [StudentInfoModel mj_objectArrayWithKeyValuesArray:gradeValueArray];
        if (currentGradeStudentsArray.count > 0) {
            XLog(@"%@的学生共%d人",grade,(int)currentGradeStudentsArray.count);
            [validGradeIndexArray addObject:grade];
            [totalInfoArray addObject:currentGradeStudentsArray];
            totalNumber += currentGradeStudentsArray.count;
        }
    }
    
    StudentBaseInfo *info = [StudentBaseInfo new];
    info.gradeIndexArray  = validGradeIndexArray;
    info.studentInfoArray = totalInfoArray;
    info.totalStudentNum  = totalNumber;
    return info;
}

@end
