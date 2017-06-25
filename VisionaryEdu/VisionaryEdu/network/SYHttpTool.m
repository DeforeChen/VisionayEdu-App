//
//  SYHttpTool.m
//  RideHappy
//
//  Created by administrator on 16/5/17.
//  Copyright © 2016年 administrator. All rights reserved.
//

#import "SYHttpTool.h"
#import <AFNetworking/AFNetworking.h>

#define WEEK_SELF __weak typeof(self) weekSelf = self ;
#define SELFCLASS_NAME SYHttpTool
#define SELFCLASS_NAME_STR @"SYHttpTool"

#define TimeOut 15.0

static SYHttpTool *center = nil;//定义一个全局的静态变量，满足静态分析器的要求

@implementation SYHttpTool
+ (instancetype)sharedInstance {
    static dispatch_once_t predicate;
    //线程安全
    dispatch_once(&predicate, ^{
        center = (SELFCLASS_NAME *)SELFCLASS_NAME_STR;
        center = [[SELFCLASS_NAME alloc] init];
    });
    
    // 防止子类使用
    NSString *classString = NSStringFromClass([self class]);
    if ([classString isEqualToString: SELFCLASS_NAME_STR] == NO)
        NSParameterAssert(nil);
    
    return center;
}

- (instancetype)init {
    NSString *string = (NSString *)center;
    if ([string isKindOfClass:[NSString class]] == YES && [string isEqualToString:SELFCLASS_NAME_STR]) {
        self = [super init];
        if (self) {
            // 防止子类使用
            NSString *classString = NSStringFromClass([self class]);
            if ([classString isEqualToString:SELFCLASS_NAME_STR] == NO)
                NSParameterAssert(nil);
        }
        return self;
        
    } else
        return nil;
}

#pragma mark 方法
-(void)getReqWithURL:(NSString *)url
               token:(NSString *)token
              params:(NSDictionary *)paramDict
   completionHandler:(HTTPCompletion)completionBlock {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",VISIONARY_HOST,url];
    [self loadWithURL:requestURL
               method:GET
               params:paramDict
    completionHandler:completionBlock
                token:token];
}

-(void)fetchTokenWithUserName:(NSString *)name password:(NSString *)pwd completionHandler:(HTTPCompletion)completionBlock {
    NSDictionary *paramsDict = @{@"username":name,
                                 @"password":pwd
                                 };
    NSString *loginURL = [NSString stringWithFormat:@"%@%@",VISIONARY_HOST,LOGIN];
    NSLog(@"登录的URL = %@",loginURL);
    [self loadWithURL:loginURL
               method:POST
               params:paramsDict
    completionHandler:completionBlock token:nil];
}
#pragma mark 私有方法
- (void)loadWithURL:(NSString *)url
             method:(HTTP_TYPE)methodType
             params:(NSDictionary *)params
  completionHandler:(HTTPCompletion)completionBlock
              token:(NSString*)token {
    NSLog(@"上送的URL = %@",url);
    NSLog(@"上送的参数 = %@",params);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (token != nil) {
        NSString *MyToken = [NSString stringWithFormat:@"Token %@",token];
        [manager.requestSerializer setValue:MyToken
                         forHTTPHeaderField:@"Authorization"];
    }
    [manager.requestSerializer setTimeoutInterval:TimeOut];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)" forHTTPHeaderField:@"user-agent"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    WEEK_SELF
    if (methodType == GET) {
        NSLog(@"上送前的URL = %@",url);
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [weekSelf handleResponseObject:responseObject completionHandler:completionBlock url:url];
        }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if (completionBlock) {
                     completionBlock(NO, [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *) task.response).statusCode], error);
                 }
             }];
    } else {
        [manager POST:url parameters:params
             progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                 [weekSelf handleResponseObject:responseObject completionHandler:completionBlock url:url];
             }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  if (completionBlock)
                      completionBlock(NO, [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *) task.response).statusCode], error);
              }];
    }
}

- (void)handleResponseObject:(id)responseObject completionHandler:(HTTPCompletion)completionBlock url:(NSString *)url {
    completionBlock(YES, nil, responseObject);
}
@end
