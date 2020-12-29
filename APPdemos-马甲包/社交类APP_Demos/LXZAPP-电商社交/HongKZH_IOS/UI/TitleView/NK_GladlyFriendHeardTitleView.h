//
//  NK_GladlyFriendHeardTitleView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NK_GladlyFriendHeardTitleView : UIView
@property (nonatomic,weak) id<HK_GladlyFriendTitleLeftDelegate>leftdelegate;
@property (nonatomic,weak) id<HK_GladlyFriendTitleRightDelegate>rightdelegate;
@property (nonatomic,weak) id<HK_GladlyFriendTitleSeachDelegate>seachdelegate;
@end
