//
//  CommentViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "CommentViewCtrl.h"

@interface CommentViewCtrl ()
@property (weak, nonatomic) IBOutlet UITextView *selfCmtTextView;
@property (weak, nonatomic) IBOutlet UITextView *staffCmtTextView;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg;

@property (copy,nonatomic) NSString *studentCmt;
@property (copy,nonatomic) NSString *staffCmt;
@property (assign,nonatomic) FlagColor color;

@end

@implementation CommentViewCtrl
+(instancetype)initMyViewCtrlWithStaffComment:(NSString*)staffCmt StudentComment:(NSString*)studentCmt flag:(FlagColor)color {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.studentCmt = studentCmt;
    vc.staffCmt   = staffCmt;
    vc.color      = color;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selfCmtTextView.text = self.studentCmt;
    self.selfCmtTextView.editable = NO;
    self.staffCmtTextView.text = self.staffCmt;
    self.staffCmtTextView.editable = NO;
    [self updateFlagImgView:self.color];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateFlagImgView:(FlagColor)color {
    switch (color) {
        case GreenFlag:
            self.flagImg.image = [UIImage imageNamed:@"flag_green"];
            break;
        case YellowFlag:
            self.flagImg.image = [UIImage imageNamed:@"flag_yellow"];
            break;
        case RedFlag:
            self.flagImg.image = [UIImage imageNamed:@"flag_red"];
            break;
        case DefaultFlag:
            self.flagImg.image = [UIImage imageNamed:@"flag_teacher"];
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
