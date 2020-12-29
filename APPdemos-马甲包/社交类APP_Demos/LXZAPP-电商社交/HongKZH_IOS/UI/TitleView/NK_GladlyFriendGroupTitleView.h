//
//  NK_GladlyFriendGroupTitleView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickGroupBackBlock) ();
@interface NK_GladlyFriendGroupTitleView : UIView
@property(nonatomic,strong)ClickGroupBackBlock clickGroupBackBlock;
@property (nonatomic,weak) id<HK_GladlyBuyTitleLeftDelegate>leftdelegate;
@property (nonatomic,weak) id<HK_GladlyBuyTitleRightDelegate>rightdelegate;
@property (nonatomic,weak) id<HK_GladlyBuyTitleSeachDelegate>seachdelegate;
@end

