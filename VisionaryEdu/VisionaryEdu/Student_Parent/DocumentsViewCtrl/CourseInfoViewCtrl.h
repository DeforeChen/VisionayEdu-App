//
//  CourseInfoViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseInfoViewCtrl : UITableViewController

@end

@interface ElectiveCoureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseLB;
@property (weak, nonatomic) IBOutlet UITextView *courseDescriptionLB;

@end

@interface HS_CourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *HS_CourseLB;
@end
