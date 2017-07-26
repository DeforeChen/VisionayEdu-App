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

@property (nonatomic,strong) NSMutableDictionary *gradeDict; //用来录入单科成绩明细的信息


+(instancetype)initMyViewCtrlWithWhetherUnderGradeCheckMode:(BOOL)whether;
@end

@interface gradeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *testTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UITextField *placeTF;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *selfCommentLB;
//@property (weak, nonatomic) IBOutlet UIImageView *flagImg;
@property (weak, nonatomic) IBOutlet UITextView *staffCommentLB;

@property (weak, nonatomic) IBOutlet UIButton *editTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkOrRecordGradeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *editTimeImg;
@property (weak, nonatomic) IBOutlet UIImageView *editPlaceImg;
@property (weak, nonatomic) IBOutlet UIImageView *editDetailsImg;
@property (weak, nonatomic) IBOutlet UIImageView *editSelfCmmtImg;
@property (weak, nonatomic) IBOutlet UIImageView *editStaffCmmtImg;

@property (weak, nonatomic) IBOutlet UIButton *commitEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

-(void)switchEditMode:(BOOL)whetherOn;
@end
