//
//  LoginInfoModel.h
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/20.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfoModel : NSObject<NSCoding>
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * full_name;
@property (nonatomic , assign) NSUInteger            retCode;
@property (nonatomic , copy) NSString              * token;


/**
 存储登录信息到沙盒
 @param username 登录成功时保存用户名
 */
-(void)saveLoginInfoIntoSandbox:(NSString*)username;


/**
 清空登录信息（登出时用）
 */
+(void)clearLoginInfoInSandbox ;

/**
 从沙盒中获取到 令牌
 @return 令牌
 */
+(NSString*)fetchTokenFromSandbox;


/**
 从沙盒中获取 用户类别
 @return 用户类别
 */
+(NSString*)fetchUserTypeFromSandbox;


/**
 从沙盒中获取用户名
 @return 用户名
 */
+(NSString*)fetchAccountUsername ;
/**
 判断当前是否登录
 @return 是否登录
 */
+(BOOL)isLogin;
@end
