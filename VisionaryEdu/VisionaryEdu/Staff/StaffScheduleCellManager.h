//
//  StaffScheduleCellManager.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CheckInRecords;
@class Meetings;

@interface StaffCheckInRecordsCell : UITableViewCell
+(instancetype)initMyCellWithStaffRecordModel:(CheckInRecords*)records tableview:(UITableView*)tableview;
@end

@interface StaffMeetingCell : UITableViewCell
+(instancetype)initMyCellWithMeetingModel:(Meetings*)meeting tableview:(UITableView*)tableview ;
@end
