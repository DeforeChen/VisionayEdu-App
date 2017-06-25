//
//  scoreInDetailTableViewCell.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/4.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "scoreInDetailTableViewCell.h"

#define TestStr @" 考试信息"

@interface scoreInDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *cellIndexLB;
@property (weak, nonatomic) IBOutlet UILabel *testTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *testPlaceLB;

@end


@implementation scoreInDetailTableViewCell
+(scoreInDetailTableViewCell*)initWithTableView:(UITableView*)tableview
                                     tableIndex:(int)index
testType:(NSString *)type scoreInfo:(id<scoreModelProtocol>)info {
    scoreInDetailTableViewCell *cell = (scoreInDetailTableViewCell*)[tableview dequeueReusableCellWithIdentifier:@"scoreInDetailCell"];

    NSString *date  = (info.date == nil)?@"":info.date;
    NSString *time  = (info.time == nil)?@"":info.time;
    NSString *place = (info.place == nil || [info.place isEqualToString:@""])?@"":[NSString stringWithFormat:@"考试地点:%@",info.place];
    
    cell.dateAndTimeLB.text = [NSString stringWithFormat:@"%@\n%@",date,time];
    cell.cellIndexLB.text   = [NSString stringWithFormat:@"%d",index+1];
    cell.testTypeLB.text    = [NSString stringWithFormat:@"%@%@",type,TestStr];
    cell.testPlaceLB.text   = place;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
