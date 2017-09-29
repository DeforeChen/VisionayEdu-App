//
//  SingleGradeView.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/3.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentScoreInDetailsModel.h"

typedef void(^checkDetail)(void);
@interface SingleGradeView : UIView

/**
 初始化

 @param gradeModel 成绩model
 @param page 页码索引
 @param height view 高度
 @param checkDetailBlk 查看详情的回调
 @return 五维图View
 */
+(instancetype)initMyViewWithGradeModel:(id<scoreModelProtocol>)gradeModel
                              PageIndex:(NSInteger)page
                                 Height:(CGFloat)height
                         checkDetailBlk:(checkDetail)checkDetailBlk;
@end
