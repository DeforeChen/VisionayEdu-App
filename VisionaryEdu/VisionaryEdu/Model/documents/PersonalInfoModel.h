//
//  PersonalInfoModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Username.h"

@interface PersonalResults :NSObject
@property (nonatomic , copy) NSString              * used_name;
@property (nonatomic , copy) NSString              * expected_job;
@property (nonatomic , assign) BOOL              allow_edit;
@property (nonatomic , copy) NSString              * date_of_birth;
@property (nonatomic , copy) NSString              * cellphone_number;
@property (nonatomic , copy) NSString              * religious_preference;
@property (nonatomic , copy) NSString              * sexual_orientation;
@property (nonatomic , copy) NSString              * hobbies;
@property (nonatomic , copy) NSString              * nationality;
@property (nonatomic , copy) NSString              * id_number;
@property (nonatomic , copy) NSString              * mail_address;
@property (nonatomic , copy) NSString              * expected_degree;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , copy) NSString              * place_of_birth;
@property (nonatomic , copy) NSString              * interested_major;
@property (nonatomic , copy) NSString              * post_code;
@property (nonatomic , copy) NSString              * family_address;
@property (nonatomic , strong) Username              * username;

@end

@interface PersonalInfoModel :NSObject
@property (nonatomic , copy) NSString              * previous;
@property (nonatomic , strong) NSArray<PersonalResults *>              * results;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * next;

@end

