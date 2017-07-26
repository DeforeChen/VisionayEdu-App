//
//  GradeModelForUpload.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/24.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "GradeModelForUpload.h"
/*
 专门用来上送成绩的model
 因为StudentScoreInDetailsModel.h内包含的成绩类，均带有协议，使用mj_keyvalues转化为dict的时候
 会生成诸如hash,description等多余的字段，为了避免麻烦，在此再去生成一个用于上送成绩时候的多态
 
*/
@implementation ActUpload
@end

@implementation ToeflUpload
@end

@implementation SatUpload
@end

@implementation Sat2Upload
@end

@implementation IeltsUpload
@end

@implementation ApUpload
@end
