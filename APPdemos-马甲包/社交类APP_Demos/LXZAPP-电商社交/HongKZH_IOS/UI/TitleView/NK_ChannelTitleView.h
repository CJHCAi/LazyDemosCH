//
//  NK_ChannelTitleView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NK_ChannelTitleView : UIView
@property (nonatomic,weak) id<HK_GladlyFriendTitleLeftDelegate>leftdelegate;
@property (nonatomic,weak) id<HK_GladlyChannelTitleRightDelegate>rightdelegate;
@property (nonatomic,weak) id<HK_GladlyFriendTitleSeachDelegate>seachdelegate;

@end
