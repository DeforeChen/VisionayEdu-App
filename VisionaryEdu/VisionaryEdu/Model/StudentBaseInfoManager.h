//
//  StudentBaseInfoManager.h
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/5/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentInfoModel :NSObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) BOOL              undergrad;
@property (nonatomic , copy) NSString              * registration_date;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , assign) BOOL              hs_guard;
@property (nonatomic , copy) NSString              * full_name;
@property (nonatomic , assign) NSInteger              user_class;
@property (nonatomic , copy) NSString              *appointment_statistics;
@property (nonatomic , copy) NSString              *gender;
@end

@interface StudentBaseInfo : NSObject
//他的元素拥有两个相同的索引
@property (assign,nonatomic) NSUInteger totalStudentNum;
@property (copy, nonatomic)  NSArray *gradeIndexArray; //json keys组成的数组，存放 grade
@property (strong,nonatomic) NSArray<NSArray<StudentInfoModel*>*> *studentInfoArray;//具体的信息数组组成的一个二维数组
@end

@interface StudentBaseInfoManager : NSObject

/**
 根据传来的JSON，将整理后的model返回为两个索引相同的数组：
 例如:
{
 @"2017" :@[{@"A":@"1"},
            {@"B":@"2"},
            {@"C":@"3"}],
 @"2018" :@[{@"aa":@"1"},
            {@"bb":@"2"},
            {@"cc":@"3"}],
}
转化为两个索引对应的数组，其中二是一个二维数组
 [@"2017",@"2018"];
 [@[...], @[...]];

 @param responseObject 网络请求时返回的JSON字符串
 @return 两个数组组成的类信息
 */
+(StudentBaseInfo*)fetchStudentInfoOfGradeFromResponseJSON:(id)responseObject;

@end


