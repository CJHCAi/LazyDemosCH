//
//  HKSelfMediaHotItemView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTop10ListRespone.h"

@interface HKSelfMediaHotItemView : UIView
@property (nonatomic, strong)CategoryTop10ListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *rankView;

@end
