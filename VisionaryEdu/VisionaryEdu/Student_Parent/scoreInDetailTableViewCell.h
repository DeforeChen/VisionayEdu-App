//
//  scoreInDetailTableViewCell.h
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/4.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScoreInDetailsModel.h"
typedef NS_ENUM(NSUInteger, FlagColor) {
    RedFlag = 0,
    YellowFlag,
    GreenFlag,
};

@interface scoreInDetailTableViewCell : UITableViewCell


/**
 返回具体的列表cell

 @param tableview 列表
 @param info 成绩的具体信息
 @param index 单元索引
 @param type 考试的类型信息
 @return cell
 */
+(scoreInDetailTableViewCell*)initWithTableView:(UITableView*)tableview
                                     tableIndex:(int)index
                                       testType:(NSString*)type
                                      scoreInfo:(id<scoreModelProtocol>)info;
@end
