//
//  SysTool.m
//  test
//
//  Created by Chen Defore on 2017/5/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "SysTool.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <RegExCategories/RegExCategories.h>

@interface SysTool()
//@property(nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation SysTool
#pragma mark 警告框提示
+ (void)showAlertWithMsg:(NSString *)msg handler:(void (^)(UIAlertAction *action))blk viewCtrl:(UIViewController *)vc {
    UIAlertController *altertCtrl = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert
                                     ];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好"
                                                       style:UIAlertActionStyleDefault
                                                     handler:blk];
    [altertCtrl addAction:okAction];
    [vc presentViewController:altertCtrl animated:YES completion:nil];
}

+ (void)showTipWithMsg:(NSString *)msg handler:(void (^)(UIAlertAction *action))blk viewCtrl:(UIViewController *)vc {
    UIAlertController *altertCtrl = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert
                                     ];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好"
                                                       style:UIAlertActionStyleDefault
                                                     handler:blk];
    [altertCtrl addAction:okAction];
    [altertCtrl addAction:cancelAction];
    [vc presentViewController:altertCtrl animated:YES completion:nil];
}

#pragma mark HUD
+ (void)showLoadingHUDWithMsg:(NSString *)msg duration:(NSTimeInterval)time {
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:msg];
    if (time > 0) {
        [SVProgressHUD dismissWithDelay:time];
    }
}

+ (void)showErrorWithMsg:(NSString *)msg {
    [SysTool showErrorWithMsg:msg duration:3.f];
}

+ (void)showErrorWithMsg:(NSString *)msg duration:(NSTimeInterval)time {
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showImage:nil status:msg];
    if (time > 0) {
        [SVProgressHUD dismissWithDelay:time];
    }
}

+ (void)dismissHUD {
    [SVProgressHUD dismiss];
}

#pragma mark 二维码生成
+ (UIImageView *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [[UIImageView alloc] initWithImage:[UIImage imageWithCIImage:transformedImage]];
}

#pragma mark 时间
+ (BOOL)judgeDateIsOverdue:(NSString *)dateToJudge validTime:(NSTimeInterval)seconds {
    // 根据字符串，格式，市区 生成到对应的 NSDate
    // 1. 设置时间格式 ,@"yyyyMMdd HHmmss"或"yyyy-MM-dd HH:mm:ss"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd HHmmss"];
    
    // 2. 设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:dateToJudge];
    NSLog(@"%@", date);
    
    // 3. 给定时间，加上保质期
    [date dateByAddingTimeInterval:seconds];
    NSLog(@"添加了对应时间后");
    // 4. 比较时间
    NSLog(@"当前日期= %@",[NSDate new]);
    if ([[NSDate new] timeIntervalSinceDate:date] < 0.0f) {
        NSLog(@"未过期");
        return YES;
    } else {
        NSLog(@"过期");
        return NO;
    }
}

+(NSString *)fetchCurrentDateTimeWithFormat:(NSString*)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HHmmss"];
    [formatter setDateFormat:dateFormat]; //非法的格式如何判断

    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"当前时间  =%@",dateTime);
    return dateTime;
}

#pragma mark 正则表达式
+(BOOL)judgeRegExWithType:(JudgeType)type String:(NSString*)str {
    NSLog(@"待正则判断的字符串 = %@",str);
    switch (type) {
        case Judge_PhoneNum:
            return [str isMatch:RX(@"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$")];
            break;
        case Judge_Amount:
            return [str isMatch:RX(@"^[0-9]+(\\.[0-9]{1,2})?$")];
            break;
        case Judge_CertID:
            return [str isMatch:RX(@"^(\\d{14}|\\d{17})(\\d|[xX])$")];
            break;
        case Judge_IntNumber:
            return [str isMatch:RX(@"^[0-9]+$")];
            break;
        case Judge_MailBox:
            return [str isMatch:RX(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")];
            break;
        case Judge_BankCardNo:
            return [SysTool checkCardNo:str];
            break;
        case Judge_ChineseOrPunctuation:
            return [str isMatch:RX(@"^[\u4e00-\u9fa5]*$")] || [str isMatch:RX(@"[\u3002\uff1b\uff0c\uff1a\u201c\u201d\uff08\uff09\u3001\uff1f\u300a\u300b]")];
            break;
        case Judge_EnglishOrNumOrPunctuation:{
            BOOL whether_EnglishRelated = [str isMatch:RX(@"^[a-zA-Z0-9_ -/:;()$&@\".,?!'{}#%^*+=\\|~<>€£¥•]+$")];//[\u4E00-\u9FA5a-zA-Z0-9_]*
            NSLog(@"字符是否为数字，标点或英文 = %d ",whether_EnglishRelated);
//            NSLog(@"test = %d",[@"uj" isMatch:RX(@"^[a-zA-Z0-9_ ]+$")]);
            return whether_EnglishRelated;
            break;
        }
    }
}

+ (BOOL)checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

#pragma mark 去掉前后空格
+(NSString*)TrimSpaceString:(NSString*)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string;
}
@end
