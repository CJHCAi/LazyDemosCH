//
//  HK_walletListCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWalletLogModel.h"
 @class  WalletList;
@interface HK_walletListCell : UITableViewCell

@property (nonatomic, strong)UILabel * itemsLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UILabel * countLabel;
@property (nonatomic, strong)UIImageView * countV;
@property (nonatomic, strong)UIView *lineV;
@property (nonatomic, strong)WalletList *logModel;

-(void)setDataWithModel:(WalletList *)listModel;

@end
