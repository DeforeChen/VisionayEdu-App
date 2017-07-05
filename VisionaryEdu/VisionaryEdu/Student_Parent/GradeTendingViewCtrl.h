//
//  GradeTendingViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/4.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScoreInDetailsModel.h"

@interface GradeTendingViewCtrl : UIViewController
+(instancetype)initMyViewWithGradeNameArray:(NSArray*)gradeNameArray GradeInfoArray:(NSArray<NSArray<id<scoreModelProtocol>>*>*)gradeInfoArray ;
@end

@interface GradeTotalScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellIndexLB;
@property (weak, nonatomic) IBOutlet UILabel *testTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *totalScore;
@property (weak, nonatomic) IBOutlet UILabel *testPlaceLB;

@end
