//
//  TasksDetailsViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/17.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "TasksDetailsViewCtrl.h"
#import "config.h"
#import "UIColor+expanded.h"
#import "DatePickerViewController.h"
#import "TabBarManagerViewCtrl.h"
#import <WebKit/WebKit.h>
#import <MJExtension/MJExtension.h>

@interface TasksDetailsViewCtrl ()



@property (weak, nonatomic) IBOutlet UIButton *switchEditModeBtn;
@property (assign,nonatomic) BOOL whetherStaff;
@property (assign,nonatomic) BOOL whetherEditMode;
@end

@implementation TasksDetailsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whetherEditMode = NO;
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        self.whetherStaff = YES;
    } else
        self.whetherStaff = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UserInteractions
- (IBAction)switchEditMode:(UIButton *)sender {
    self.whetherEditMode = !self.whetherEditMode;
    [self.switchEditModeBtn setTitle:(self.whetherEditMode)?@"完成":@"编辑"
                            forState:UIControlStateNormal];
    
    TaskDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell switchOnEditMode:self.whetherEditMode];
}


#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 620;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskDetailCell *cell = [TaskDetailCell initMyCellWithTableview:tableView whetherStaffMode:self.whetherStaff task:self.taskModel commitModification:^(Tasks *modifiedTaskModel) {
        [SysTool showTipWithMsg:@"确认修改吗?" handler:^(UIAlertAction *action) {
            modifiedTaskModel.pk = self.taskModel.pk;
            NSMutableDictionary *reqDict = modifiedTaskModel.mj_keyValues;
            [reqDict setValue:[StudentInstance shareInstance].student_username forKey:@"username"];
            [SysTool showLoadingHUDWithMsg:@"信息上送中..." duration:0];
            [[SYHttpTool sharedInstance] patchEventWithURL:UPLOAD_TASK primaryKey:modifiedTaskModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"修改成功" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } viewCtrl:self];
                } else {
                    [SysTool showErrorWithMsg:msg duration:1];
                }
            }];
        } viewCtrl:self];
    }];
    [cell switchOnEditMode:NO];
    return cell;
}

#pragma mark UserInteraction
- (IBAction)jumpToDatePicker:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:self.taskModel.due_date];
    
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDate:date callback:^(NSString *selectDateStr) {
        TaskDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.dateLB.text = [selectDateStr substringToIndex:10];
    } pickerDateMode:UIDatePickerModeDate];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)checkTaskFile:(UIButton *)sender {
    if (self.taskModel.task_file.length > 0) {
        UIViewController *vc = [UIViewController new];
        WKWebView *web = [[WKWebView alloc] initWithFrame:vc.view.frame];
        NSString *url = [NSString stringWithFormat:@"%@%@",FILE_PREFIX,self.taskModel.task_file];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [vc.view addSubview:web];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SysTool showErrorWithMsg:@"任务文件未录入" duration:1];
    }
}

- (IBAction)deleteTask:(UIButton *)sender {
    [SysTool showTipWithMsg:@"确认要删除当前任务吗" handler:^(UIAlertAction *action) {
        [SysTool showLoadingHUDWithMsg:@"删除中..." duration:0];
        NSMutableDictionary *reqDict = [NSMutableDictionary new];//self.meetingModel.mj_keyValues;
        [reqDict setObject:[StudentInstance shareInstance].student_username forKey:@"student_username"];
        [[SYHttpTool sharedInstance] deleteEventWithURL:UPLOAD_TASK primaryKey:self.taskModel.pk token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
            [SysTool dismissHUD];
            if (success) {
                [SysTool showAlertWithMsg:@"删除成功!" handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                } viewCtrl:self];
            } else {
                [SysTool showErrorWithMsg:msg duration:1];
            }
        }];
    } viewCtrl:self];
}

@end

@interface TaskDetailCell()

@property (copy, nonatomic) NSString *taskFileURL;
@property (assign,nonatomic) BOOL whetherStaff;
@property (copy,nonatomic) CommitModifyReq commitTaskBlock;

@end

