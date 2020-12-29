//
//  HK_SaleInfoCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKAfterSaleRespone.h"
@interface HK_SaleInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAfterLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;

-(void)ConfigueCellWithOrderString:(NSString *)orderString andResponse:(HKAfterSaleRespone *)response;


@end
