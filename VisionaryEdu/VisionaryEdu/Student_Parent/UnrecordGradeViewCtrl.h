//
//  UnrecordGradeViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FutureTestScheduleModel.h"

@interface UnrecordGradeViewCtrl : UIViewController
@property (copy,nonatomic) NSArray<FutureTestScheduleModel*> *unrecordModelArray;
@end

@interface UnrecordGradeCell : UITableViewCell
+(instancetype)initMyCellWithTableView:(UITableView*)tableview unrecordModel:(FutureTestScheduleModel*)model;
@end
