//
//  SXTNearLiveCell.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/6.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXTLive.h"

@interface SXTNearLiveCell : UICollectionViewCell

@property (nonatomic, strong) SXTLive * live;

- (void)showAnimation;

@end
