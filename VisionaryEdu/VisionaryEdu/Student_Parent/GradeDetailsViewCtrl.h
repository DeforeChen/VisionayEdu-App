//
//  GradeDetailsViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScheduleModel.h"

@interface GradeDetailsViewCtrl : UITableViewController
@property (strong,nonatomic) FutureTests *gradeModel;
@end

@interface gradeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *whetherRecordLB;
@property (weak, nonatomic) IBOutlet UILabel *testTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *placeLB;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *selfCommentLB;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg;
@property (weak, nonatomic) IBOutlet UITextView *staffCommentLB;

@end
