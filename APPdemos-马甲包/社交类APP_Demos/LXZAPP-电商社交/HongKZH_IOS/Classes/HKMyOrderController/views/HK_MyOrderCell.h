//
//  HK_MyOrderCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_orderInfo.h"
#import "Hk_MyOrderDataModel.h"
#import "HK_BuySellResponse.h"
//
typedef enum {
    HKActiveType_None = 0,
    HKActiveType_BaoKuan, //爆款
    HKActiveType_MiaoSha, //秒杀
    HKActiveType_ZheKou   //折扣
} HKActiveType;

@protocol StoreOrderCarigeDelegete <NSObject>
//存储物
-(void)saveGoodsToLocal:(orderSubMitModel *)model;

@end

@interface HK_MyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *MycountLabel;

@property (weak, nonatomic) IBOutlet UILabel *ShopNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *live;
@property (weak, nonatomic) IBOutlet UIImageView *activety_cover;

@property (nonatomic, strong)Hk_subOrderList * model;
@property (nonatomic, weak)id <StoreOrderCarigeDelegete> delegete;
@property (weak, nonatomic) IBOutlet UIImageView *iconTyoeV;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;

//我的订单
@property (nonatomic, strong)orderSubMitModel * subModel;
//我的售后.退换

@property (nonatomic, strong)HK_SubListSaleData *saleData;

-(void)setDetailOrderCell:(orderSubMitModel *)model;


@end
