//
//  HK_tradeCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_orderListModel.h"
@interface HK_tradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopIm;
@property (weak, nonatomic) IBOutlet UILabel *tradeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tradeTimeLabel;
@property (nonatomic, strong)UILabel * countLabel;
@property (nonatomic, strong)UIImageView * imageV;
@property (weak, nonatomic) IBOutlet UIView *live;

-(void)configueDataWithModel:(OrderList *)listModel;

@end
