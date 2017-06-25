//
//  LoginInfoModel.m
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/6/20.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "LoginInfoModel.h"

@implementation LoginInfoModel
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.token     = [aDecoder decodeObjectForKey:@"token"];
        self.usertype  = [aDecoder decodeObjectForKey:@"usertype"];
        self.full_name = [aDecoder decodeObjectForKey:@"full_name"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:  self.token     forKey:@"token"];
    [aCoder encodeObject:  self.usertype  forKey:@"usertype"];
    [aCoder encodeObject:  self.full_name forKey:@"full_name"];
}

#pragma mark methods
-(void)saveLoginInfoIntoSandbox:(NSString*)username {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"loginInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)fetchTokenFromSandbox {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"loginInfo"];
    if (data) {
        LoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model.token;
    }
    return nil;
}

+(NSString*)fetchUsername {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *data = [user objectForKey:@"username"];
    if (data)
        return data;
    return nil;
}

+(NSString *)fetchUserTypeFromSandbox {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"loginInfo"];
    if (data) {
        LoginInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model.usertype;
    }
    return nil;
}

+(BOOL)isLogin {
    // 6ea7b2af221fa9811de189b02d699577e0076445
    if ([LoginInfoModel fetchTokenFromSandbox] == nil) {
        return NO;
    } else
        return YES;
}
@end
