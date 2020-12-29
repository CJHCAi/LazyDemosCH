//
//  HKPurchaseQuantityCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKPurchaseQuantityCollectionViewCellDelegate <NSObject>

@optional
-(void)updataNum:(int)num;

@end
@interface HKPurchaseQuantityCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) id<HKPurchaseQuantityCollectionViewCellDelegate> delegate;
@end
