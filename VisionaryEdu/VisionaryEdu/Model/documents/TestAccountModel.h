//
//  TestAccountModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Username.h"

@interface Results :NSObject
@property (nonatomic , copy) NSString              * toefl_id;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * ap_password;
@property (nonatomic , copy) NSString              * toefl_password;
@property (nonatomic , copy) NSString              * act_id;
@property (nonatomic , copy) NSString              * a_level_password;
@property (nonatomic , copy) NSString              * ib_password;
@property (nonatomic , copy) NSString              * ielts_id;
@property (nonatomic , assign) BOOL              allow_edit;
@property (nonatomic , copy) NSString              * ielts_password;
@property (nonatomic , strong) Username              * username;
@property (nonatomic , copy) NSString              * sat_id;
@property (nonatomic , copy) NSString              * sat_password;
@property (nonatomic , copy) NSString              * act_password;
@property (nonatomic , copy) NSString              * ap_id;
@property (nonatomic , copy) NSString              * a_level_id;
@property (nonatomic , copy) NSString              * ib_id;

@end

@interface TestAccountModel :NSObject
@property (nonatomic , copy) NSString              * previous;
@property (nonatomic , strong) NSArray<Results *>  * results;
@property (nonatomic , assign) NSInteger             count;
@property (nonatomic , copy) NSString              * next;

@end
