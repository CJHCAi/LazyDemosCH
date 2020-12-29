//
//  HKLeBuyShoppingCartTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "getCartList.h"
#import "HKConfirmationOfOrderData.h"
@protocol HKLeBuyShoppingCartTableViewCellDelegate <NSObject>

@optional
-(void)selectCartListDataProducts:(getCartListDataProducts*)model isSelect:(BOOL)isSelect indexPath:(NSIndexPath*)indexPath;
-(void)numChange:(NSInteger)change products:(getCartListDataProducts*)model;
-(void)translateList:(getCartListDataProducts*)model;
-(void)selectCoinWithIsCoin:(BOOL)isCoin getCartListDataProducts:(getCartListDataProducts*)model;
-(void)gotoInfo:(getCartListDataProducts*)model;
@end
@interface HKLeBuyShoppingCartTableViewCell : BaseTableViewCell
@property (nonatomic, strong)getCartListDataProducts *model;
@property (nonatomic,weak) id<HKLeBuyShoppingCartTableViewCellDelegate> delegate;
@property (nonatomic,weak) NSIndexPath *indexPath;
@property (nonatomic, strong)HKConfirmationOfOrderData *orderData;
@property (nonatomic,assign) BOOL isHideLeft;
@end
