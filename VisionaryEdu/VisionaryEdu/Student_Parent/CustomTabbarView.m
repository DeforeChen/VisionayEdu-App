//
//  CustomTabbarView.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/27.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CustomTabbarView.h"
@interface CustomTabbarView()<UITabBarControllerDelegate>
@property (strong,nonatomic) UITabBarController *tabbarCtrl;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *meImgView;
@property (weak, nonatomic) IBOutlet UIImageView *scheduleImgView;
@end

@implementation CustomTabbarView
+(instancetype)initMyViewWithTabBarCtrl:(UITabBarController*)tabbarCtrl {
    CustomTabbarView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    CGRect frame = CGRectMake(0, tabbarCtrl.view.frame.size.height-48, tabbarCtrl.view.frame.size.width, 48);
    view.frame = frame;
    view.tabbarCtrl = tabbarCtrl;
    tabbarCtrl.delegate = view;
    return view;
}

-(void)setInitialPage:(NSInteger)index {
    self.tabbarCtrl.selectedIndex = index;
    [self setImgSelectedStatusWithIndex:index];
}

- (IBAction)selectCorrespondingTag:(UIButton *)sender {
    self.tabbarCtrl.selectedIndex = [sender tag];
    [self setImgSelectedStatusWithIndex:[sender tag]];
}

-(void)setImgSelectedStatusWithIndex:(NSInteger)index {
    self.gradeImgView.image    = [UIImage imageNamed:(index == 0)?@"grade_selected":@"grade_default"];
    self.scheduleImgView.image = [UIImage imageNamed:(index == 1)?@"schedule_selected":@"schedule_default"];
    self.meImgView.image       = [UIImage imageNamed:(index == 2)?@"me_selected":@"me_default"];
}

@end
