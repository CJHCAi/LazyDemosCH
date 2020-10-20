//
//  OrderSureViewController.h
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCartTableViewCell.h"

@interface OrderSureViewController : BaseViewController
- (instancetype)initWithShopTitle:(NSString *)title image:(UIImage *)image selectedArr:(NSArray <WCartTableViewCell *>*)selectArr
;
@end
