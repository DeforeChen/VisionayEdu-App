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
    GET
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
 登出操作(POST请求)

 @param url 登出URL
 @param token 令牌
 @param completionBlock 回调函数
 */
-(void)logoutRequest:(NSString*)url
               token:(NSString*)token
   completionHandler:(HTTPCompletion)completionBlock;

/**
 获取登录令牌

 @param name 用户名
 @param pwd 密码
 @param completionBlock 回调函数
 */
-(void)fetchTokenWithUserName:(NSString*)name password:(NSString*)pwd completionHandler:(HTTPCompletion)completionBlock;
@end
