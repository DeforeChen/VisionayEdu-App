//
//  RecentObjectivesModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Username.h"

@interface Obj_Results :NSObject
@property (nonatomic , copy) NSString              * begin_date;
@property (nonatomic , strong) Student_username    * student_username;
@property (nonatomic , copy) NSString              * end_date;
@property (nonatomic , copy) NSString              * objective;
@property (nonatomic , assign) NSInteger              pk;
@property (nonatomic , copy) NSString              * staff_comment;

@end

@interface RecentObjectivesModel :NSObject
@property (nonatomic , copy) NSString                  * previous;
@property (nonatomic , strong) NSArray<Obj_Results *>  * results;
@property (nonatomic , assign) NSInteger                 count;
@property (nonatomic , copy) NSString                  * next;

@end
