//
//  ScoreChartView.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ScoreChartView.h"
#import <PNChart/PNChart.h>
#import <PNChart/PNChartDelegate.h>

#define RadarAreaRect CGRectMake(0, -self.frame.size.height * 40/240, SCREEN_WIDTH, self.frame.size.height * 280.0/240)
#define LineAreaRect CGRectMake(0, 8, SCREEN_WIDTH, self.frame.size.height*0.8)

@interface ScoreChartView()<PNChartDelegate>
@property (assign,nonatomic) CGFloat myFrameWidth;
@property (assign,nonatomic) CGFloat myFrameHeight;
@property (nonatomic) PNRadarChart *radarChart;
@property (nonatomic) PNLineChart * lineChart;

@property (weak, nonatomic) IBOutlet UIView *radarChartContainerView;
@property (weak, nonatomic) IBOutlet UIView *lineChartContainerView;
@property (weak, nonatomic) IBOutlet UIButton *tendingBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;

@end

@implementation ScoreChartView
#pragma mark instance
+(instancetype)initMyViewWithHalfFrame:(CGRect)frameRect {
    ScoreChartView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
    CGFloat width = frameRect.size.width*2;
    view.frame = CGRectMake(0, 0, width, frameRect.size.height);
    [view updateRadarChartView];
    [view updateLineChartView];
    return view;
}

#pragma mark getter
-(CGFloat)myFrameWidth {
    _myFrameWidth = self.frame.size.width;
    return _myFrameWidth;
}

-(CGFloat)myFrameHeight {
    _myFrameHeight = self.frame.size.height;
    return _myFrameHeight;
}


#pragma mark UserInteraction
- (IBAction)checkScoreTending:(UIButton *)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.frame = CGRectMake(-self.myFrameWidth/2, 0, \
                                                 self.myFrameWidth, self.myFrameHeight);
                         self.lineChartContainerView.hidden = NO;
                         self.singleBtn.hidden = NO;
                     } completion:^(BOOL finished) {
                         self.radarChartContainerView.hidden = YES;
                         self.tendingBtn.hidden = YES;
                     }];
}

- (IBAction)checkSingleTestScore:(UIButton *)sender {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.frame = CGRectMake(0, 0, \
                                                 self.myFrameWidth, self.myFrameHeight);
                         self.radarChartContainerView.hidden = NO;
                         self.tendingBtn.hidden = NO;
                     } completion:^(BOOL finished) {
                         self.lineChartContainerView.hidden = YES;
                         self.singleBtn.hidden = YES;
                     }];
}

-(void)updateRadarChartView {
    NSArray *items = @[[PNRadarChartDataItem dataItemWithValue:3 description:@"Art"],
                       [PNRadarChartDataItem dataItemWithValue:2 description:@"Math"],
                       [PNRadarChartDataItem dataItemWithValue:8 description:@"Sports"],
                       [PNRadarChartDataItem dataItemWithValue:5 description:@"Literature"],
                       [PNRadarChartDataItem dataItemWithValue:4 description:@"Other"],
                       [PNRadarChartDataItem dataItemWithValue:7 description:@"reading"],
                       ];
    
    self.radarChart = [[PNRadarChart alloc] initWithFrame:RadarAreaRect items:items valueDivider:1];
    self.radarChart.plotColor = [UIColor blackColor];
    self.radarChart.webColor = [UIColor blackColor];
    self.radarChart.fontSize = 13.0f;
    [self.radarChart strokeChart];
    [self.radarChartContainerView addSubview:self.radarChart];
}

-(void)updateLineChartView {
    self.lineChart.backgroundColor = [UIColor whiteColor];
    self.lineChart.yGridLinesColor = [UIColor grayColor];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];
    
    self.lineChart = [[PNLineChart alloc] initWithFrame:LineAreaRect];
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:8.0];
    [self.lineChart setXLabels:@[@"SEP 1", @"SEP 2", @"SEP 3", @"SEP 4", @"SEP 5", @"SEP 6", @"SEP 7"]];
    self.lineChart.yLabelColor = [UIColor blackColor];
    self.lineChart.xLabelColor = [UIColor blackColor];
    
    // added an example to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    self.lineChart.showGenYLabels = NO;
    self.lineChart.showYGridLines = YES;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.lineChart.yFixedValueMax = 300.0;
    self.lineChart.yFixedValueMin = 0.0;
    
    [self.lineChart setYLabels:@[
                                 @"0 min",
                                 @"50 min",
                                 @"100 min",
                                 @"150 min",
                                 @"200 min",
                                 @"250 min",
                                 @"300 min",
                                 ]
     ];
    
    // Line Chart #1
    NSArray *data01Array = @[@15.1, @60.1, @110.4, @10.0, @186.2, @197.2, @276.2];
    data01Array = [[data01Array reverseObjectEnumerator] allObjects];
    PNLineChartData *data01 = [PNLineChartData new];
    
//    data01.rangeColors = @[
//                           [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(10, 30) color:[UIColor redColor]],
//                           [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(100, 200) color:[UIColor purpleColor]]
//                           ];
    data01.dataTitle = @"Alpha";
    data01.color = PNFreshGreen;
    data01.pointLabelColor = [UIColor blackColor];
    data01.alpha = 0.3f;
    data01.showPointLabel = YES;
    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = PNRed;
    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart #2
    NSArray *data02Array = @[@0.0, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"Beta";
    data02.pointLabelColor = [UIColor blackColor];
    data02.color = PNTwitterColor;
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleCircle;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01, data02];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];
    
    
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    
    
    [self.lineChartContainerView addSubview:self.lineChart];
    
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor redColor];
    
    UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
    [legend setFrame:CGRectMake(30, 340, legend.frame.size.width, legend.frame.size.width)];
    [self.lineChartContainerView addSubview:legend];
}
@end
