//
//  StudentScoreViewCtrl.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/3.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentScoreViewCtrl.h"
#import "SYHttpTool.h"
#import "SysTool.h"
#import "StudentScoreInDetailsModel.h"
#import "scoreInDetailTableViewCell.h"
#import "ScoreChartView.h"

#import <MJExtension/MJExtension.h>
#import "YQNumberSlideView.h"

@interface StudentScoreViewCtrl ()<YQNumberSlideViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (copy,nonatomic) NSDictionary *scoreInfoDict;
// 下面两个值，分别对应 StudentScoreInDetailsModel 的property名和对应的值组成的数组
@property (copy,nonatomic) NSArray      *testNameArray;
@property (copy,nonatomic) NSArray<NSArray<id<scoreModelProtocol>>*> *scoreInfoArray;

@property (assign,nonatomic) int testItemName;
@property (weak, nonatomic) IBOutlet UIView *scoreOptionsView;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UITableView *scoreInfoListTB;
@end

@implementation StudentScoreViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    [SysTool showLoadingHUDWithMsg:@"加载成绩中..." duration:0];
    NSString *scoreURL = [NSString stringWithFormat:@"%@%@",VISIONARY_HOST,STUDENT_SCORE];
//    [[SYHttpTool sharedInstance] getReqWithURL:scoreURL completionHandler:^(BOOL success, NSString *msg, id responseObject) {
//        [SysTool dismissHUD];
//        if (success) {
//            StudentScoreInDetailsModel *model = [StudentScoreInDetailsModel mj_objectWithKeyValues:responseObject];
//            self.scoreInfoDict  = [model fetchCorrespondingScoreDict];
//            self.testNameArray  = [self.scoreInfoDict allKeys];
//            self.scoreInfoArray = [[self scoreInfoDict] allValues];
//            // 获取模型成功后，去更新选项条
//            [self initScoreOptionView];
//            [self initChartView];
//            [self.scoreInfoListTB reloadData];
//            NSLog(@"score keys = %@",self.testNameArray);
//        } else {
//            [SysTool showAlertWithMsg:@"网络请求失败，请检查网络" handler:^(UIAlertAction *action) {
//                [SysTool popCurrentNavViewCtrlWithStyle:UIViewAnimationOptionTransitionCrossDissolve NavViewCtrl:self.navigationController duration:0.5];
//            } viewCtrl:self];
//        }
//    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary *)scoreInfoDict {
    if (_scoreInfoDict == nil) {
        _scoreInfoDict = [NSDictionary new];
    }
    return _scoreInfoDict;
}

-(NSArray *)scoreInfoArray {
    if (_scoreInfoArray == nil) {
        _scoreInfoArray = [NSArray new];
    }
    return _scoreInfoArray;
}

-(NSArray *)testNameArray {
    if (_testNameArray == nil) {
        _testNameArray = [NSArray new];
    }
    return _testNameArray;
}

#pragma mark OptionView Init
-(void)initScoreOptionView {
    YQNumberSlideView *slideView = [[YQNumberSlideView alloc] initWithFrame:self.scoreOptionsView.bounds];
    [self.scoreOptionsView addSubview:slideView];
    
    slideView.delegate = self;
    self.testItemName = 0;
    slideView.backgroundColor = [UIColor colorWithWhite:0.931 alpha:1.000];
    [slideView setlabelCount:(int)self.testNameArray.count];
    [slideView setShowArray:self.testNameArray];
    //彩色模式
//    [slideView DiffrentColorModeWithMainColorR:0.154 G:1.000 B:0.063
//                                     SecColorR:0.281 G:0.772 B:0.970];
    [slideView show];
}

#pragma mark ChartView Init
-(void)initChartView {
    ScoreChartView *scView = [ScoreChartView initMyViewWithHalfFrame:self.chartView.frame];
    [self.chartView addSubview:scView];
}

#pragma mark Delegate
#pragma makr -- tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.scoreInfoArray.count >0) {
        NSArray *someScoreInDetailArray = self.scoreInfoArray[self.testItemName];
        return someScoreInDetailArray.count;
    } else
        return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    id<scoreModelProtocol> score = [self.scoreInfoArray[self.testItemName] objectAtIndex:index];

    scoreInDetailTableViewCell *cell = [scoreInDetailTableViewCell initWithTableView:tableView
                                                                          tableIndex:(int)indexPath.row
                                                                            testType:self.testNameArray[self.testItemName]
                                                                           scoreInfo:score];
    return cell;
}

#pragma mark YQNumberSlideViewDelegate
-(void)YQSlideViewDidChangeIndex:(int)count {
    self.testItemName = count;
    [self.scoreInfoListTB reloadData];
}

@end