@implementation TaskDetailCell
+(instancetype)initMyCellWithTableview:(UITableView*)tableview whetherStaffMode:(BOOL)isStaffMode task:(Tasks*)taskModel commitModification:(CommitModifyReq)callback {
    TaskDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"taskCell"];
    cell.whetherStaff    = isStaffMode;
    cell.commitTaskBlock = callback;
    
    cell.dateLB.text  = taskModel.due_date;
    cell.topicTF.text = taskModel.title;
    cell.taskFileURL  = taskModel.task_file;
    cell.studentCommentTextView.text = taskModel.student_comment;
    cell.staffCommentTextView.text   = taskModel.staff_comment;
    cell.detailsTextView.text        = taskModel.details;
    
    cell.editTaskBtn.alpha = 0.0f;
    cell.deleteTaskBtn.alpha = 0.0f;
    cell.editTaskBtn.layer.borderColor = [UIColor colorWithHexString:@"#43434D"].CGColor;
    cell.editTaskBtn.layer.borderWidth = 1.0;
    cell.editTaskBtn.layer.cornerRadius = 10.0;
    cell.editTaskBtn.clipsToBounds = YES;

    if (![[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType])
        [cell.editTaskBtn setTitle:@"提交自评" forState:UIControlStateNormal];
    return cell;
}

-(void)switchOnEditMode:(BOOL)onEditMode {
    if (self.whetherStaff == YES) { //员工模式
        self.staffCmmtImg.hidden = (onEditMode == YES)?NO:YES;
        self.staffCommentTextView.editable = (onEditMode == YES)?YES:NO;
        self.detailsTextView.editable = (onEditMode == YES)?YES:NO;
        self.topicTF.userInteractionEnabled = (onEditMode == YES)?YES:NO;
        
        self.studentCommentTextView.editable = NO;
        self.studentCmmtImg.hidden = YES;
        self.editDateBtn.userInteractionEnabled = (onEditMode == YES)?YES:NO;
        self.editDateImg.hidden = (onEditMode == YES)?NO:YES;
        self.detailsImg.hidden  = (onEditMode == YES)?NO:YES;
        self.topicImg.hidden = (onEditMode == YES)?NO:YES;
    } else {
        self.staffCmmtImg.hidden = YES;
        self.staffCommentTextView.editable = NO;
        self.detailsTextView.editable = NO;
        self.topicTF.userInteractionEnabled = NO;

        self.studentCommentTextView.editable = (onEditMode == YES)?YES:NO;
        self.studentCmmtImg.hidden = (onEditMode == YES)?NO:YES;
        self.editDateBtn.userInteractionEnabled = NO;
        self.editDateImg.hidden = YES;
        self.detailsImg.hidden  = YES;
        self.topicImg.hidden    = YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.editTaskBtn.alpha = (onEditMode == YES)?1.0f:0.0f;
        if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType])
            self.deleteTaskBtn.alpha = (onEditMode == YES)?1.0f:0.0f;
    }];
}

- (IBAction)commitTaskModification:(UIButton *)sender {
    if ([self judgeLegalInput]) {
        Tasks *model = [Tasks new];
        model.details = self.detailsTextView.text;
        model.student_comment = self.studentCommentTextView.text;
        model.task_file = self.taskFileURL;
        model.staff_comment = self.staffCommentTextView.text;
        model.title = self.topicTF.text;
        model.due_date = self.dateLB.text;
        self.commitTaskBlock(model);
    }
}

-(BOOL)judgeLegalInput {
    self.detailsTextView.text        = [SysTool TrimSpaceString:self.detailsTextView.text];
    self.studentCommentTextView.text = [SysTool TrimSpaceString:self.studentCommentTextView.text];
    self.staffCommentTextView.text   = [SysTool TrimSpaceString:self.staffCommentTextView.text];
    self.topicTF.text                = [SysTool TrimSpaceString:self.topicTF.text];
    
    if (self.topicTF.text.length > 15) {
        [SysTool showErrorWithMsg:@"任务名长度不能超过15!" duration:1];
        return NO;
    }
    if (self.detailsTextView.text.length == 0) {
        [SysTool showErrorWithMsg:@"详情内容不能为空!" duration:1];
        return NO;
    }
    return YES;
}

@end
