//
//  StudentScoreInDetailsModel.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/3.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentScoreInDetailsModel.h"
#import <MJExtension/MJExtension.h>

#define ScoreItemsArray = @[@"total_score",@""];

@interface StudentScoreInDetailsModel()
@property (nonatomic,strong) NSMutableDictionary *correspondingScoreDict;
@end


@implementation StudentScoreInDetailsModel
-(NSMutableDictionary *)correspondingScoreDict {
    if (_correspondingScoreDict == nil) {
        _correspondingScoreDict = [NSMutableDictionary new];
    }
    return _correspondingScoreDict;
}

-(NSDictionary *)fetchCorrespondingScoreDict {
    return self.correspondingScoreDict;
}

#pragma mark MJ method

+(NSDictionary *)objectClassInArray{ //数组映射
    return @{@"act" : [Act class],
             @"ap" : [Ap class],
             @"sat2":[Sat2 class],
             @"sat":[Sat class],
             @"gpa":[Gpa class],
             @"custom":[Custom class],
             @"ielts":[Ielts class],
             @"toefl":[Toefl class]
             };
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    //处理数组为空时的情况，若数组不为空，那么将对应的对象内容写入到字典中。
    if (property.type.typeClass == [NSArray class]) {
        NSArray *array = (NSArray*)oldValue;
        if (array.count > 0) {
            NSString *className = [property.name capitalizedString];//注意转化的首字母要变成大写
            NSArray *array = [NSClassFromString(className) mj_objectArrayWithKeyValuesArray:oldValue];
            NSLog(@"转化后的类数组 = %@",array);
            [self.correspondingScoreDict setObject:array forKey:property.name];
        }
    }
    return oldValue;
}


@end

@implementation Act

@end
@implementation Ap

@end
@implementation Sat2

@end
@implementation Gpa

@end
@implementation Sat

@end
@implementation Custom

@end
@implementation Ielts
-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"total_score"]) { // 过滤掉空的属性值
        float totalScore = [oldValue floatValue];
        NSLog(@"ielts totalscore = %@",[NSNumber numberWithFloat:totalScore]);
        return [NSNumber numberWithFloat:totalScore];
    }
    return oldValue;
}
@end

@implementation Toefl
-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"total_score"]) { // 过滤掉空的属性值
        float totalScore = [oldValue floatValue];
        NSLog(@"Toefl totalscore = %@",[NSNumber numberWithFloat:totalScore]);
        return [NSNumber numberWithFloat:totalScore];
    }
    return oldValue;
}
@end
