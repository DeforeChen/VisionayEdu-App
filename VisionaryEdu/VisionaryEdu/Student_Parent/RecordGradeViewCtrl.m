//
//  RecordGradeViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/21.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "RecordGradeViewCtrl.h"
#import "config.h"
#import "StudentScheduleModel.h"

@interface RecordGradeViewCtrl ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemA;
@property (weak, nonatomic) IBOutlet UILabel *itemB;
@property (weak, nonatomic) IBOutlet UILabel *itemC;
@property (weak, nonatomic) IBOutlet UILabel *itemD;

@property (weak, nonatomic) IBOutlet UITextField *itemInputA;
@property (weak, nonatomic) IBOutlet UITextField *itemInputB;
@property (weak, nonatomic) IBOutlet UITextField *itemInputC;
@property (weak, nonatomic) IBOutlet UITextField *itemInputD;
@property (weak, nonatomic) IBOutlet UITextField *totalScoreTF;

@property (weak, nonatomic) IBOutlet UIView *testA_View;
@property (weak, nonatomic) IBOutlet UIView *testB_View;
@property (weak, nonatomic) IBOutlet UIView *testC_View;
@property (weak, nonatomic) IBOutlet UIView *testD_View;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (assign, nonatomic) TestType testType;
@property (copy, nonatomic) FillInRecordBlk block;
@property (strong,nonatomic) NSMutableDictionary *gradeDict;
@property (assign,nonatomic) BOOL whetherEditMode;
@end

@implementation RecordGradeViewCtrl

+(instancetype)initMyViewCtrlWithTestType:(TestType)type gradeDict:(NSDictionary*)grade callback:(FillInRecordBlk)block whetherEditMode:(BOOL)whether {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordGradeViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.testType  = type;
    vc.block     = block;
    vc.gradeDict = [grade mutableCopy];
    vc.whetherEditMode = whether;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 6.0;
    self.submitBtn.clipsToBounds = YES;
    [self switchEditMode:self.whetherEditMode];
    [self configUI];
}

-(void)switchEditMode:(BOOL)whetherEditMode {
    self.itemInputA.userInteractionEnabled = whetherEditMode?YES:NO;
    self.itemInputB.userInteractionEnabled = whetherEditMode?YES:NO;
    self.itemInputC.userInteractionEnabled = whetherEditMode?YES:NO;
    self.itemInputD.userInteractionEnabled = whetherEditMode?YES:NO;
    self.totalScoreTF.userInteractionEnabled = whetherEditMode?YES:NO;
    self.submitBtn.hidden                  = whetherEditMode?NO:YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    TestType type = self.testType;
    switch (type) {
        case ToeflType:
            self.title = @"托福";
            self.itemA.text = @"听力";
            self.itemB.text = @"口语";
            self.itemC.text = @"阅读";
            self.itemD.text = @"写作";
            
            self.itemInputA.text = self.gradeDict[@"A"];
            self.itemInputB.text = self.gradeDict[@"B"];
            self.itemInputC.text = self.gradeDict[@"C"];
            self.itemInputD.text = self.gradeDict[@"D"];
            self.totalScoreTF.text = self.gradeDict[@"total"];
            break;
        case ieltsType:
            self.title = @"雅思";
            self.itemA.text = @"听力";
            self.itemB.text = @"口语";
            self.itemC.text = @"阅读";
            self.itemD.text = @"写作";
            
            self.itemInputA.text = self.gradeDict[@"A"];
            self.itemInputB.text = self.gradeDict[@"B"];
            self.itemInputC.text = self.gradeDict[@"C"];
            self.itemInputD.text = self.gradeDict[@"D"];
            /* 不知为何，托福的这个，那边传过来的NSNumber类型会自动变成short,因此这里做一个转化
             为了避免显示null,这里加一个判断
            */
            if ([self.gradeDict objectForKey:@"total"] != nil)
                self.totalScoreTF.text = [NSString stringWithFormat:@"%@",self.gradeDict[@"total"]];   
            break;
        case SatType:
            self.title = @"SAT";
            self.itemA.text = @"批判性阅读写作";
            self.itemB.text = @"数学";
            self.itemC.text = @"作文总分";
            self.testD_View.hidden = YES;
            
            self.itemInputA.text = self.gradeDict[@"A"];
            self.itemInputB.text = self.gradeDict[@"B"];
            self.itemInputC.text = self.gradeDict[@"C"];
            self.totalScoreTF.text = self.gradeDict[@"total"];
            break;
        case ActType:
            self.title = @"ACT";
            self.itemA.text = @"英文";
            self.itemB.text = @"科学";
            self.itemC.text = @"阅读";
            self.itemD.text = @"数学";
            
            self.itemInputA.text = self.gradeDict[@"A"];
            self.itemInputB.text = self.gradeDict[@"B"];
            self.itemInputC.text = self.gradeDict[@"C"];
            self.itemInputD.text = self.gradeDict[@"D"];
            self.totalScoreTF.text = self.gradeDict[@"total"];
            break;
        case Sat2Type:
            self.title = @"SAT2";
            self.itemA.text = @"科目";
            self.itemInputA.keyboardType = UIKeyboardTypeDefault;
            self.testB_View.hidden = YES;
            self.testC_View.hidden = YES;
            self.testD_View.hidden = YES;
            
            self.itemInputA.text = self.gradeDict[@"A"];
            self.totalScoreTF.text = self.gradeDict[@"total"];
            break;
        case APType:
            self.title = @"AP";
            self.itemA.text = @"科目";
            self.itemInputA.keyboardType = UIKeyboardTypeDefault;
            self.testB_View.hidden = YES;
            self.testC_View.hidden = YES;
            self.testD_View.hidden = YES;
            
            self.itemInputA.text = self.gradeDict[@"A"];
            self.totalScoreTF.text = self.gradeDict[@"total"];
            break;
//        case IB:
//            self.title = @"Custom";
//            self.itemA.text = @"科目";
//            self.itemInputA.keyboardType = UIKeyboardTypeDefault;
//            self.testB_View.hidden = YES;
//            self.testC_View.hidden = YES;
//            self.testD_View.hidden = YES;
//            
//            self.itemInputA.text = self.gradeDict[@"A"];
//            self.totalScoreTF.text = self.gradeDict[@"total"];
//            break;
    }
}

