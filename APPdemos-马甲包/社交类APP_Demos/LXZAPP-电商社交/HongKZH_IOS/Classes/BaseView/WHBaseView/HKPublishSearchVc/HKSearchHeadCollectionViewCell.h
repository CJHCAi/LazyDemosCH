//
//  HKSearchHeadCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSearchHeadCollectionViewCellDelegate <NSObject>

@optional
-(void)toEmptySearchHistory;
@end
@interface HKSearchHeadCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) int type;
@property (nonatomic,weak) id<HKSearchHeadCollectionViewCellDelegate> delegate;
@end
