//
//  TestInfoFormViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/5.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "TestInfoFormViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "TestAccountModel.h"
#import "TabBarManagerViewCtrl.h"

typedef enum : NSUInteger {
    toeflTest,
    satTest,
    actTest,
    apTest,
    a_levelTest,
    ieltsTest,
    ibTest
} TestType;
@interface TestInfoFormViewCtrl ()
@property (nonatomic,strong) TestAccountModel *model;
@end

@implementation TestInfoFormViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SysTool showLoadingHUDWithMsg:@"获取账号信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_TESTACCOUNT token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            self.model = [TestAccountModel mj_objectWithKeyValues:responseObject];
            [self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestAccountCell *cell = (TestAccountCell*)[tableView dequeueReusableCellWithIdentifier:@"accountInfo"];
    TestType type = indexPath.row;
    if (self.model.results.count > 0) {
        Results *accountInfo = self.model.results[0];
        switch (type) {
            case toeflTest:
                cell.testNameLB.text = @"托福";
                cell.accountLB.text = accountInfo.toefl_id;
                cell.pwdLB.text = accountInfo.toefl_password;
                break;
            case satTest:
                cell.testNameLB.text = @"SAT";
                cell.accountLB.text = accountInfo.sat_id;
                cell.pwdLB.text = accountInfo.sat_password;
                break;
            case actTest:
                cell.testNameLB.text = @"ACT";
                cell.accountLB.text = accountInfo.act_id;
                cell.pwdLB.text = accountInfo.act_password;
                break;
            case apTest:
                cell.testNameLB.text = @"AP";
                cell.accountLB.text = accountInfo.ap_id;
                cell.pwdLB.text = accountInfo.ap_password;
                break;
            case a_levelTest:
                cell.testNameLB.text = @"A_Level";
                cell.accountLB.text = accountInfo.a_level_id;
                cell.pwdLB.text = accountInfo.a_level_password;
                break;
            case ieltsTest:
                cell.testNameLB.text = @"雅思";
                cell.accountLB.text = accountInfo.ielts_id;
                cell.pwdLB.text = accountInfo.ielts_password;
                break;
            case ibTest:
                cell.testNameLB.text = @"IB";
                cell.accountLB.text = accountInfo.ib_id;
                cell.pwdLB.text = accountInfo.ib_password;
                break;
        }
    } else {
    
    }
    return cell;
}


@end

@implementation TestAccountCell


@end
