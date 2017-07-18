//
//  DatePickerViewController.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/11.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dateCallBack)(NSString *selectDateStr);
@interface DatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

+(instancetype)initMyViewCtrlWithDate:(NSDate*)date callback:(dateCallBack)block pickerDateMode:(UIDatePickerMode)dateMode;
@end
