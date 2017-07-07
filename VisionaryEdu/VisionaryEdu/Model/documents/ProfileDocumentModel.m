//
//  ProfileDocumentModel.m
//  VisionaryEdu
//
//  Created by Chen Defore on 2017/7/6.
//  Copyright © 2017年 Chen Defore. All rights reserved.
//

#import "ProfileDocumentModel.h"

@implementation ProfileDocumentModel
+ (NSDictionary *)objectClassInArray{
    return @{@"results" : [Profile_Results class]};
}

-(NSDictionary*)fetchDocumentURL_LUT {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (Profile_Results *info in self.results) {
        [dict setObject:info.document_file forKey:[NSString stringWithFormat:@"%d",(int)info.document_type]];
    }
    return dict;
}
@end


@implementation Student_username

@end
@implementation Profile_Results

@end
