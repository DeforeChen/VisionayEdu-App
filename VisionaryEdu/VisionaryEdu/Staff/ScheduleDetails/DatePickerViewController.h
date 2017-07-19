//
//  DatePickerViewController.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/11.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dateCallBack)(NSString *selectDateStr);
typedef void(^durationCallBack)(NSString *lastTime);
@interface DatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


/**
 日期模式下的初始化

 @param date 日期
 @param block 选中后的回调
 @param dateMode 日期模式
 @return vc
 */
+(instancetype)initMyViewCtrlWithDate:(NSDate*)date callback:(dateCallBack)block pickerDateMode:(UIDatePickerMode)dateMode;


/**
 时长下的初始化

 @param duration 持续时间
 @param block 选中后的回调
 @return vc
 */
+(instancetype)initMyViewCtrlWithDuration:(NSTimeInterval)duration callback:(durationCallBack)block;
@end
