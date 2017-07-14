//
//  StudentListModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/10.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentList_Results :NSObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) BOOL              undergrad;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * registration_date;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , assign) BOOL              hs_guard;
@property (nonatomic , copy) NSString              * full_name;
@property (nonatomic , assign) NSInteger              user_class;

@end

@interface StudentListModel :NSObject
@property (nonatomic , copy) NSString              * previous;
@property (nonatomic , strong) NSArray<StudentList_Results *>              * results;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * next;

@end
