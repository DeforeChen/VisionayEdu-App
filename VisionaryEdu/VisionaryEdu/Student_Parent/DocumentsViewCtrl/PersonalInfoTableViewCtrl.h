//
//  PersonalInfoTableViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoTableViewCtrl : UITableViewController

@end

@interface PersonalInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *genderLB;
@property (weak, nonatomic) IBOutlet UILabel *natianalityLB;
@property (weak, nonatomic) IBOutlet UILabel *expectedDegreeLB;
@property (weak, nonatomic) IBOutlet UILabel *interested_majorLB;
@property (weak, nonatomic) IBOutlet UILabel *expectedJobLB;
@property (weak, nonatomic) IBOutlet UILabel *hobbiesLB;
@property (weak, nonatomic) IBOutlet UILabel *religiousPreferenceLB;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLB;
@property (weak, nonatomic) IBOutlet UILabel *birthPlaceLB;
@property (weak, nonatomic) IBOutlet UILabel *idNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *usedNameLB;
@property (weak, nonatomic) IBOutlet UILabel *sexualOrientationLB;
@property (weak, nonatomic) IBOutlet UILabel *EmailLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *mailAddressLB;
@property (weak, nonatomic) IBOutlet UILabel *postCodeLB;

@end
