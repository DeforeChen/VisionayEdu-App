//
//  HonorActivityViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HonorActivityViewCtrl : UITableViewController

@end

@interface HonorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *rankLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *placeLB;
@property (weak, nonatomic) IBOutlet UILabel *organizationLB;

@end

@interface ActivityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *positionlB;
@property (weak, nonatomic) IBOutlet UITextView *accomplishmentTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeLB;
@property (weak, nonatomic) IBOutlet UILabel *timePeriodLB;

@end
