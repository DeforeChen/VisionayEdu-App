//
//  SingleGradeView.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/3.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "SingleGradeView.h"
#import "JYRadarChart.h"
#import "UIColor+expanded.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface SingleGradeView()
@property (weak, nonatomic) IBOutlet UILabel *gradeDateLB;
@property (weak, nonatomic) IBOutlet UILabel *gradePlaceLB;
@property (weak, nonatomic) IBOutlet UIButton *checkCommentsBtn;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *gradeChartView;

@property (strong,nonatomic) JYRadarChart *radarChart;
@property (copy,nonatomic) checkDetail checkBlk;
@end

@implementation SingleGradeView
+(instancetype)initMyViewWithGradeModel:(id<scoreModelProtocol>)gradeModel PageIndex:(NSInteger)page Height:(CGFloat)height checkDetailBlk:(checkDetail)checkDetailBlk {
    SingleGradeView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    view.frame = CGRectMake(page*WIDTH, 0, WIDTH, height);
    view.gradeDateLB.text = gradeModel.date;
    view.gradePlaceLB.text = gradeModel.place;
    view.checkBlk = checkDetailBlk;
    [view configUIWithModel:gradeModel];
    return view;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [UIColor setShadowEffectWithUIView:self.containerView];
    self.containerView.layer.cornerRadius = 4.0;
    self.gradeChartView.layer.cornerRadius = 4.0;
    
    self.checkCommentsBtn.layer.borderColor = [UIColor colorWithHexString:@"#B3B5BF"].CGColor;
    self.checkCommentsBtn.layer.cornerRadius = 10.0;
    self.checkCommentsBtn.layer.borderWidth = 1.f;
}


/**
 根据传入的model，生成图表。其中几种图表不包含五维图，则用基本的字段展示

 @param gradeModel 单项成绩的模型
 */
-(void)configUIWithModel:(id<scoreModelProtocol>)gradeModel {
    // 可以生成五维图的模型, SAT,托福，IELTS，ACT
    if ([gradeModel respondsToSelector:@selector(fetchSingleGradeInfoFromBlk:)]) {
        self.radarChart = [[JYRadarChart alloc] initWithFrame:[self fetchRadarAreaRect]];
        [gradeModel fetchSingleGradeInfoFromBlk:^(NSArray *gettingGrade, NSArray *possibleGrade, NSArray *gradeName, NSInteger step) {
            self.radarChart.dataSeries = @[gettingGrade,possibleGrade];
            self.radarChart.attributes = gradeName;
            self.radarChart.maxValue   = [possibleGrade[0] floatValue];
            self.radarChart.steps      = step;
            NSString *titelA = [NSString stringWithFormat:@"单科满分%@",possibleGrade[0]];
            [self.radarChart setTitles:@[@"本次考试得分",titelA]];
        }];

        self.radarChart.showLegend   = YES;
        self.radarChart.showAxes     = YES;
        self.radarChart.showStepText = YES;
        self.radarChart.fillArea     = YES;
        self.radarChart.colorOpacity = 0.5;
        
        self.radarChart.r = [self fetchRadarChartRadius];
        [self.radarChart setColors:@[[UIColor colorWithHexString:@"#3FC6A0"],[UIColor colorWithHexString:@"#EEEEEE"]]];
        [self.gradeChartView addSubview:self.radarChart];
    }
    
    // 不可生成五维图的模型，AP,GPA,CUSTOM,SAT2
    if ([gradeModel respondsToSelector:@selector(fetchSingleGradeInfoDict)]) {
        
    }
}

- (IBAction)checkDetail:(UIButton *)sender {
    self.checkBlk();
}


-(CGRect)fetchRadarAreaRect {
    CGRect rect ;
    if (WIDTH == 375) {
        rect = CGRectMake(0, 0, 298, 298);
    } else if(WIDTH == 320) {
        rect = CGRectMake(0, 0, 230, 230);
    } else {
        rect = CGRectMake(0, 0, 345, 345);
    }
    return rect;
}

-(CGFloat)fetchRadarChartRadius {
    CGFloat radius ;
    if (WIDTH == 375) {
        radius = 90;
    } else if(WIDTH == 320) {
        radius = 65;
    } else {
        radius = 110;
    }
    return radius;
}
@end
