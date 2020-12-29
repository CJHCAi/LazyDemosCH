//
//  HKSearchMessageInfoModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKSearchMessageInfoModel : NSObject
@property (nonatomic, strong)RCSearchConversationResult *rcModel;
@property (nonatomic, copy)NSString *searchText;
@property(nonatomic, assign) int count;
@end
