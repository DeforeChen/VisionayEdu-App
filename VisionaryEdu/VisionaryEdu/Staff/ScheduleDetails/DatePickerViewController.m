//
//  DatePickerViewController.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/11.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong,nonatomic) NSDate *date;
@property (copy, nonatomic) dateCallBack block;
@property (assign,nonatomic) UIDatePickerMode dateMode;
@end

@implementation DatePickerViewController
+(instancetype)initMyViewCtrlWithDate:(NSDate*)date callback:(dateCallBack)block pickerDateMode:(UIDatePickerMode)dateMode{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DatePickerViewController *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.date = date;
    vc.block = block;
    vc.dateMode = dateMode;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.date = self.date;
    self.datePicker.datePickerMode = self.dateMode;
    self.confirmBtn.layer.cornerRadius = 6.0f;
    self.confirmBtn.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitSelectDate:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *selectDateString = [formatter stringFromDate:self.datePicker.date];
    if (self.block)
        self.block(selectDateString);
    [self.navigationController popViewControllerAnimated:YES];
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
