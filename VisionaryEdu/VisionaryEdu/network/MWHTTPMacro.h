//
//  MWHTTPMacro.h
//  MZYX
//
//  Created by meway on 14-9-29.
//  Copyright (c) 2014年 lrlz. All rights reserved.
//


//URL
#ifndef MZYX_MWHTTPMacro_h
#define MZYX_MWHTTPMacro_h


#pragma mark sskeychain

// 超级用户账户名密码
#define SUPERUSER_PASSWORD @"visionaryedu"
#define SUPERUSER_USERNAME @"dev"

#pragma mark - APPStore
#define APP_UPDATE_URL [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=960677490"]
#define APP_URL @"itms-apps://itunes.apple.com/app/id960677490"
#define APP_URL_2 @"https://itunes.apple.com/cn/app/memebox-mei-mei-xiang/id960677490"

#pragma mark - 端口

//#define VISIONARY_HOST @"http://192.168.31.128:5000"
#define VISIONARY_HOST @"http://www.visionaryedu.net/vision-api"

#define STUDENT_LIST @"/StudentType/"
#define STUDENT_SCORE @"/Grades/"
#define QUERY_STUDENT_BY_YEAR @"/StudentByYear/"
#define QUERY_STUDENT_SCHEDULE @"/StudentSchedule/"
#define QUERY_STAFF_SCHEDULE @"/StaffSchedule/"
#define LOGIN  @"/login/"
#define LOGOUT @"/auth/logout/"

#define QUERY_TESTACCOUNT @"/---TestInfoForm/"
#define QUERY_PERSONINFO @"/---PersonalInfoForm/"
#define QUERY_EDUINFO @"/---EducationInfoForm/"
#define QUERY_PROFILE @"/---ProfileDocuments/"
#define QUERY_COURSE @"/---CourseInfoForm/"
#endif
