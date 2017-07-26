//
//  RecordGradeViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/21.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScheduleModel.h"
@class FutureTests;

typedef void(^FillInRecordBlk)(BOOL whetherFilled, NSDictionary *gradeDetailsDict);

@interface RecordGradeViewCtrl : UIViewController
@property (nonatomic,strong) FutureTests *testModel;
+(instancetype)initMyViewCtrlWithTestType:(TestType)type gradeDict:(NSDictionary*)grade callback:(FillInRecordBlk)block whetherEditMode:(BOOL)whether;
@end
