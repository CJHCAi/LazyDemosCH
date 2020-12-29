//
//  HKPublishViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
@class HK_UserProductList;
@interface HKPublishViewModel : HKBaseViewModel
+(void)uploadPublish:(NSString*)urlStr callback:(HJHttpRequest)callback;
+(void)getProductList:(NSDictionary*)dict success:(void (^)( HK_UserProductList* responde))success;
@end
