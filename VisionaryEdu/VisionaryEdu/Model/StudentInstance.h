//
//  StudentInstance.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentInstance : NSObject
@property (copy, nonatomic) NSString *student_username;
@property (copy, nonatomic) NSString *student_realname;

+(instancetype)shareInstance;
@end
