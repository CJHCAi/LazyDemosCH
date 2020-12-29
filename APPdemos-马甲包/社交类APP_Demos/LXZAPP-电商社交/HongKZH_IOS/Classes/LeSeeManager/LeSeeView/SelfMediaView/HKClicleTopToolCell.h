//
//  HKClicleTopToolCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKClicleTopToolCellDelegate <NSObject>

-(void)clickWithTag:(NSInteger)tag;

@end
@interface HKClicleTopToolCell : UICollectionViewCell
@property (nonatomic,weak) id<HKClicleTopToolCellDelegate> delegate;
@end
