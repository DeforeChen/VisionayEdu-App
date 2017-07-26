//
//  UnrecordGradeViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "UnrecordGradeViewCtrl.h"
#import "StudentScheduleModel.h"
#import "GradeDetailsViewCtrl.h"

@interface UnrecordGradeViewCtrl ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *unrecordList;
@end

@implementation UnrecordGradeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.unrecordModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UnrecordGradeCell *cell = [UnrecordGradeCell initMyCellWithTableView:tableView unrecordModel:self.unrecordModelArray[indexPath.row]];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[GradeDetailsViewCtrl class]]) {
        GradeDetailsViewCtrl *vc = destVC;
        NSIndexPath *path = [self.unrecordList indexPathForCell:sender];
        FutureTests *futuretestModel = [FutureTests new];
        FutureTestScheduleModel *scheduleModel = self.unrecordModelArray[path.row];
        futuretestModel.student_comment = scheduleModel.student_comment;
        futuretestModel.time            = scheduleModel.time;
        futuretestModel.staff_comment   = scheduleModel.staff_comment;
        futuretestModel.details         = scheduleModel.details;
        futuretestModel.date            = scheduleModel.date;
        futuretestModel.test_type       = scheduleModel.test_type;
        futuretestModel.whether_record_score = scheduleModel.whether_record_score;
        futuretestModel.place           = scheduleModel.place;
        futuretestModel.pk              = scheduleModel.pk;
        vc.gradeModel                   = futuretestModel;
    }
}

@end

@interface UnrecordGradeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *placeLB;
@end

@implementation UnrecordGradeCell
+(instancetype)initMyCellWithTableView:(UITableView*)tableview unrecordModel:(FutureTestScheduleModel*)model {
    UnrecordGradeCell *cell = [tableview dequeueReusableCellWithIdentifier:@"unrecord"];
    cell.timeLB.text  = [NSString stringWithFormat:@"%@ %@",model.date,model.time];
    cell.placeLB.text = model.place;
    cell.titleLB.text = [cell generateTitle:model.test_type];
    return cell;
}

-(NSString*)generateTitle:(TestType)testType {
    switch (testType) {
        case ToeflType:
            return @"托福";
            break;
        case ieltsType:
            return @"雅思";
            break;
        case SatType:
            return @"SAT";
            break;
        case ActType:
            return @"ACT";
            break;
        case Sat2Type:
            return @"SAT2";
            break;
        case APType:
            return @"AP";
            break;
    }
}

@end
