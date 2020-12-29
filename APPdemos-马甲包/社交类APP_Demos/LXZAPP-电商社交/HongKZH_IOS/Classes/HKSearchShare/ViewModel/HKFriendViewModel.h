//
//  HKFriendViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKFriendRespond,HKCliceListRespondeModel;
@interface HKFriendViewModel : NSObject
+(void)loadFriendList:(NSDictionary*)dict success:(void (^)( HKFriendRespond* responde))success;
+(void)loadClicleList:(NSDictionary*)dict success:(void (^)( HKCliceListRespondeModel* responde))success;
+(void)shareForwardPost:(NSDictionary*)dict success:(void (^)( HKBaseResponeModel* responde))success;
@end
