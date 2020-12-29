//
//  HK_orderAddressCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_orderInfo.h"

@protocol editUserAddressDelegete <NSObject>

-(void)editGoodsAddress;

@end

@interface HK_orderAddressCell : UITableViewCell
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIView * rootView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * phoneLabel;
@property (nonatomic, strong)UILabel * addressLabel;
@property (nonatomic, strong)UIButton * editAddressBtn;
@property (nonatomic, weak)id <editUserAddressDelegete>delegete;
-(void)setCellConfigueWithModel:(HK_orderInfo *)model;

@end
