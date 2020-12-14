//
//  YTkeywordsRequest.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/4.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "YTsearchKeyWords.h"


@interface YTkeywordsRequest : NSObject

@property (nonatomic,strong) NSArray *keywordsArr;

- (void)Requestkeywords:(NSString *)urlStr param:(NSDictionary *)param valueKey:(NSString *)valueKey;
@end
