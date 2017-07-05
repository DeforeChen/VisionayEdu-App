//
//  CommentViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    DefaultFlag = 0,
    GreenFlag,
    YellowFlag,
    RedFlag
} FlagColor;
@interface CommentViewCtrl : UIViewController
+(instancetype)initMyViewCtrlWithStaffComment:(NSString*)staffCmt StudentComment:(NSString*)studentCmt flag:(FlagColor)color;
@end
