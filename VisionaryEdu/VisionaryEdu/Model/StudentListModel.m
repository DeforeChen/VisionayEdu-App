//
//  StudentListModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/10.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentListModel.h"

@implementation StudentListModel
+ (NSDictionary *)objectClassInArray{
    return @{@"results" : [StudentList_Results class]};
}
@end

@implementation StudentList_Results

@end
