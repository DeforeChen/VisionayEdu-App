//
//  SYHttpTool.h
//  RideHappy
//
//  Created by administrator on 16/5/17.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWHTTPMacro.h"

typedef NS_ENUM(NSInteger, HTTP_TYPE) {
    POST,
    GET,
    PATCH,
    DELETE
};

typedef void(^HTTPCompletion)(BOOL success,NSString *msg,id responseObject);
@interface SYHttpTool : NSObject

/**
 *  DAO单例对象
 *
 *  @return DAO单例对象
 */
+ (instancetype)sharedInstance;


/**
 封装好的网络请求
 
 @param url URL地址
 @param token 登陆后的令牌
 @param paramDict 参数信息，以字典类型传入
 @param completionBlock 回调
 */
-(void)getReqWithURL:(NSString*)url
               token:(NSString*)token
              params:(NSDictionary*)paramDict
   completionHandler:(HTTPCompletion)completionBlock;



/**
 带有“下一页”的请求，主要为上拉刷新使用

 @param url URL
 @param token 令牌
 @param completionBlock 回调
 */
-(void)getNextPageWithEntireURL:(NSString*)url
                          token:(NSString*)token
              completionHandler:(HTTPCompletion)completionBlock;
/**
 获取登录令牌

 @param name 用户名
 @param pwd 密码
 @param jpushID 极光推送 ID
 @param completionBlock 回调函数
 */
-(void)fetchTokenWithUserName:(NSString*)name
                     password:(NSString*)pwd
              registration_id:(NSString*)jpushID
            completionHandler:(HTTPCompletion)completionBlock;

#pragma mark 上送数据 —— 增
-(void)addEventWithURL:(NSString*)url
                 token:(NSString*)token
                params:(NSDictionary*)paramDict
     completionHandler:(HTTPCompletion)completionBlock;

#pragma mark 上送数据 —— 改
-(void)patchEventWithURL:(NSString*)url
              primaryKey:(NSInteger )pk
                   token:(NSString*)token
                  params:(NSDictionary*)paramDict
       completionHandler:(HTTPCompletion)completionBlock;

@end
