//
//  config.h
//  VisonaryEdu
//
//  Created by Chen Defore on 2017/5/30.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#ifndef config_h
#define config_h

// 日志开关
#define IsLogShow 1

#if IsLogShow
    #define XLog(format, ...) NSLog((format), ##__VA_ARGS__)
#else
    #define XLog(format, ...)
#endif

#endif /* config_h */
