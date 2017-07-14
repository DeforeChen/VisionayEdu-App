//
//  StaffListModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/10.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffList_Results :NSObject
@property (nonatomic , assign) BOOL              for_appointment;
@property (nonatomic , copy) NSString              * full_name;

@end

@interface StaffListModel :NSObject
@property (nonatomic , copy) NSString                       * previous;
@property (nonatomic , strong) NSArray<StaffList_Results *>  * results;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * next;

@end
