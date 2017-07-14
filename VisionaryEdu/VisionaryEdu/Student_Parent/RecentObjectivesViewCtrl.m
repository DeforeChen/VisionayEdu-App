//
//  RecentObjectivesViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/8.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "RecentObjectivesViewCtrl.h"
#import "config.h"
#import "RecentObjectivesModel.h"
#import <MJExtension/MJExtension.h>
#import "TabBarManagerViewCtrl.h"
#import "UIColor+expanded.h"
#import "ObjDetailsUViewCtrl.h"

@interface RecentObjectivesViewCtrl ()
@property (copy,nonatomic) NSArray<Obj_Results*> *objArray;
@end

@implementation RecentObjectivesViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F9"];
    [SysTool showLoadingHUDWithMsg:@"获取近期目标信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_OBJ token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            RecentObjectivesModel *model = [RecentObjectivesModel mj_objectWithKeyValues:responseObject];
            if (model.results.count == 0) {
                [SysTool showErrorWithMsg:@"当前无近期目标" duration:1];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.objArray = model.results;
                [self.tableView reloadData];
            }
        } else {
            [SysTool showErrorWithMsg:msg duration:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Obj_Cell *cell = (Obj_Cell*)[tableView dequeueReusableCellWithIdentifier:@"obj"];
    Obj_Results *info = self.objArray[indexPath.row];
    cell.titleLB.text = info.objective;
    cell.timeLB.text = [NSString stringWithFormat:@"%@ 至 %@",info.begin_date,info.end_date];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[ObjDetailsUViewCtrl class]]) {
        ObjDetailsUViewCtrl *vc = destVC;
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        XLog(@"点击的行数 = %@",path);
        vc.objInfo = self.objArray[path.row];
    }
}
@end

@implementation Obj_Cell

@end
