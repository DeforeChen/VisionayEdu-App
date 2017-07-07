//
//  DocumentViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "DocumentViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "ProfileDocumentModel.h"
#import "TabBarManagerViewCtrl.h"
#import <WebKit/WebKit.h>

@interface DocumentViewCtrl ()
@property (strong,nonatomic) ProfileDocumentModel *model;
@end

@implementation DocumentViewCtrl
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SysTool showLoadingHUDWithMsg:@"获取档案信息中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username};
    [[SYHttpTool sharedInstance] getReqWithURL:QUERY_PROFILE token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            self.model = [ProfileDocumentModel mj_objectWithKeyValues:responseObject];
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DocumentCell *cell = [DocumentCell initMyCellWithCallBack:^(NSString *url) {
        if (url == nil) {
            [SysTool showErrorWithMsg:@"该信息未录入" duration:1];
        } else {
            XLog(@"网址 = %@",url);
            UIViewController *vc = [UIViewController new];
            TabBarManagerViewCtrl *tabManager = (TabBarManagerViewCtrl*)vc.tabBarController;
            tabManager.customTabbar.hidden = YES;
            WKWebView *web = [[WKWebView alloc] initWithFrame:vc.view.frame];
            [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            [vc.view addSubview:web];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
                                                    tableview:tableView
                                              documentURL_LUT:[self.model fetchDocumentURL_LUT]];
    
    return cell;
}

@end

#pragma mark Cell
@interface DocumentCell()
@property (copy,nonatomic) ForwardWebBlk blk;
@property (copy,nonatomic) NSDictionary *urlLUT;
@end

@implementation DocumentCell
+(instancetype)initMyCellWithCallBack:(ForwardWebBlk)urlBlk tableview:(UITableView *)tableview documentURL_LUT:(NSDictionary*)lut {
    DocumentCell *cell = (DocumentCell*)[tableview dequeueReusableCellWithIdentifier:@"profile"];
    cell.blk = urlBlk;
    cell.urlLUT = lut;
    return cell;
}

- (IBAction)jumpToWebAccordingToTag:(UIButton *)sender {
    NSString *key = [NSString stringWithFormat:@"%d",(int)sender.tag];
    if ([[self.urlLUT allKeys] containsObject:key]) {
        self.blk(self.urlLUT[key]);
    } else
        self.blk(nil);
}


@end
