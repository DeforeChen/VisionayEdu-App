//
//  SysTool.h
//  test
//
//  Created by Chen Defore on 2017/5/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

typedef enum : NSUInteger {
    Judge_PhoneNum,
    Judge_IntNumber,//判断整数
    Judge_EnglishOrNum, //英文或数字
    Judge_CertID,
    Judge_BankCardNo,
    Judge_Amount,
    Judge_MailBox //判断邮箱
} JudgeType;
@interface SysTool : NSObject
/**
 message box 弹框提示
 
 @param msg 消息
 @param blk 点击OK后的操作
 @param vc 在哪个vc上添加通知
 */
+ (void)showAlertWithMsg:(NSString*)msg handler:(void (^)(UIAlertAction *action))blk viewCtrl:(UIViewController*)vc;


/**
 添加HUD提示框
 
 @param msg 提示信息
 @param time 持续时间，若为0，表示一直显示
 */
+ (void)showLoadingHUDWithMsg:(NSString *)msg duration:(NSTimeInterval)time;



/**
 显示提示信息的HUD

 @param msg 信息
 @param time 持续时间，若为0则一直显示
 */
+ (void)showErrorWithMsg:(NSString *)msg duration:(NSTimeInterval)time ;
/**
 消失提示框
 */
+ (void)dismissHUD;

#pragma mark 二维码生成
/**
 生成二维码图片
 @param code 字符串
 @param width frame宽
 @param height frame高
 @return 图片
 */
+ (UIImageView *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

#pragma mark 时间
/**
 判断某个时间是否过期
 @param dateToJudge 某个日期时间
 @param seconds 保质期（记住以秒为单位）
 @return 是否过期
 */
+ (BOOL)judgeDateIsOverdue:(NSString *)dateToJudge validTime:(NSTimeInterval)seconds;

/**
 获取当前日期时间
 @param  dateFormat 时间格式
 @return 返回 dateFormat 时间格式对应的时间
 */
+(NSString *)fetchCurrentDateTimeWithFormat:(NSString*)dateFormat;


#pragma mark 正则表达

/**
 判断字符串是否为某种类型
 
 @param type 判断类型
 @param str 原字符串
 @return 是/否
 */
+(BOOL)judgeRegExWithType:(JudgeType)type String:(NSString*)str;
@end
