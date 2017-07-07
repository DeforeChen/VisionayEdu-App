//
//  FamilyInfoModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/7.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Fahter : NSObject
@property (nonatomic , copy) NSString  * father_work_year;
@property (nonatomic , copy) NSString  * father_address;
@property (nonatomic , copy) NSString  * father_edu_degree;
@property (nonatomic , copy) NSString  * father_email;
@property (nonatomic , copy) NSString  * father_edu_year;
@property (nonatomic , copy) NSString  * father_name;
@property (nonatomic , copy) NSString  * father_birthday;
@property (nonatomic , copy) NSString  * father_work_company;
@property (nonatomic , copy) NSString  * father_workphone;
@property (nonatomic , copy) NSString  * father_cellphone;
@property (nonatomic , copy) NSString  * father_work_position;
@property (nonatomic , copy) NSString  * father_edu_school;
@end

@interface Mother : NSObject
@property (nonatomic , copy) NSString  * mother_workphone;
@property (nonatomic , copy) NSString  * mother_cellphone;
@property (nonatomic , copy) NSString  * mother_address;
@property (nonatomic , copy) NSString  * mother_edu_school;
@property (nonatomic , copy) NSString  * mother_work_year;
@property (nonatomic , copy) NSString  * mother_edu_year;
@property (nonatomic , copy) NSString  * mother_name;
@property (nonatomic , copy) NSString  * mother_birthday;
@property (nonatomic , copy) NSString  * mother_work_position;
@property (nonatomic , copy) NSString  * mother_email;
@property (nonatomic , copy) NSString  * mother_edu_degree;
@property (nonatomic , copy) NSString  * mother_work_company;
@end

@interface Sibling : NSObject
@property (nonatomic , copy) NSString   *name;
@property (nonatomic , copy) NSString   *gender;
@property (nonatomic , copy) NSString   *birthday;
@property (nonatomic , copy) NSString   *relation;
@property (nonatomic , copy) NSString   *degree;
@end

typedef void(^FamilyInfo)(Fahter *fatherInfo, Mother *motherInfo, NSArray<Sibling*> *siblingArray);
@interface FamilyInfoModel :NSObject
/**
 @param response 服务端返回的JSON字符串
 @param block 获取到三个数据时候的回调
 */
+(void)initModelWithResponse:(id)response callback:(FamilyInfo)block;
@end
