//
//  NK_GladlyLookTitleView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NK_GladlyLookTitleView : UIView
@property (nonatomic,weak) id<HK_GladlyLookLeftDelegate>leftdelegate;
@property (nonatomic,weak) id<HK_GladlyLookRightDelegate>rightdelegate;
@property (nonatomic,weak) id<HK_GladlyLookSeachDelegate>seachdelegate;
@end
