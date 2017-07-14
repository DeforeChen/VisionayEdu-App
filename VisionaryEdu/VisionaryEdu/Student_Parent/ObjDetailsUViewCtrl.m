//
//  ObjDetailsUViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ObjDetailsUViewCtrl.h"

@interface ObjDetailsUViewCtrl ()
@property (weak, nonatomic) IBOutlet UILabel *beginDateLB;
@property (weak, nonatomic) IBOutlet UILabel *endDateLB;
@property (weak, nonatomic) IBOutlet UILabel *objContentLB;
@property (weak, nonatomic) IBOutlet UITextView *staffCommentTextView;

@end

@implementation ObjDetailsUViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beginDateLB.text = self.objInfo.begin_date;
    self.endDateLB.text = self.objInfo.end_date;
    self.objContentLB.text = self.objInfo.objective;
    self.staffCommentTextView.text = self.objInfo.staff_comment;
    self.staffCommentTextView.editable = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
