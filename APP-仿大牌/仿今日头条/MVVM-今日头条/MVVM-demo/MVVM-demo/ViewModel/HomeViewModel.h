//
//  HomeViewModel.h
//  MVVM-demo
//
//  Created by shen_gh on 16/4/12.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

//处理网络获取的数据
- (void)handleDataWithSuccess:(void (^)(NSArray *arr))success
                      failure:(void(^)(NSError *error))failure;

@end
