//
//  ViewController.m
//  yindaoye
//
//  Created by 李玉峰 on 2017/7/14.
//  Copyright © 2017年 李玉峰. All rights reserved.
//

#import "GuideViewCtrl.h"
#import "HomeNavViewCtrl.h"
#import "SysTool.h"
@interface GuideViewCtrl ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl *pageControl;

@end
#define IMAGECOUNT 3

@implementation GuideViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self createNav];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)createNav{
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置边缘不弹跳
    sv.bounces = NO;
    //整页滚动
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    sv.alwaysBounceVertical = NO;
    
    //加入多个子视图(ImageView)
    for(NSInteger i=0; i<IMAGECOUNT; i++){
        NSString *imgName = [NSString stringWithFormat:@"预览图%ld", i+1];
        UIImage *image = [UIImage imageNamed:imgName];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGRect frame = CGRectZero;
        frame.origin.x = i * sv.frame.size.width;
        frame.size = sv.frame.size;
        imageView.frame = frame;
        [sv addSubview:imageView];
        
        if(i==IMAGECOUNT-1){
            //开启图片的用户点击功能
            imageView.userInteractionEnabled = YES;
            //加个按钮
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake((imageView.frame.size.width-150)/2, imageView.frame.size.height*0.8, 150, 40);
            button.backgroundColor = [UIColor orangeColor];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            button.layer.cornerRadius = 6.0f;
            button.clipsToBounds = YES;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [imageView addSubview:button];
            [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    sv.contentSize = CGSizeMake(IMAGECOUNT * sv.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.view addSubview:sv];
    
    //加入页面指示控件PageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    //设置frame
    pageControl.frame = CGRectMake(0, 115, self.view.frame.size.width, 20);
    //分页面的数量
    pageControl.numberOfPages = IMAGECOUNT;
    //设置小圆点渲染颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置当前选中小圆点的渲染颜色
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    //关闭用户点击交互
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    
    sv.delegate = self;
}
- (void)enter {
    HomeNavViewCtrl *svc =[HomeNavViewCtrl initMyView];
    [UIView animateWithDuration:1.0f animations:^{
        self.view.backgroundColor = [UIColor redColor];
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.view.window.rootViewController = svc;
        [SysTool markLauchAsNotFirstLaunch];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if(offset.x<=0){
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
    NSUInteger index = round(offset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
