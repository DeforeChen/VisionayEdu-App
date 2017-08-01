//
//  StudentInfoTableViewCell.h
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/5/29.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UnderGraduation,
    HighSchoolGuardiance,
    Both,
} ServiceType;

@interface StudentInfoTableViewCell : UITableViewCell

+(instancetype)fetchMyCellWithTableView:(UITableView*)tableview
                            studentName:(NSString*)name
                            serviceType:(ServiceType)type
                              className:(NSInteger)className
                            checkinTime:(NSString*)totalTime
                           registerTime:(NSString*)time;
@end

@interface GradeSectionTitileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gradeLB;
@end
