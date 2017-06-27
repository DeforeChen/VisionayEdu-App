//
//  StudentInfoTableViewCell.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/5/29.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentInfoTableViewCell.h"
@interface StudentInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLB;
@property (weak, nonatomic) IBOutlet UILabel *underGradLB;
@property (weak, nonatomic) IBOutlet UILabel *hs_GuardLB;//学护，美高
@property (weak, nonatomic) IBOutlet UILabel *userClassLB;
@property (weak, nonatomic) IBOutlet UILabel *registerTimeLB;

@end


@implementation StudentInfoTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.photoImgView.layer.cornerRadius = 100.0;
//    self.photoImgView.image = [UIImage imageNamed:@"headPhoto_placeHolder"];
    self.hs_GuardLB.layer.cornerRadius = 4.f;
    self.hs_GuardLB.clipsToBounds = YES;
    self.underGradLB.layer.cornerRadius = 4.f;
    self.underGradLB.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+(instancetype)fetchMyCellWithTableView:(UITableView*)tableview
                            studentName:(NSString*)name
                            serviceType:(ServiceType)type
                              className:(NSInteger)className
                           registerTime:(NSString*)time {
    StudentInfoTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"StudentIndexID"];
    
    cell.studentNameLB.text  = name;
    cell.userClassLB.text    = [NSString stringWithFormat:@"%d",(int)className];
    cell.registerTimeLB.text = time;
    switch (type) {
        case UnderGraduation: {
            cell.underGradLB.hidden = NO;
            cell.hs_GuardLB.hidden  = YES;
        }
            break;
        case HighSchoolGuardiance:{
            cell.underGradLB.hidden = YES;
            cell.hs_GuardLB.hidden  = NO;
        }
            break;
        case Both:{
            cell.underGradLB.hidden = NO;
            cell.hs_GuardLB.hidden  = NO;
        }
            break;
    }
    return cell;
}

@end

@implementation GradeSectionTitileCell


@end
