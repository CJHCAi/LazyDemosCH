//
//  HKCicleProductHeadCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCicleProductResponse.h"

@protocol ProductSkuDelegete <NSObject>
@optional
-(void)showSkuView;
@end
@interface HKCicleProductHeadCell : UITableViewCell
@property (nonatomic, strong)HKCicleProductResponse *response;
@property (nonatomic, weak)id<ProductSkuDelegete>delegete;
@end
