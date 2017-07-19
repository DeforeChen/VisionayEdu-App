//
//  CreateTaskViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/18.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CreateTaskViewCtrl.h"
#import "config.h"
#import "DatePickerViewController.h"
#import "TabBarManagerViewCtrl.h"

#define DATE_HOLDER @"点击选择日期"
#define STAFFCMMT_HOLDER @"请输入师评"
#define DETAIL_HOLDER    @"请输入详情"

@interface CreateTaskViewCtrl ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *topicTF;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *staffCmmtTextView;
@property (weak, nonatomic) IBOutlet UIButton *addTaskBtn;

@end

@implementation CreateTaskViewCtrl

+(instancetype)initMyViewCtrl {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateTaskViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addTaskBtn.layer.cornerRadius = 6.0;
    self.addTaskBtn.clipsToBounds = YES;
    // Do any additional setup after loading the view.
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
- (IBAction)jumpToDatePicker:(UIButton *)sender {
    NSDate *date = [NSDate new];
    if (![self.dateLB.text isEqualToString:DATE_HOLDER]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        date = [formatter dateFromString:self.dateLB.text];
    }
    
    DatePickerViewController *vc = [DatePickerViewController initMyViewCtrlWithDate:date callback:^(NSString *selectDateStr) {
        self.dateLB.text = [selectDateStr substringToIndex:10];
    } pickerDateMode:UIDatePickerModeDate];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addTask:(UIButton *)sender {
    if ([self judgeLegalInput]) {
        [SysTool showTipWithMsg:@"确认添加任务吗?" handler:^(UIAlertAction *action) {
            [SysTool showLoadingHUDWithMsg:@"信息上送中" duration:0];

            NSDictionary *reqDict = @{@"student_username": [StudentInstance shareInstance].student_realname,
                                      @"due_date": self.dateLB.text,
                                      @"title": self.topicTF.text,
                                      @"staff_comment": [self.staffCmmtTextView.text isEqualToString:STAFFCMMT_HOLDER]?@"":self.staffCmmtTextView.text,
                                      @"details": self.detailTextView.text
                                      };
            
            [[SYHttpTool sharedInstance] addEventWithURL:UPLOAD_TASK token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    [SysTool showAlertWithMsg:@"添加任务成功!" handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } viewCtrl:self];
                } else {
                    [SysTool showErrorWithMsg:msg duration:1];
                }
            }];
        } viewCtrl:self];
    }
}

-(BOOL)judgeLegalInput {
    self.topicTF.text           = [SysTool TrimSpaceString:self.topicTF.text];
    self.detailTextView.text    = [SysTool TrimSpaceString:self.detailTextView.text];
    self.staffCmmtTextView.text = [SysTool TrimSpaceString:self.staffCmmtTextView.text];
    BOOL whetherTopicEmpty = (self.topicTF.text.length == 0)?YES:NO;
    BOOL whetherDateEmpty  = [self.dateLB.text isEqualToString:DATE_HOLDER]?YES:NO;
    BOOL whetherDetailEmpty = ([self.detailTextView.text isEqualToString:DETAIL_HOLDER] || self.detailTextView.text.length
                               == 0)?YES:NO;
    if (whetherTopicEmpty) {
        [SysTool showErrorWithMsg:@"任务名不能为空!" duration:2];
        return NO;
    } else if(self.topicTF.text.length > 15) {
        [SysTool showErrorWithMsg:@"任务名不能超过15个字！" duration:2];
        return NO;
    }
    
    if (whetherDateEmpty) {
        [SysTool showErrorWithMsg:@"日期不能为空!" duration:2];
        return NO;
    }
    
    if (whetherDetailEmpty) {
        [SysTool showErrorWithMsg:@"详情不能为空!" duration:2];
        return NO;
    }
    
    return YES;
}

#pragma mark TextView Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.staffCmmtTextView && [self.staffCmmtTextView.text isEqualToString:STAFFCMMT_HOLDER])
        self.staffCmmtTextView.text = @"";
    else if (textView == self.detailTextView && [self.detailTextView.text isEqualToString:DETAIL_HOLDER])
        self.detailTextView.text = @"";
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self.staffCmmtTextView) {
        self.staffCmmtTextView.text = [SysTool TrimSpaceString:self.staffCmmtTextView.text];
        if ([self.staffCmmtTextView.text isEqualToString:@""])
            self.staffCmmtTextView.text = STAFFCMMT_HOLDER;
    } else if (textView == self.detailTextView) {
        self.detailTextView.text = [SysTool TrimSpaceString:self.detailTextView.text];
        if ([self.detailTextView.text isEqualToString:@""])
            self.detailTextView.text = DETAIL_HOLDER;
    }
    return YES;
}
@end
