//
//  DocumentViewCtrl.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentViewCtrl : UITableViewController

@end


typedef void(^ForwardWebBlk)(NSString *url);
@interface DocumentCell : UITableViewCell

/**
 初始化并设定点击按钮的代理回调

 @param urlBlk 点击后，通知DocumentViewCtrl跳转的URL地址
 @param tableview Tableview
 @param lut URL查询表
 @return cell
 */
+(instancetype)initMyCellWithCallBack:(ForwardWebBlk)urlBlk tableview:(UITableView *)tableview documentURL_LUT:(NSDictionary*)lut ;
@end
