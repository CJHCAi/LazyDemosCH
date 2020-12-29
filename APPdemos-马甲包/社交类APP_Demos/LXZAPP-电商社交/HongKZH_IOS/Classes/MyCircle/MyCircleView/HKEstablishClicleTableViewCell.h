//
//  HKEstablishClicleTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class HKHKEstablishClicleParameters;
@protocol HKEstablishClicleTableViewCellDelegate <NSObject>

@optional
-(void)selectChannel;
-(void)selctImage;
-(void)selectJoin;
@end
@interface HKEstablishClicleTableViewCell : BaseTableViewCell
@property (nonatomic, strong)HKHKEstablishClicleParameters *parmeeter;
@property (nonatomic,weak) id<HKEstablishClicleTableViewCellDelegate> delegate;

@property (nonatomic, strong)UIImage *image;
@end
