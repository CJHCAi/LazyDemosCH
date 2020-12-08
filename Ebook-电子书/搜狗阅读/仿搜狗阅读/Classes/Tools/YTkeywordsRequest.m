//
//  YTkeywordsRequest.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/4.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTkeywordsRequest.h"
#
@implementation YTkeywordsRequest

- (void)Requestkeywords:(NSString *)urlStr param:(NSDictionary *)param valueKey:(NSString *)valueKey{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET :urlStr
       parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              _keywordsArr = [YTsearchKeyWords mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:valueKey]];
       
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
              
          }];

}
@end
