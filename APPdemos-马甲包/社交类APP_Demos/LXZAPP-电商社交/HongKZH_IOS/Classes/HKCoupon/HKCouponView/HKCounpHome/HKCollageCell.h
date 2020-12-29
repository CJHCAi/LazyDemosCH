//
//  HKCollageCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCounponTool.h"

typedef void(^collageBlock)(NSString *counId);
@interface HKCollageCell : UITableViewCell

@property (nonatomic, strong)HKCollageBaseList *list;
@property (nonatomic, copy) collageBlock block;

@end
