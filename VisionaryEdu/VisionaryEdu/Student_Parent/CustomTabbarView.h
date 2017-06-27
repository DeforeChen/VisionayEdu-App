//
//  CustomTabbarView.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/27.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabbarView : UIView

/**
 初始化自定义的tabbar

 @param tabbarCtrl 传入tabbar控制器，以便捕获他的代理
 @return 自定义tabbar
 */
+(instancetype)initMyViewWithTabBarCtrl:(UITabBarController*)tabbarCtrl ;


/**
 设置初始载入的页面

 @param index 页面索引值
 */
-(void)setInitialPage:(NSInteger)index ;
@end
