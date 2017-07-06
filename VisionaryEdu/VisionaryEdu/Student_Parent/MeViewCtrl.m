//
//  MeViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/27.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "MeViewCtrl.h"
#import "config.h"
#import "StudentInstance.h"

@interface MeViewCtrl ()
@property (weak, nonatomic) IBOutlet UILabel *studentRealNameLB;
@property (weak, nonatomic) IBOutlet UIView *backToStudentListView;
@property (weak, nonatomic) IBOutlet UIView *SettingsView;

@end

@implementation MeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        self.SettingsView.hidden = YES;
    } else// 家长/学生端
        self.backToStudentListView.hidden = YES;

    self.studentRealNameLB.text = [StudentInstance shareInstance].student_realname;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UserInteraction
- (IBAction)backToStaffHomepage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
