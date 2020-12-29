//
//  HKRecommendHeadCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKSelfMedioheadRespone;
#import "CategoryTop10ListRespone.h"
@protocol HKRecommendHeadCollectionViewCellDelegate <NSObject>

@optional
-(void)selectTop3:(CategoryTop10ListModel*)top3;
@end
@interface HKRecommendHeadCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)HKSelfMedioheadRespone *respone;
@property (nonatomic,weak) id<HKRecommendHeadCollectionViewCellDelegate> delegate;
@end
