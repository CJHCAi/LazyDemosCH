//
//  HK_AddressInfoCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HK_OrderDeliverModel.h"
#import "HK_OrderDeliverModel.h"
@class HK_UserDeliveryAddressListModel;
@class RadioButton;
typedef void(^ModificationBlock)(addressDataModel *item);
typedef void(^DeleteBlock)(void);

typedef void(^RadiobtnBlock)(RadioButton* btn);

@interface HK_AddressInfoCell : UITableViewCell
{
    float fl;
}

@property (nonatomic, strong) UILabel *personLabel;

@property (nonatomic, strong) UILabel *phoneNumberLabel;

@property (nonatomic, strong) UILabel *addressTitleLabel;

@property (nonatomic, strong) UIImageView *addressImageView;

@property (nonatomic, strong) UIImageView *lineDashedImageView;

@property (nonatomic, strong) UIImageView *topBorderImageView;

@property (nonatomic, strong) UIImageView *btoomBorderImageView;

@property (nonatomic, strong) UIImageView *leftBorderImageView;

@property (nonatomic, strong) UIImageView *rightBorderImageView;

@property (nonatomic, strong) UIView *buttonsView;

@property (nonatomic, strong) UIButton *orDefaultSiteButton;

@property (nonatomic, strong) UIButton *modificationButton;

@property (nonatomic, strong) UIButton *deButton;

@property (nonatomic, strong) UIButton *modificationButtontwo;

@property (nonatomic, strong) UIButton *deButtontwo;

@property (nonatomic, strong)UILabel *defaultLabel;

@property (nonatomic, strong)RadioButton* btn;


@property (nonatomic, copy) ModificationBlock modificationBlock;

@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, copy) RadiobtnBlock radiobtnBlock;

@property (nonatomic, strong)addressDataModel * userAddrData;

@property (nonatomic, strong) UIImageView *authentication;

-(CGSize)calcSelfSize;
@end
