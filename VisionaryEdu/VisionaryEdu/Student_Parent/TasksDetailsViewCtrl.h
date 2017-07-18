//
//  TasksDetailsViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/17.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScheduleModel.h"

@interface TasksDetailsViewCtrl : UITableViewController
@property (strong,nonatomic) Tasks *taskModel;
@end


typedef void(^CommitModifyReq)(Tasks *modifiedTaskModel);

@interface TaskDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *topicTF;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UITextView *studentCommentTextView;
@property (weak, nonatomic) IBOutlet UITextView *staffCommentTextView;
@property (weak, nonatomic) IBOutlet UIButton *editTaskBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteTaskBtn;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@property (weak, nonatomic) IBOutlet UIImageView *studentCmmtImg;
@property (weak, nonatomic) IBOutlet UIImageView *staffCmmtImg;
@property (weak, nonatomic) IBOutlet UIImageView *editDateImg;
@property (weak, nonatomic) IBOutlet UIImageView *detailsImg;
@property (weak, nonatomic) IBOutlet UIImageView *topicImg;

@property (weak, nonatomic) IBOutlet UIButton *editDateBtn;


/**
 初始化

 @param tableview tableview
 @param isStaffMode 员工模式可以修改师评，任务时间，删除任务
                    学生/家长模式只能修改 自评
 @param taskModel 任务信息
 @param callback 通知controller上送修改后的任务信息
 @return cell
 */
+(instancetype)initMyCellWithTableview:(UITableView*)tableview
                      whetherStaffMode:(BOOL)isStaffMode
                                  task:(Tasks*)taskModel
                    commitModification:(CommitModifyReq)callback;
-(void)switchOnEditMode:(BOOL)onEditMode ;
@end
