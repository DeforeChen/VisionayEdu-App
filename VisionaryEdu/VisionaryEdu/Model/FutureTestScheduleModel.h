//
//  FutureTestScheduleModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FutureTestScheduleModel : NSObject
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , assign) NSInteger              test_type;
@property (nonatomic , assign) BOOL              whether_record_score;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * student_username;
@property (nonatomic , assign) NSInteger              pk;
@end
