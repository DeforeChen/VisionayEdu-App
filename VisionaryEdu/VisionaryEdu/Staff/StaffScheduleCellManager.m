//
//  StaffScheduleCellManager.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StaffScheduleCellManager.h"
#import "StaffScheduleModel.h"
#import "StudentScheduleModel.h"

@interface StaffCheckInRecordsCell()
@property (weak, nonatomic) IBOutlet UILabel *topicLB;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLB;

@end

@implementation StaffCheckInRecordsCell
+(instancetype)initMyCellWithStaffRecordModel:(CheckInRecords*)records tableview:(UITableView*)tableview {
    StaffCheckInRecordsCell *cell = (StaffCheckInRecordsCell*)[tableview dequeueReusableCellWithIdentifier:@"StaffCheckinRecord"];
    cell.topicLB.text = records.topic;
    cell.recordTimeLB.text = records.time;
    return cell;
}
@end

@interface StaffMeetingCell ()
@property (weak, nonatomic) IBOutlet UILabel *inventedGuysLB;
@property (weak, nonatomic) IBOutlet UILabel *meetingTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *meetingPlaceLB;
@property (weak, nonatomic) IBOutlet UILabel *meetingTopicLB;
@end

@implementation StaffMeetingCell
+(instancetype)initMyCellWithMeetingModel:(Meetings*)meeting tableview:(UITableView*)tableview {
    StaffMeetingCell *cell = (StaffMeetingCell*)[tableview dequeueReusableCellWithIdentifier:@"meeting"];
    cell.inventedGuysLB.text = [[meeting.staff_all mutableCopy] componentsJoinedByString:@","];
    cell.meetingTimeLB.text = meeting.time;
    cell.meetingPlaceLB.text = meeting.place;
    cell.meetingTopicLB.text = [NSString stringWithFormat:@"会议-%@",meeting.topic];
    return cell;
}

@end
