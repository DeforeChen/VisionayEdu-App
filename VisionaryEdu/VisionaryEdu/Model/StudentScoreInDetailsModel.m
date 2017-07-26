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
//             @"gpa":[Gpa class],
//             @"custom":[Custom class],
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

#pragma mark 带五维图的类
@implementation Act
-(void)fetchSingleGradeInfoFromBlk:(RadarChartDataBlk)gradeBlk {
    NSMutableArray *gradeValue = [NSMutableArray new];
    [gradeValue addObject:[NSNumber numberWithInteger:self.reading_score]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.math_score]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.english_score]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.science_score]];
    
    NSMutableArray *gradeName  = [NSMutableArray new];
    [gradeName addObject:[NSString stringWithFormat:@"阅读 %@分",gradeValue[0]]];
    [gradeName addObject:[NSString stringWithFormat:@"数学 %@分",gradeValue[1]]];
    [gradeName addObject:[NSString stringWithFormat:@"英语 %@分",gradeValue[2]]];
    [gradeName addObject:[NSString stringWithFormat:@"科学 %@分",gradeValue[3]]];
    NSArray *gradePossbleValue  = @[@36,@36,@36,@36];
    //(^RadarChartDataBlk)(NSArray *gettingGrade, NSArray *possibleGrade, NSArray *gradeName);
    gradeBlk(gradeValue,gradePossbleValue,gradeName,6);
}

-(NSDictionary *)fetchSingleGradeInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:self.total_score] forKey:TotalScore];
    return dict;
}
@end

@implementation Sat
-(void)fetchSingleGradeInfoFromBlk:(RadarChartDataBlk)gradeBlk {
    NSMutableArray *gradeValue = [NSMutableArray new];
    [gradeValue addObject:[NSNumber numberWithInteger:self.essay_score]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.reading_writing_score]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.math_score]];
    
    NSMutableArray *gradeName  = [NSMutableArray new];
    [gradeName addObject:[NSString stringWithFormat:@"作文 %@分",gradeValue[0]]];
    [gradeName addObject:[NSString stringWithFormat:@"读/写 %@分",gradeValue[1]]];
    [gradeName addObject:[NSString stringWithFormat:@"数学 %@分",gradeValue[2]]];
    NSArray *gradePossbleValue  = @[@800,@800,@800];
    //(^RadarChartDataBlk)(NSArray *gettingGrade, NSArray *possibleGrade, NSArray *gradeName);
    gradeBlk(gradeValue,gradePossbleValue,gradeName,4);
}

-(NSDictionary *)fetchSingleGradeInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:self.total_score] forKey:TotalScore];
    return dict;
}
@end

@implementation Ielts
-(void)fetchSingleGradeInfoFromBlk:(RadarChartDataBlk)gradeBlk {
    NSMutableArray *gradeValue = [NSMutableArray new];
    [gradeValue addObject:[NSNumber numberWithInteger:[self.reading_score floatValue]]];
    [gradeValue addObject:[NSNumber numberWithInteger:[self.writing_score floatValue]]];
    [gradeValue addObject:[NSNumber numberWithInteger:[self.speaking_score floatValue]]];
    [gradeValue addObject:[NSNumber numberWithInteger:[self.listening_score floatValue]]];
    
    NSMutableArray *gradeName  = [NSMutableArray new];
    [gradeName addObject:[NSString stringWithFormat:@"阅读 %@分",gradeValue[0]]];
    [gradeName addObject:[NSString stringWithFormat:@"写作 %@分",gradeValue[1]]];
    [gradeName addObject:[NSString stringWithFormat:@"口语 %@分",gradeValue[2]]];
    [gradeName addObject:[NSString stringWithFormat:@"听力 %@分",gradeValue[3]]];

    NSArray *gradePossbleValue  = @[@9,@9,@9,@9];
    //(^RadarChartDataBlk)(NSArray *gettingGrade, NSArray *possibleGrade, NSArray *gradeName);
    gradeBlk(gradeValue,gradePossbleValue,gradeName,3);
}

-(NSDictionary *)fetchSingleGradeInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:[self.total_score floatValue]] forKey:TotalScore];
    return dict;
}

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
-(void)fetchSingleGradeInfoFromBlk:(RadarChartDataBlk)gradeBlk {
    NSMutableArray *gradeValue = [NSMutableArray new];
    [gradeValue addObject:[NSNumber numberWithInteger:self.reading_score ]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.writing_score]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.speaking_score ]];
    [gradeValue addObject:[NSNumber numberWithInteger:self.listening_score ]];
    
    NSMutableArray *gradeName  = [NSMutableArray new];
    [gradeName addObject:[NSString stringWithFormat:@"阅读 %@分",gradeValue[0]]];
    [gradeName addObject:[NSString stringWithFormat:@"写作 %@分",gradeValue[1]]];
    [gradeName addObject:[NSString stringWithFormat:@"口语 %@分",gradeValue[2]]];
    [gradeName addObject:[NSString stringWithFormat:@"听力 %@分",gradeValue[3]]];
    NSArray *gradePossbleValue  = @[@30,@30,@30,@30];
    //(^RadarChartDataBlk)(NSArray *gettingGrade, NSArray *possibleGrade, NSArray *gradeName);
    gradeBlk(gradeValue,gradePossbleValue,gradeName,5);
}

-(NSDictionary *)fetchSingleGradeInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:self.total_score] forKey:TotalScore];
    return dict;
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"total_score"]) { // 过滤掉空的属性值
        float totalScore = [oldValue floatValue];
        NSLog(@"Toefl totalscore = %@",[NSNumber numberWithFloat:totalScore]);
        return [NSNumber numberWithFloat:totalScore];
    }
    return oldValue;
}

@end
#pragma mark 不带五维图的类
@implementation Ap
-(NSDictionary *)fetchSingleGradeInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:self.total_score] forKey:TotalScore];
    [dict setObject:self.subject forKey:Subject];
    [dict setObject:@"" forKey:PossibleScore];
    return dict;
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (oldValue == nil) {
        return @"";
    } else
        return oldValue;
}
@end

@implementation Sat2
-(NSDictionary *)fetchSingleGradeInfoDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:self.total_score] forKey:TotalScore];
    [dict setObject:self.subject forKey:Subject];
    [dict setObject:@"" forKey:PossibleScore];
    return dict;
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (oldValue == nil) {
        return @"";
    } else
        return oldValue;
}
@end

@implementation Test_schedule_info

@end

//@implementation Gpa
//-(NSDictionary *)fetchSingleGradeInfoDict {
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:[NSNumber numberWithInteger:self.gpa_getting] forKey:TotalScore];
//    [dict setObject:self.subject forKey:Subject];
//    [dict setObject:[NSNumber numberWithInteger:self.possible_gpa] forKey:PossibleScore];
//    return dict;
//}
//
//-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
//    if (oldValue == nil) {
//        return @"";
//    } else
//        return oldValue;
//}
//@end

//@implementation Custom
//-(NSDictionary *)fetchSingleGradeInfoDict {
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:[NSNumber numberWithInteger:self.score_getting] forKey:TotalScore];
//    [dict setObject:self.subject forKey:Subject];
//    [dict setObject:[NSNumber numberWithInteger:self.possible_points] forKey:PossibleScore];
//    return dict;
//}

//-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
//    if (oldValue == nil) {
//        return @"";
//    } else
//        return oldValue;
//}
//@end
