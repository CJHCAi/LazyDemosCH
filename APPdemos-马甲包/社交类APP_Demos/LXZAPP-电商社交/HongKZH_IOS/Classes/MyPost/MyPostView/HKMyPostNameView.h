//
//  HKMyPostNameView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyPostsRespone.h"

@protocol PostNameClickDelegete <NSObject>

-(void)clickHeader:(NSString *)headImg userName:(NSString *)name uid:(NSString *)uid;

-(void)repostUserWithUid:(NSString *)uid;

@end
@interface HKMyPostNameView : UIView
@property (nonatomic, strong)HKMyPostModel *model;

@property (nonatomic, weak) id <PostNameClickDelegete>delegete;

@end
