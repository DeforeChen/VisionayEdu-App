//
//  StudentInfoViewCtrl.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/3.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentInfoViewCtrl.h"

@interface StudentInfoViewCtrl ()
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *personalInfoView;

@end

@implementation StudentInfoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scoreView.layer.cornerRadius        = 10.0;
    self.personalInfoView.layer.cornerRadius = 10.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Button Action
- (IBAction)scoreIndetails:(id)sender {
}

- (IBAction)personalInfoIndetails:(id)sender {
}

- (IBAction)dismissAndReturnToStudentList:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
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
