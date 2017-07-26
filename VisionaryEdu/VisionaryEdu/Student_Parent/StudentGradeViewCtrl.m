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
#import "CreateTestScheduleViewCtrl.h"
#import "StudentScoreInDetailsModel.h"
#import "UIColor+expanded.h"
#import "SingleGradeView.h"
#import "TabBarManagerViewCtrl.h"
#import "FutureTestScheduleModel.h"
#import "UnrecordGradeViewCtrl.h"
#import "GradeDetailsViewCtrl.h"

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
@property (weak, nonatomic) IBOutlet UIButton *checkGradeTendingBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIView *unrecordTestNoticeView;
@property (weak, nonatomic) IBOutlet UIButton *addEventBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (weak, nonatomic) IBOutlet UIView *placeHolderView;

@property (copy,nonatomic) NSArray<FutureTestScheduleModel*> *unrecordTestArray;

// 下面两个值，分别对应 StudentScoreInDetailsModel 的property名和对应的值组成的数组
@property (copy,nonatomic)  NSArray         *gradeNameArray;
@property (copy,nonatomic) NSArray<NSArray<id<scoreModelProtocol>>*> *gradeInfoArray;
@property (assign,nonatomic) NSInteger      selectGradeIndex;//选中的某一类考试
@end

@implementation StudentGradeViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIColor setShadowEffectWithUIView:self.placeHolderView];
    if ([[LoginInfoModel fetchUserTypeFromSandbox] isEqualToString:Staff_UserType]) {
        self.addEventBtn.hidden = YES;
        self.tipLB.text = @"该学生还未有考试日程";
    } else {
        self.addEventBtn.layer.borderColor = [UIColor colorWithHexString:@"#B3B5BF"].CGColor;
        self.addEventBtn.layer.cornerRadius = 50.0f;
        self.addEventBtn.layer.borderWidth  = 1.0f;
        self.addEventBtn.clipsToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    TabBarManagerViewCtrl *vc = (TabBarManagerViewCtrl*)self.tabBarController;
    vc.customTabbar.hidden = NO;
    [self refresh];
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
            GradeDetailsViewCtrl *vc = [GradeDetailsViewCtrl initMyViewCtrlWithWhetherUnderGradeCheckMode:YES];
            
            FutureTests *gradeModel = [FutureTests new];
            gradeModel.student_comment = gradeInfoModel.test_schedule_info.student_comment;
            gradeModel.time = gradeInfoModel.test_schedule_info.time;
            gradeModel.staff_comment = gradeInfoModel.test_schedule_info.staff_comment;
            //gradeModel.test_info_pk 不需要指定，因为其实已经录入了
            gradeModel.details = gradeInfoModel.test_schedule_info.details;
            gradeModel.date = gradeInfoModel.test_schedule_info.date;
            gradeModel.test_type = gradeInfoModel.test_schedule_info.test_type;
            gradeModel.whether_record_score = gradeInfoModel.test_schedule_info.whether_record_score;
            gradeModel.place = gradeInfoModel.test_schedule_info.place;
            gradeModel.pk = gradeInfoModel.test_schedule;
            
            vc.gradeModel = gradeModel;
            vc.gradeDict  = [self fetchGradeDictWithResponseInfo:gradeInfoModel];
            
//            CommentViewCtrl *vc = [CommentViewCtrl initMyViewCtrlWithStaffComment:gradeInfoModel.test_schedule_info.staff_comment
//                                                                   StudentComment:gradeInfoModel.test_schedule_info.student_comment
//                                                                             flag:gradeInfoModel.color];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        [self.gradeScrollView addSubview:view];
    }
    
    [self.gradeScrollView setContentSize:CGSizeMake(gradeInfoArray.count * WIDTH, HEIGHT)];
    self.gradeViewPageCtrl.numberOfPages = gradeInfoArray.count;
}

