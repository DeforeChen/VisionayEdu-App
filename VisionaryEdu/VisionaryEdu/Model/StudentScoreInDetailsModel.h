//
//  StudentScoreInDetailsModel.h
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/3.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TotalScore    @"TotalScore"
#define PossibleScore @"PossibleScore"
#define Subject       @"Subject"


@class Test_schedule_info;
typedef void(^RadarChartDataBlk)(NSArray *gettingGrade, NSArray *possibleGrade, NSArray *gradeName,NSInteger step);
@protocol scoreModelProtocol <NSObject>
@required
@property (strong,nonatomic) Test_schedule_info *test_schedule_info;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , assign) NSInteger color;
/**
 AP,GPA,CUSTOM,SAT2这四种不包含单项成绩, 余下的也在这里将总分传入
 @return 字典
 */
-(NSDictionary*)fetchSingleGradeInfoDict;
@optional
/**
 给单次成绩五维图用的look up table
 其中，仅SAT,TOEF,IELTS,ACT四种有包含多维的统计图
 */
-(void)fetchSingleGradeInfoFromBlk:(RadarChartDataBlk)gradeBlk;
@end


@interface Test_schedule_info :NSObject
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * details;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , assign) NSInteger              test_type;
@property (nonatomic , assign) BOOL              whether_record_score;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , assign) NSInteger              student_username;

@end

@interface Act :NSObject<scoreModelProtocol>
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , assign) NSInteger              math_score;
@property (nonatomic , assign) NSInteger              reading_score;
@property (nonatomic , assign) NSInteger              english_score;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , assign) NSInteger              science_score;
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , assign) NSInteger              total_score;

@property (nonatomic , strong) Test_schedule_info              * test_schedule_info;
@end

@interface Ap :NSObject<scoreModelProtocol>
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , copy) NSString              * subject;
@property (nonatomic , assign) NSInteger              total_score;
@property (nonatomic , assign) NSInteger              color;

@property (nonatomic , strong) Test_schedule_info              * test_schedule_info;
@end

@interface Sat2 :NSObject<scoreModelProtocol>
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , copy) NSString              * subject;
@property (nonatomic , assign) NSInteger              total_score;
@property (nonatomic , assign) NSInteger              color;

@property (nonatomic , strong) Test_schedule_info              * test_schedule_info;
@end

//@interface Gpa :NSObject<scoreModelProtocol>
//@property (nonatomic , copy) NSString              * subject;
//@property (nonatomic , assign) NSInteger              category;
//@property (nonatomic , copy) NSString              * score_report;
//@property (nonatomic , assign) NSInteger              semester;
//@property (nonatomic , copy) NSString              * staff_comment;
//@property (nonatomic , copy) NSString              * student_comment;
//@property (nonatomic , copy) NSString              * time;
//@property (nonatomic , assign) NSInteger              gpa_getting;
//@property (nonatomic , assign) NSInteger              class_year;
//@property (nonatomic , assign) NSInteger              color;
//@property (nonatomic , assign) NSInteger              possible_gpa;
//@property (nonatomic , copy) NSString              * date;
//@property (nonatomic , copy) NSString              * title;
//@property (nonatomic , copy) NSString              * details;
//@property (nonatomic , copy) NSString              * place;
//@end

@interface Sat :NSObject<scoreModelProtocol>
@property (nonatomic , copy) NSString              * writing_essay;
@property (nonatomic , assign) NSInteger              math_score;
@property (nonatomic , copy) NSString              * analysis_essay;
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , assign) NSInteger              reading_writing_score;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , assign) NSInteger              essay_score;
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , copy) NSString              * reading_essay;
@property (nonatomic , assign) NSInteger              total_score;

@property (nonatomic , strong) Test_schedule_info              * test_schedule_info;
@end


//@interface Custom :NSObject<scoreModelProtocol>
//@property (nonatomic , copy) NSString              * subject;
//@property (nonatomic , assign) NSInteger              category;
//@property (nonatomic , copy) NSString              * score_report;
//@property (nonatomic , assign) NSInteger              semester;
//@property (nonatomic , copy) NSString              * staff_comment;
//@property (nonatomic , copy) NSString              * student_comment;
//@property (nonatomic , copy) NSString              * time;
//@property (nonatomic , assign) NSInteger              score_getting;
//@property (nonatomic , assign) NSInteger              class_year;
//@property (nonatomic , assign) NSInteger              color;
//@property (nonatomic , assign) NSInteger              possible_points;
//@property (nonatomic , copy) NSString              * date;
//@property (nonatomic , copy) NSString              * title;
//@property (nonatomic , copy) NSString              * details;
//@property (nonatomic , copy) NSString              * place;
//
//@end

@interface Ielts :NSObject<scoreModelProtocol>
@property (nonatomic , copy) NSString              * total_score;
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , copy) NSString              * speaking_score;
@property (nonatomic , copy) NSString              * reading_score;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , copy) NSString              * listening_score;
@property (nonatomic , copy) NSString              * writing_score;
@property (nonatomic , copy) NSString              * score_report;

@property (nonatomic , strong) Test_schedule_info              * test_schedule_info;
@end


@interface Toefl :NSObject<scoreModelProtocol>
@property (nonatomic , assign) NSInteger              total_score;
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , assign) NSInteger              speaking_score;
@property (nonatomic , assign) NSInteger              reading_score;
@property (nonatomic , assign) NSInteger              test_schedule;
@property (nonatomic , assign) NSInteger              writing_score;
@property (nonatomic , assign) NSInteger              listening_score;
@property (nonatomic , copy) NSString              * score_report;

@property (nonatomic , strong) Test_schedule_info              * test_schedule_info;
@end


@interface StudentScoreInDetailsModel :NSObject
@property (nonatomic , copy) NSArray<Act *>      *act;
@property (nonatomic , copy) NSArray<Ap *>       *ap;
@property (nonatomic , copy) NSArray<Sat2 *>     *sat2;
//@property (nonatomic , copy) NSArray<Gpa *>      *gpa;
//@property (nonatomic , copy) NSArray<Custom *>   *custom;
@property (nonatomic , copy) NSArray<Sat *>      *sat;
@property (nonatomic , copy) NSArray<Ielts *>    *ielts;
@property (nonatomic , copy) NSArray<Toefl *>    *toefl;


/**
 写这个的目的是为了当传入对应的成绩为空数组("[]")时，在成绩页面的滑动栏，不需要显示这一行
 相当于 StudentScoreInDetailsModel 和返回的这个字典是等价的，只是字典中不包含那些空的内容
 @return 返回形如 @"act" = Act *object对象的字典
 */
-(NSDictionary*)fetchCorrespondingScoreDict;
@end
