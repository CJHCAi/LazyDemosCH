//
//  NK_GladlyBuyTitleView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NK_GladlyBuyTitleView : UIView
@property (nonatomic,weak) id<HK_GladlyBuyTitleLeftDelegate>leftdelegate;
@property (nonatomic,weak) id<HK_GladlyBuyTitleRightDelegate>rightdelegate;
@property (nonatomic,weak) id<HK_GladlyBuyTitleSeachDelegate>seachdelegate;
@end
