//
//  StudentGradeViewCtrl.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/2.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentGradeViewCtrl.h"
#import "YQNumberSlideView.h"
#import "GradeTendingViewCtrl.h"
#import "config.h"
#import <MJExtension/MJExtension.h>
#import "CommentViewCtrl.h"

#import "StudentScoreInDetailsModel.h"
#import "UIColor+expanded.h"
#import "SingleGradeView.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HEIGHT self.gradeScrollView.frame.size.height
#define LEFT_BANNER_FRAME CGRectMake(0, 0, WIDTH, HEIGHT)
#define MID_BANNER_FRAME CGRectMake(WIDTH, 0, WIDTH, HEIGHT)
#define RIGHT_BANNER_FRAME CGRectMake(2*WIDTH, 0, WIDTH, HEIGHT)

@interface StudentGradeViewCtrl ()<YQNumberSlideViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) YQNumberSlideView *slideView;
@property (weak, nonatomic) IBOutlet UIPageControl *gradeViewPageCtrl;
@property (weak, nonatomic) IBOutlet UIScrollView *gradeScrollView;
@property (assign,nonatomic) BOOL isFirstRefresh;

// 下面两个值，分别对应 StudentScoreInDetailsModel 的property名和对应的值组成的数组
@property (copy,nonatomic)  NSArray         *gradeNameArray;
@property (copy,nonatomic) NSArray<NSArray<id<scoreModelProtocol>>*> *gradeInfoArray;
@property (assign,nonatomic) NSInteger      selectGradeIndex;//选中的某一类考试
@end

@implementation StudentGradeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstRefresh = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.isFirstRefresh) {
        self.isFirstRefresh = NO;
        [self refresh];
    }
    
    //    [self configGradeOptionViewUI];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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

#pragma mark Congif UI
- (void)configGradeOptionViewUI {
    CGRect gradeOption = CGRectMake(0, 20, WIDTH, 44);
    self.slideView = [[YQNumberSlideView alloc] initWithFrame:gradeOption];
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
    // 移除scrollview下属的所有subview
    for (SingleGradeView *view in self.gradeScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (id<scoreModelProtocol>gradeInfoModel in gradeInfoArray) {
        // 创建N个model组成的页面，然后添加进去
        NSInteger pageIndex = [gradeInfoArray indexOfObject:gradeInfoModel];
        SingleGradeView *view = [SingleGradeView initMyViewWithGradeModel:gradeInfoModel PageIndex:pageIndex Height:self.gradeScrollView.frame.size.height checkDetailBlk:^{
            CommentViewCtrl *vc = [CommentViewCtrl initMyViewCtrlWithStaffComment:gradeInfoModel.staff_comment
                                                                   StudentComment:gradeInfoModel.student_comment
                                                                             flag:gradeInfoModel.color];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [self.gradeScrollView addSubview:view];
    }
    
    [self.gradeScrollView setContentSize:CGSizeMake(gradeInfoArray.count * WIDTH, HEIGHT)];
    self.gradeViewPageCtrl.numberOfPages = gradeInfoArray.count;
}


#pragma mark Private Methods
-(void)refresh {
    NSDictionary *paramDict = @{@"username":@"student_2"};//[StudentInstance shareInstance].student_username
    [SysTool showLoadingHUDWithMsg:@"成绩加载中..." duration:0];
    [[SYHttpTool sharedInstance] getReqWithURL:STUDENT_SCORE token:[LoginInfoModel fetchTokenFromSandbox] params:paramDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            StudentScoreInDetailsModel *model = [StudentScoreInDetailsModel mj_objectWithKeyValues:responseObject];
            self.gradeNameArray = [[model fetchCorrespondingScoreDict] allKeys];
            self.gradeInfoArray = [[model fetchCorrespondingScoreDict] allValues];
            // 获取模型成功后，去更新选项条
            [self configGradeOptionViewUI];
            //            [self initChartView];
            XLog(@"当前的成绩项目 = %@,成绩明细 = %@",self.gradeNameArray[self.selectGradeIndex],self.gradeInfoArray[self.selectGradeIndex]);
            [self updateGradeViewScrollContainerWithGradeInfos:self.gradeInfoArray[self.selectGradeIndex]];
            NSLog(@"score keys = %@",self.gradeNameArray);
            
        } else {
            [SysTool showErrorWithMsg:msg duration:1];
        }
    }];
}

- (IBAction)checkGradeTending:(UIButton *)sender {
    GradeTendingViewCtrl *vc = [GradeTendingViewCtrl initMyViewWithGradeNameArray:self.gradeNameArray GradeInfoArray:self.gradeInfoArray];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark YQNumberSlideViewDelegate
-(void)YQSlideViewDidChangeIndex:(int)count {
    self.selectGradeIndex = count;
    [self updateGradeViewScrollContainerWithGradeInfos:self.gradeInfoArray[self.selectGradeIndex]];
}

#pragma ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.gradeViewPageCtrl.currentPage = scrollView.contentOffset.x/WIDTH;
}
@end
