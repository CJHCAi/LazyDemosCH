//
//  request_get_allTags.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "request_get_allTags.h"

@implementation request_get_allTags

-(void)prepareRequest{
    
    NSString *url = [Host stringByAppendingString:get_getAllTags];
    
    NSMutableData* orderdata = [[NSMutableData alloc] initWithData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString* jsondata = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.dicParameters  options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSData* body = [[[jsondata stringByReplacingOccurrencesOfString:@"&" withString:@""] stringByReplacingOccurrencesOfString:@"?" withString:@""]  dataUsingEncoding:NSUTF8StringEncoding];
    [orderdata appendData:body];
    
    [self buildPostRequest:url body:self.dicParameters];
    
}

-(void)processString:(NSString *)str{
    DLog(@"processString:%@", str);
}

-(void)processDictionary:(id)dictionary{
//    HK_AllTags *allTags = [HK_AllTags mj_objectWithKeyValues:dictionary];
//    [ViewModelLocator sharedModelLocator].allTags = allTags;
}

@end
