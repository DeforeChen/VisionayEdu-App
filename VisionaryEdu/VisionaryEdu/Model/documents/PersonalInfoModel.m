//
//  PersonalInfoModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "PersonalInfoModel.h"

@implementation PersonalInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"results" : [PersonalResults class]};
}
@end

@implementation PersonalResults

@end
