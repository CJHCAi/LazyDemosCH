//
//  KTCommit.m
//  ZJUIKit
//
//  Created by keenteam on 2018/4/3.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "KTCommit.h"

@implementation KTCommit

-(NSArray *)pic_urls{
    if (self.img_data.length > 5) {
        NSData *jsonData = [self.img_data dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSError *error = nil;
        NSArray  *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
        
        if (jsonObject != nil && error == nil){
            _pic_urls = jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    return _pic_urls;
    
}

-(id)initWithDict:(NSDictionary *)dict{
    if (self == [super init]) {
        self.avatar  = dict[@"avatar"];
        self.nickname = dict[@"nickname"];
        self.content = dict[@"content"];
        self.img_data = dict[@"img_data"];
        self.like_id = dict[@"like_id"];
        self.like_count = dict[@"like_count"];
        self.unlike_count = dict[@"unlike_count"];
        self.add_time = dict[@"add_time"];
        self.rating = dict[@"rating"];
        
        _identifier = [self uniqueIdentifier];
    }
    return self;
}

+(instancetype)commitWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}

@end
