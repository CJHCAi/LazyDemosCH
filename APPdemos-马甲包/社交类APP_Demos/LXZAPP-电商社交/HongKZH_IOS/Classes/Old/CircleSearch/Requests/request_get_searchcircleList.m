//
//  request_get_searchcircleList.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "request_get_searchcircleList.h"

@implementation request_get_searchcircleList
//-(void)prepareRequest{
//    
//    NSString *url = [Host stringByAppendingString:get_searchcircleList];
//    
//    NSMutableData* orderdata = [[NSMutableData alloc] initWithData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
//    NSString* jsondata = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.dicParameters  options:0 error:nil] encoding:NSUTF8StringEncoding];
//    
//    NSData* body = [[[jsondata stringByReplacingOccurrencesOfString:@"&" withString:@""] stringByReplacingOccurrencesOfString:@"?" withString:@""]  dataUsingEncoding:NSUTF8StringEncoding];
//    [orderdata appendData:body];
//    [self buildPostRequest:url body:self.dicParameters];
//}
//
//-(void)processString:(NSString *)str{
//    NSLog(@"processString:%@", str);
//}
//
//-(void)processDictionary:(id)dictionary{
//    HKSearchcircleListModel *circleListModel = [HKSearchcircleListModel mj_objectWithKeyValues:dictionary];
//    [ViewModelLocator sharedModelLocator].circleListModel = circleListModel;
//}
//
//-(void)processFile:(NSString *)filePath{
//    NSLog(@"processFile:%@", filePath);
//}
@end
