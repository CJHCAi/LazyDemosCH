//
//  HKDetailInfoCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKDetailInfoCollectionViewCellDelagete <NSObject>

@optional
-(void)clickClose;

@end
@class CommodityDetailsRespone;
@interface HKDetailInfoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)CommodityDetailsRespone *respone;
@property (nonatomic,weak) id<HKDetailInfoCollectionViewCellDelagete> delegate;
@end
