//
//  EduInfoModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Username.h"
@interface Edu_Results :NSObject
@property (nonatomic , copy) NSString              * last_attending_school;
@property (nonatomic , copy) NSString              * last_school_address;
@property (nonatomic , assign) BOOL              allow_edit;
@property (nonatomic , copy) NSString              * last_school_phone;
@property (nonatomic , copy) NSString              * setting_of_current_school;
@property (nonatomic , copy) NSString              * attended_class_grade;
@property (nonatomic , copy) NSString              * current_class_grade_population;
@property (nonatomic , copy) NSString              * current_grade;
@property (nonatomic , copy) NSString              * student_id;
@property (nonatomic , copy) NSString              * gpa_grade;
@property (nonatomic , copy) NSString              * teacher_email;
@property (nonatomic , copy) NSString              * teacher_name;
@property (nonatomic , copy) NSString              * date_of_last_attending;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * last_post_code;
@property (nonatomic , copy) NSString              * teacher_phone;
@property (nonatomic , copy) NSString              * date_of_current_graduate;
@property (nonatomic , copy) NSString              * current_school_address;
@property (nonatomic , copy) NSString              * date_of_last_graduate;
@property (nonatomic , copy) NSString              * setting_of_last_school;
@property (nonatomic , copy) NSString              * current_school;
@property (nonatomic , copy) NSString              * current_school_phone;
@property (nonatomic , copy) NSString              * date_of_current_attending;
@property (nonatomic , copy) NSString              * post_code;
@property (nonatomic , copy) NSString              * current_class_grade_rank;
@property (nonatomic , strong) Username              * username;

@end

@interface EduInfoModel :NSObject
@property (nonatomic , copy) NSString                 * previous;
@property (nonatomic , strong) NSArray<Edu_Results *> * results;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString                 * next;

@end

