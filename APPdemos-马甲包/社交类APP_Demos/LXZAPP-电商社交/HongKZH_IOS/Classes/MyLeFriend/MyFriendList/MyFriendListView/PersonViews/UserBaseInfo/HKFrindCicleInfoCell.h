//
//  HKFrindCicleInfoCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMediaInfoResponse.h"
@interface HKFrindCicleInfoCell : UITableViewCell
@property (nonatomic, strong)HKMediaCicleData *response;
@property (nonatomic, strong)UILabel * tagLabel;
@property (nonatomic, strong)UIImageView * iconImageView;
@property (nonatomic, strong)UILabel * cicleNameLabel;
@property (nonatomic, strong)UIImageView *row;
@end