-(NSMutableDictionary*)fetchGradeDictWithResponseInfo:(id<scoreModelProtocol>) model{
    NSMutableDictionary *gradeDict = [NSMutableDictionary new];
    TestType type = model.test_schedule_info.test_type;
    switch (type) {
        case ToeflType: {
            Toefl *toefl = [Toefl mj_objectWithKeyValues:model];
            gradeDict[@"A"] = [NSString stringWithFormat:@"%d",(int)toefl.listening_score] ;
            gradeDict[@"B"] = [NSString stringWithFormat:@"%d",(int)toefl.speaking_score ] ;
            gradeDict[@"C"] = [NSString stringWithFormat:@"%d",(int)toefl.reading_score  ] ;
            gradeDict[@"D"] = [NSString stringWithFormat:@"%d",(int)toefl.writing_score  ] ;
            gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)toefl.total_score  ] ;
        }
            break;
        case ieltsType:{
            Ielts *ielts = [Ielts mj_objectWithKeyValues:model];
            gradeDict[@"A"] = ielts.listening_score ;
            gradeDict[@"B"] = ielts.speaking_score  ;
            gradeDict[@"C"] = ielts.reading_score   ;
            gradeDict[@"D"] = ielts.writing_score   ;
            gradeDict[@"total"] = (NSString*)ielts.total_score;
        }
            break;
        case SatType: {
            Sat *sat = [Sat mj_objectWithKeyValues:model];
            gradeDict[@"A"]= [NSString stringWithFormat:@"%d",(int)sat.reading_writing_score];//sat.reading_writing_score ;
            gradeDict[@"B"]= [NSString stringWithFormat:@"%d",(int)sat.math_score];//sat.math_score            ;
            gradeDict[@"C"]= [NSString stringWithFormat:@"%d",(int)sat.essay_score];//sat.essay_score           ;
            gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)sat.total_score] ;
        }
            break;
        case ActType: {
            Act *act = [Act mj_objectWithKeyValues:model];
            gradeDict[@"A"]= [NSString stringWithFormat:@"%d",(int)act.english_score];
            gradeDict[@"B"]= [NSString stringWithFormat:@"%d",(int)act.science_score];
            gradeDict[@"C"]= [NSString stringWithFormat:@"%d",(int)act.reading_score];
            gradeDict[@"D"]= [NSString stringWithFormat:@"%d",(int)act.math_score];
            gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)act.total_score];
        }
            break;
        case Sat2Type: {
            Sat2 *sat2 = [Sat2 mj_objectWithKeyValues:model];
            gradeDict[@"A"] = sat2.subject;
            gradeDict[@"total"] = [NSString stringWithFormat:@"%d",(int)sat2.total_score];
        }
            break;
        case APType: {
            Ap *ap = [Ap mj_objectWithKeyValues:model];
            gradeDict[@"A"] = ap.subject;
            gradeDict[@"total"] =  [NSString stringWithFormat:@"%d",(int)ap.total_score];
        }
            break;
    }
    return gradeDict;
}


#pragma mark UserInteractions
- (IBAction)refreshData:(UIButton *)sender {
    [self refresh];
}

- (IBAction)createFutureTestSchedule:(UIButton *)sender {
    CreateTestScheduleViewCtrl *vc = [CreateTestScheduleViewCtrl initMyViewCtrl];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Private Methods
-(void)refresh {
    // 1.查询未录入的成绩信息
    [SysTool showLoadingHUDWithMsg:@"查询未录入成绩中..." duration:0];
    NSDictionary *reqDict = @{@"username":[StudentInstance shareInstance].student_username,
                              @"whether_record_score":@NO};
    [[SYHttpTool sharedInstance] getReqWithURL:UPLOAD_FUTURETEST token:[LoginInfoModel fetchTokenFromSandbox] params:reqDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
        [SysTool dismissHUD];
        if (success) {
            id result = [responseObject objectForKey:@"results"];
            // 更新本地数据
            self.unrecordTestArray = [FutureTestScheduleModel mj_objectArrayWithKeyValuesArray:result];
            if (self.unrecordTestArray.count == 0)
                self.unrecordTestNoticeView.hidden = YES;
            
            NSDictionary *paramDict = @{@"username":[StudentInstance shareInstance].student_username};//
            [SysTool showLoadingHUDWithMsg:@"成绩加载中..." duration:0];
            [[SYHttpTool sharedInstance] getReqWithURL:STUDENT_SCORE token:[LoginInfoModel fetchTokenFromSandbox] params:paramDict completionHandler:^(BOOL success, NSString *msg, id responseObject) {
                [SysTool dismissHUD];
                if (success) {
                    StudentScoreInDetailsModel *model = [StudentScoreInDetailsModel mj_objectWithKeyValues:responseObject];
                    self.gradeNameArray = [[model fetchCorrespondingScoreDict] allKeys];
                    self.gradeInfoArray = [[model fetchCorrespondingScoreDict] allValues];
                    if (self.gradeNameArray.count == 0 && self.gradeInfoArray.count == 0) {
                        self.gradeViewPageCtrl.hidden = YES;
                        self.checkGradeTendingBtn.hidden = YES;
                        self.refreshBtn.hidden           = YES;
                        self.gradeScrollView.hidden      = YES;
                        return;
                    }
                    
                    self.gradeScrollView.hidden      = NO;
                    self.gradeViewPageCtrl.hidden = NO;
                    self.checkGradeTendingBtn.hidden = NO;
                    self.refreshBtn.hidden           = NO;
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
        } else
            [SysTool showErrorWithMsg:msg duration:1];
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[UnrecordGradeViewCtrl class]]) {
        UnrecordGradeViewCtrl *vc = destVC;
        vc.unrecordModelArray = self.unrecordTestArray;
    }
}
@end
