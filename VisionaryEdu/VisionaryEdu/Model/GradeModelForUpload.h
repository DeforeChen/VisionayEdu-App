//
//  GradeModelForUpload.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/24.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActUpload :NSObject
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , assign) NSInteger              math_score;
@property (nonatomic , copy) NSString              * test_schedule_id;
@property (nonatomic , assign) NSInteger              reading_score;
@property (nonatomic , assign) NSInteger              english_score;
@property (nonatomic , assign) NSInteger              science_score;
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , assign) NSInteger              total_score;

@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * details;
@end

@interface ApUpload :NSObject
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , copy) NSString              * test_schedule_id;
@property (nonatomic , assign) NSInteger              total_score;
@property (nonatomic , copy) NSString              * subject;
@property (nonatomic , assign) NSInteger              color;

@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * details;
@end

@interface Sat2Upload :NSObject
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , copy) NSString              * test_schedule_id;
@property (nonatomic , assign) NSInteger              total_score;
@property (nonatomic , copy) NSString              * subject;
@property (nonatomic , assign) NSInteger              color;

@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * details;
@end

@interface SatUpload :NSObject
@property (nonatomic , copy) NSString              * writing_essay;
@property (nonatomic , assign) NSInteger              math_score;
@property (nonatomic , copy) NSString              * analysis_essay;
@property (nonatomic , assign) NSInteger              test_schedule_id;
@property (nonatomic , assign) NSInteger              reading_writing_score;
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , assign) NSInteger              essay_score;
@property (nonatomic , copy) NSString              * reading_essay;
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , assign) NSInteger              total_score;

@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * details;
@end

@interface IeltsUpload :NSObject
@property (nonatomic , copy) NSString              * total_score;
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , copy) NSString              * test_schedule_id;
@property (nonatomic , copy) NSString              * speaking_score;
@property (nonatomic , copy) NSString              * reading_score;
@property (nonatomic , copy) NSString              * listening_score;
@property (nonatomic , copy) NSString              * writing_score;
@property (nonatomic , copy) NSString              * score_report;

@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * details;
@end


@interface ToeflUpload :NSObject
@property (nonatomic , copy) NSString              * score_report;
@property (nonatomic , assign) NSInteger              color;
@property (nonatomic , copy) NSString              * test_schedule_id;
@property (nonatomic , assign) NSInteger              speaking_score;
@property (nonatomic , assign) NSInteger              reading_score;
@property (nonatomic , assign) NSInteger              listening_score;
@property (nonatomic , assign) NSInteger              writing_score;
@property (nonatomic , assign) NSInteger              total_score;

@property (nonatomic , copy) NSString              * time;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * place;
@property (nonatomic , copy) NSString              * staff_comment;
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , copy) NSString              * details;
@end
