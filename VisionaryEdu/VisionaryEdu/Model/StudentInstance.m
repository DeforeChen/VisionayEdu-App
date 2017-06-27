//
//  StudentInstance.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/6/25.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "StudentInstance.h"

#define SELFCLASS_NAME StudentInstance
#define SELFCLASS_NAME_STR @"StudentInstance"

static StudentInstance *center = nil;//定义一个全局的静态变量，满足静态分析器的要求

@implementation StudentInstance

+ (instancetype)shareInstance {
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

@end
