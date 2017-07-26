//
//  GradeTendingViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/4.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "GradeTendingViewCtrl.h"
#import "YQNumberSlideView.h"
#import "config.h"
#import "UIColor+expanded.h"
#import <FSLineChart/FSLineChart.h>
#import "TabBarManagerViewCtrl.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface GradeTendingViewCtrl ()<YQNumberSlideViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) FSLineChart *lineChart;
@property (weak, nonatomic) IBOutlet UIView *lineChartContainerView;
@property (weak, nonatomic) IBOutlet UITableView *gradeList;
@property (strong,nonatomic) YQNumberSlideView *slideView;

// 下面两个值，分别对应 StudentScoreInDetailsModel 的property名和对应的值组成的数组
@property (copy,nonatomic)  NSArray         *gradeNameArray;
@property (copy,nonatomic) NSArray<NSArray<id<scoreModelProtocol>>*> *gradeInfoArray;
@property (assign,nonatomic) NSInteger      selectGradeIndex;//选中的某一类考试
@end

@implementation GradeTendingViewCtrl
+(instancetype)initMyViewWithGradeNameArray:(NSArray*)gradeNameArray GradeInfoArray:(NSArray<NSArray<id<scoreModelProtocol>>*>*)gradeInfoArray {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GradeTendingViewCtrl *vc = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.gradeNameArray = gradeNameArray;
    vc.gradeInfoArray = gradeInfoArray;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self configGradeOptionViewUI];
//    [self updateGradeViewScrollContainerWithGradeInfos:self.gradeInfoArray[self.selectGradeIndex]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.slideView != nil) {
        [self.slideView show];
    }
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateGradeViewScrollContainerWithGradeInfos:self.gradeInfoArray[self.selectGradeIndex]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Getter
-(NSArray *)gradeNameArray {
    if (_gradeNameArray == nil)
        _gradeNameArray = [NSArray new];
    return _gradeNameArray;
}

-(NSArray<NSArray<id<scoreModelProtocol>> *> *)gradeInfoArray {
    if (_gradeInfoArray == nil) {
        _gradeInfoArray = [NSArray new];
    }
    return _gradeInfoArray;
}

#pragma mark Private Methods
- (void)createLineChartWithXLabel:(NSArray*)XDateLabel SrcData:(NSArray*)srcDataArray {
    // Setting up the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:self.lineChartContainerView.bounds];
    self.lineChart.verticalGridStep = 5;
    self.lineChart.horizontalGridStep = ((int)XDateLabel.count-1 == 0)?1:(int)XDateLabel.count-1;
    self.lineChart.fillColor = [UIColor colorWithHexString:@"#E3F5F0"];
    self.lineChart.lineWidth = 3;
    self.lineChart.animationDuration = 1.0;
    self.lineChart.bezierSmoothing = YES;
//    [self.lineChart setClearsContextBeforeDrawing:YES];
    self.lineChart.displayDataPoint = YES;
    self.lineChart.dataPointRadius = 2.f;
    
    self.lineChart.color = [self.lineChart.dataPointColor colorWithAlphaComponent:0.3];
    self.lineChart.valueLabelPosition = ValueLabelRight;
    
    self.lineChart.labelForIndex = ^(NSUInteger item) {
        XLog(@"x轴 x = %lu",(unsigned long)item);
        if ([XDateLabel[item] length] >= 5) {
            return [XDateLabel[item] substringFromIndex:5];
        } else
            return (NSString*)XDateLabel[item];
    };

    [self.lineChart setChartData:srcDataArray];
    [self.lineChartContainerView addSubview:self.lineChart];
}

- (void)configGradeOptionViewUI {
    CGRect gradeOptionRect = CGRectMake(0, HEIGHT-44, WIDTH, 44);
    self.slideView = [[YQNumberSlideView alloc] initWithFrame:gradeOptionRect];
    [self.view addSubview:self.slideView];
    
    self.slideView.delegate = self;
    self.selectGradeIndex = 0;
    self.slideView.backgroundColor = [UIColor whiteColor];

    [self.slideView setlabelCount:(int)self.gradeNameArray.count];
    [self.slideView setShowArray:self.gradeNameArray];
    //彩色模式
    //    [slideView DiffrentColorModeWithMainColorR:0.154 G:1.000 B:0.063
    //                                     SecColorR:0.281 G:0.772 B:0.970];
    [self.slideView show];
}

- (void)updateGradeViewScrollContainerWithGradeInfos:(NSArray<id<scoreModelProtocol>>*)gradeInfoArray {
    NSMutableArray *xTimeLabel = [NSMutableArray new];
    NSMutableArray *gradeValue = [NSMutableArray new];
//    NSArray *array = [[gradeInfoArray reverseObjectEnumerator] allObjects];
    for (id<scoreModelProtocol>gradeInfo in gradeInfoArray) {
        [xTimeLabel addObject:(gradeInfo.test_schedule_info.date == nil)?@"":gradeInfo.test_schedule_info.date];
        [gradeValue addObject:[gradeInfo fetchSingleGradeInfoDict][TotalScore]];
    }
    [self createLineChartWithXLabel:xTimeLabel SrcData:gradeValue];
}

#pragma mark YQNumberSlideViewDelegate
-(void)YQSlideViewDidChangeIndex:(int)count {
    self.selectGradeIndex = count;
    [self.lineChart removeFromSuperview];
    [self updateGradeViewScrollContainerWithGradeInfos:self.gradeInfoArray[self.selectGradeIndex]];
    [self.gradeList reloadData];
}

#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gradeInfoArray[self.selectGradeIndex].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradeTotalScoreCell *cell = (GradeTotalScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"totalScore"];
    id<scoreModelProtocol> gradeInfo = self.gradeInfoArray[self.selectGradeIndex][indexPath.row];
    cell.cellIndexLB.text = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1];
    cell.testTimeLB.text  = (gradeInfo.test_schedule_info.date == nil)?@"":gradeInfo.test_schedule_info.date;
    cell.totalScore.text  = [NSString stringWithFormat:@"%@",[gradeInfo fetchSingleGradeInfoDict][TotalScore]];
    cell.testPlaceLB.text = gradeInfo.test_schedule_info.place;
    return cell;
}
@end

@implementation GradeTotalScoreCell

@end
