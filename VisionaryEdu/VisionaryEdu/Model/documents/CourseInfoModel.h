//
//  CourseInfoModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ElectiveCoure;
typedef void(^CourseInfo)(NSArray<ElectiveCoure*> *electiveCourse, NSArray<NSString*> *HS_Course);

@interface ElectiveCoure : NSObject
@property (copy,nonatomic) NSString *elective_course;
@property (copy,nonatomic) NSString *elective_course_description;
@end

@interface CourseInfoModel : NSObject

/**
 初始化模型。从返回的数据中，遍历出 electiveCourse(选修课)，组成一个数组；遍历出高中课程，组成一个数组

 @param response 服务端返回的JSON字符串
 @param block 获取到两个数组时候的回调
 */
+(void)initModelWithResponse:(id)response callback:(CourseInfo)block;
@end
