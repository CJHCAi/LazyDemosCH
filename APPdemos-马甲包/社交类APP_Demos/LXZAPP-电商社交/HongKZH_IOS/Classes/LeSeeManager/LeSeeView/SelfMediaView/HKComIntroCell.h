//
//  HKComIntroCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCompanyResPonse.h"

typedef void(^SenderChangeBlock)(BOOL isSelect);

@interface HKComIntroCell : UITableViewCell
@property (nonatomic, strong)HKCompanyResPonse * response;
@property (nonatomic, copy) SenderChangeBlock block;
@end
