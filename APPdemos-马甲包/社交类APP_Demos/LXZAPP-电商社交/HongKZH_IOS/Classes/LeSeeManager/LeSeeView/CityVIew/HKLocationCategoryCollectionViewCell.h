//
//  HKLocationCategoryCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLocationCategoryCollectionViewCellDelegate <NSObject>

@optional
-(void)categoryWithTag:(NSInteger)tag;

@end
@interface HKLocationCategoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic,weak) id<HKLocationCategoryCollectionViewCellDelegate> delegate;
@property(nonatomic, assign) NSInteger selectIndex;
@end
