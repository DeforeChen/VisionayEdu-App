//
//  GradeResultInputViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/9.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "GradeResultInputViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "StudentScheduleModel.h"

@interface GradeResultInputViewCtrl ()
@property (weak, nonatomic) IBOutlet UILabel *testTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *testTypeLB;

@property (weak, nonatomic) IBOutlet UILabel *itemALB;
@property (weak, nonatomic) IBOutlet UILabel *itemB;
@property (weak, nonatomic) IBOutlet UILabel *itemC;
@property (weak, nonatomic) IBOutlet UILabel *itemD;
@property (weak, nonatomic) IBOutlet UILabel *itemE;


@property (weak, nonatomic) IBOutlet UITextField *itemInputA;
@property (weak, nonatomic) IBOutlet UITextField *itemInputB;
@property (weak, nonatomic) IBOutlet UITextField *itemInputC;
@property (weak, nonatomic) IBOutlet UITextField *itemInputD;
@property (weak, nonatomic) IBOutlet UITextField *itemInputF;

@property (weak, nonatomic) IBOutlet UIView *testA_View;
@property (weak, nonatomic) IBOutlet UIView *testB_View;
@property (weak, nonatomic) IBOutlet UIView *testC_View;
@property (weak, nonatomic) IBOutlet UIView *testD_View;
@property (weak, nonatomic) IBOutlet UIView *testE_View;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (copy, nonatomic) NSString *url;
@end

@implementation GradeResultInputViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 6.0;
    self.submitBtn.clipsToBounds = YES;
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    self.testTimeLB.text = [NSString stringWithFormat:@"%@ %@",self.testModel.date,self.testModel.time];
    
    testType type = self.testModel.test_type;
    switch (type) {
        case Toefl:
            self.testTypeLB.text = @"托福";
            self.url = TEST_TOEFL;
            self.itemALB.text = @"听力";
            self.itemB.text = @"口语";
            self.itemC.text = @"阅读";
            self.itemD.text = @"写作";
            self.itemE.text = @"总分";
            break;
        case ielts:
            self.testTypeLB.text = @"雅思";
            self.url = TEST_IELTS;
            self.itemALB.text = @"听力";
            self.itemB.text = @"口语";
            self.itemC.text = @"阅读";
            self.itemD.text = @"写作";
            self.itemE.text = @"总分";
            break;
        case SAT:
            self.testTypeLB.text = @"SAT";
            self.url = TEST_SAT;
            self.itemALB.text = @"批判性阅读写作";
            self.itemB.text = @"数学";
            self.itemC.text = @"作文总分";
            self.itemD.text = @"总分";
            self.testE_View.hidden = YES;
            break;
        case ACT:
            self.testTypeLB.text = @"ACT";
            self.url = TEST_ACT;
            self.itemALB.text = @"英文";
            self.itemB.text = @"科学";
            self.itemC.text = @"阅读";
            self.itemD.text = @"数学";
            self.itemE.text = @"总分";
            break;
        case SAT2:
            self.testTypeLB.text = @"SAT2";
            self.url = TEST_SAT2;
            self.itemALB.text = @"总分";
            self.itemB.text = @"科目";
            self.itemInputB.keyboardType = UIKeyboardTypeDefault;
            break;
        case AP:
            self.testTypeLB.text = @"AP";
            self.url = TEST_AP;
            self.itemALB.text = @"总分";
            self.itemB.text = @"科目";
            self.itemInputB.keyboardType = UIKeyboardTypeDefault;
            break;
        case IB:
            self.testTypeLB.text = @"Custom";
            self.url = TEST_CUSTOM;
            self.itemALB.text = @"总分";
            self.itemB.text = @"科目";
            self.itemInputB.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

- (IBAction)submitGradeResult:(UIButton *)sender {
}

@end
