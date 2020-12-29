//
//  HKLocalHeadCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLocalHeadCollectionViewCellDelegate <NSObject>
@optional
-(void)palyWithIndexPath:(NSIndexPath*)indexPath;

@end
@interface HKLocalHeadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic,weak) NSIndexPath *indexPath;
@property (nonatomic,weak) id<HKLocalHeadCollectionViewCellDelegate> delegate;
@property(nonatomic, assign) HKPalyStaue staue;
@end
