//
//  SPContractsViewController.h
//  SalesPo_iOS
//
//  Created by 甘萌 on 16/5/21.
//  Copyright © 2016年 Ganmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPContractsViewController.h"
@interface SPContractsViewController : UIViewController

@property (nonatomic, copy) void(^callback)(NSArray *arr);
@property (nonatomic, copy) NSArray *datasource;

@end
