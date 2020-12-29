//
//  HKLeBuyShoppingCartSectionView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "getCartList.h"
@protocol HKLeBuyShoppingCartSectionViewDelegete <NSObject>

-(void)selectCartSectionDataProducts:(getCartListData*)model isSelect:(BOOL)isSelect section:(NSInteger)section;

@end
@interface HKLeBuyShoppingCartSectionView : UIView
@property (nonatomic, strong)getCartListData *model;
@property(nonatomic, assign) NSInteger section;;
@property (nonatomic,weak) id<HKLeBuyShoppingCartSectionViewDelegete> delegate;
@property(nonatomic, assign) BOOL isHideLine;
@end
