//
//  StaffScheduleInventionsViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/10.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffScheduleModel.h"


typedef void(^SelectionInfoUnderCreateMode)(StaffScheduleType type, NSArray *selectGuys);
typedef void(^SelectionInfoUnderModifyMode)(NSArray *selectGuys);
typedef enum : NSUInteger {
    CreateMode,
    ModifyMode,
    ModifyConsultantMode,
} UseMode;
@interface StaffScheduleInventionsViewCtrl : UIViewController

/**
 本VC为复用类。当新增/修改员工日程，需要选择员工列表时使用

 @param mode 修改模式或新增模式
 @param type 修改模式下，传入日程类型(会议/约谈)
 @param hasBeenIncludedGuys 那些已经被要请的人，新建模式下，即为当前用户的真实姓名
 @param createBlk 只在新增模式时使用，新增模式下，回传日程类型（会议/约谈）;修改模式下，回传选中的人
 @param modifyBlk 只在修改模式时使用，修改模式下，回传选中的人
 @return vc
 */
+(instancetype)initMyViewCtrlWithUseMode:(UseMode)mode
             scheduleTypeUnderModifyMode:(StaffScheduleType)type
                    guysHaveBeenIncluded:(NSArray*)hasBeenIncludedGuys
                          createCallback:(SelectionInfoUnderCreateMode)createBlk
                          modifyCallback:(SelectionInfoUnderModifyMode)modifyBlk;
@end





@interface Schedule_RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *tipImg;

@end

@interface Schedule_MeetingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIImageView *tipImg;

@end
