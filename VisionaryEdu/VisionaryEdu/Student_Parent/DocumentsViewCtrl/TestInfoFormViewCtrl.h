//
//  TestInfoFormViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestInfoFormViewCtrl : UITableViewController

@end

@interface TestAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountLB;
@property (weak, nonatomic) IBOutlet UILabel *pwdLB;
@property (weak, nonatomic) IBOutlet UILabel *testNameLB;

@end
