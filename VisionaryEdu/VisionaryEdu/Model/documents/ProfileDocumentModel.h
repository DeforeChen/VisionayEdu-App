//
//  ProfileDocumentModel.h
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student_username :NSObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , assign) BOOL              undergrad;
@property (nonatomic , copy) NSString              * gender;
@property (nonatomic , copy) NSString              * registration_date;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , assign) BOOL              hs_guard;
@property (nonatomic , copy) NSString              * full_name;
@property (nonatomic , assign) NSInteger              user_class;
@end

@interface Profile_Results :NSObject
@property (nonatomic , copy) NSString              * student_comment;
@property (nonatomic , strong) Student_username              * student_username;
@property (nonatomic , assign) NSInteger              document_type;
@property (nonatomic , copy) NSString              * document_file;
@property (nonatomic , copy) NSString              * upload_date;
@property (nonatomic , copy) NSString              * staff_comment;

@end

@interface ProfileDocumentModel :NSObject
@property (nonatomic , copy) NSString                     * previous;
@property (nonatomic , strong) NSArray<Profile_Results *> * results;
@property (nonatomic , assign) NSInteger                    count;
@property (nonatomic , copy) NSString                     * next;


/**
 生成一个字典，key为 documentType， value是对应的URL地址

 @return LUT
 */
-(NSDictionary*)fetchDocumentURL_LUT;
@end
