//
//  StudentCheckInRecordDetailsViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/18.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScheduleModel.h"
@interface StudentCheckInRecordDetailsViewCtrl : UITableViewController
@property (strong,nonatomic) StudentCheckInRecords *recordModel;
@end

@interface StudentCheckInRecordDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *individualComment;
@property (weak, nonatomic) IBOutlet UILabel *overTimeLB;

+(instancetype)initMyCellWithTableView:(UITableView*)tableview CheckInRecord:(StudentCheckInRecords*)recordModel;

-(void)switchOnEditMode:(BOOL)onEditMode;
-(void)trimIndividualCmmtSpace;
@end
