//
//  HKCollageDetailOrderCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCollageOrderResponse.h"
typedef void(^pasteBlock)(void);
@interface HKCollageDetailOrderCell : UITableViewCell
@property (nonatomic, copy) pasteBlock block;
@property (nonatomic, strong)HKCollageOrderResponse * response;
@end
