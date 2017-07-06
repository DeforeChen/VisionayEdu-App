//
//  Username.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Username :NSObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) BOOL              undergrad;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * registration_date;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , assign) BOOL              hs_guard;
@property (nonatomic , copy) NSString              * full_name;
@property (nonatomic , assign) NSInteger              user_class;

@end
