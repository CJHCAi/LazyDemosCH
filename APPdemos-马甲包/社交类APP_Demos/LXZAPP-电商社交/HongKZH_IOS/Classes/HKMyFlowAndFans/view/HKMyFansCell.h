//
//  HKMyFansCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AttentionButtonClickBlock)(id cellValue, UITableViewCell *cell);

@interface HKMyFansCell : UITableViewCell

@property (nonatomic, strong) id cellValue;

@property (nonatomic, copy) AttentionButtonClickBlock attentionButtonClickBlock;

@end
