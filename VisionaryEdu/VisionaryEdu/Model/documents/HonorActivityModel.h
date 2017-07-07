//
//  HonorActivityModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Honor;
@class Activity;
typedef void(^HornorActivityInfo)(NSArray<Honor*> *honorArray, NSArray<Activity*> *activityArray);


@interface Honor : NSObject
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *rank;
@property (copy,nonatomic) NSString *date;
@property (copy,nonatomic) NSString *place;
@property (copy,nonatomic) NSString *organization;
@property (copy,nonatomic) NSString *supplement;
@end

@interface Activity : NSObject
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *position;
@property (copy,nonatomic) NSString *time_period;
@property (copy,nonatomic) NSString *place;
@property (copy,nonatomic) NSString *actDescription;
@property (copy,nonatomic) NSString *accomplishment;
@end

@interface HonorActivityModel : NSObject
/**
 @param response 服务端返回的JSON字符串
 @param block 获取到两个数组时候的回调
 */
+(void)initModelWithResponse:(id)response callback:(HornorActivityInfo)block;
@end
