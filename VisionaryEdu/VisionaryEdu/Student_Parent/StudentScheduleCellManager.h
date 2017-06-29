//
//  StudentScheduleCellManager.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/28.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Tasks;
@class FutureTests;
@class CheckInRecords;

@interface FutureTestCell:UITableViewCell
+(FutureTestCell *)initMyCellWithTableview:(UITableView *)tableview testModel:(FutureTests*)test;
@end

@interface CheckInRecordsCell:UITableViewCell
+(CheckInRecordsCell *)initMyCellWithTableview:(UITableView *)tableview recordModel:(CheckInRecords*)record;
@end

@interface TasksCell:UITableViewCell
+(TasksCell *)initMyCellWithTableview:(UITableView *)tableview taskModel:(Tasks*)task ;
@end
