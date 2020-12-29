//
//  HKLEFriendSearchViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LEFriendSearchModel;
@interface HKLEFriendSearchViewModel : NSObject
+(void)leFriendSearch:(NSDictionary*)dict success:(void (^)( NSMutableArray* array))success;
@end
