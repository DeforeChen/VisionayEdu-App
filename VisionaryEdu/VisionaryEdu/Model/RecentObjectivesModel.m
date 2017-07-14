//
//  RecentObjectivesModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "RecentObjectivesModel.h"

@implementation RecentObjectivesModel
+(NSDictionary *)objectClassInArray{ //这种方式用插件已经可以直接生成
    return @{@"results"         : [Obj_Results class]};
}

@end

@implementation Obj_Results

@end