#pragma mark Getter
-(NSMutableDictionary *)gradeDict {
    if (_gradeDict == nil)
        _gradeDict = [NSMutableDictionary new];
    return _gradeDict;
}

- (IBAction)submitGradeResult:(UIButton *)sender {
    BOOL whetherA = [self checkItemWhetherFilled:self.itemInputA testView:self.testA_View keyToSave:@"A"];
    BOOL whetherB = [self checkItemWhetherFilled:self.itemInputB testView:self.testB_View keyToSave:@"B"];
    BOOL whetherC = [self checkItemWhetherFilled:self.itemInputC testView:self.testC_View keyToSave:@"C"];
    BOOL whetherD = [self checkItemWhetherFilled:self.itemInputD testView:self.testD_View keyToSave:@"D"];
    BOOL whetherTotalFilled = self.totalScoreTF.text.length == 0 ?NO:YES;
    if (whetherTotalFilled)
        [self.gradeDict setObject:self.totalScoreTF.text forKey:@"total"];
    
    if (whetherA && whetherB && whetherC && whetherD && whetherTotalFilled) {
        XLog(@"提交返回的成绩列表 = %@",self.gradeDict);
        self.block(YES, self.gradeDict);
        [self.navigationController popViewControllerAnimated:YES];
    } else
        [SysTool showErrorWithMsg:@"成绩栏目未填写全！" duration:1];
}

-(BOOL)checkItemWhetherFilled:(UITextField*)tf testView:(UIView*)testView keyToSave:(NSString*)key{
    if (tf.text.length != 0 && testView.hidden != YES) { //不隐藏且输入字段长度不为0
        [self.gradeDict setObject:tf.text forKey:key];
        return YES;
    } else if (testView.hidden == YES) {
        return YES;//若该栏目本身已经隐藏，也视为已填写
    } else
        return NO;
}

#pragma mark Textfield Delegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""])//输入为空
        return YES;
    if (![SysTool judgeRegExWithType:Judge_Score String:textField.text] && textField.keyboardType != UIKeyboardTypeDefault) {
        [SysTool showErrorWithMsg:@"请输入正确的分值,小数点后只能为0或5!" duration:1];
        return NO;
    }
    return YES;
}
@end
