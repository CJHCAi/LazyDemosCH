//
//  ZHBGoodDetailBasicInfoTableViewCell.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/15.
//  Copyright © 2016年 zhbservice. All rights reserved.
//


#import <Foundation/Foundation.h>

@class ZHBGoodDetailViewModel;
typedef NS_ENUM(NSUInteger, BasicInfoTableViewCellClickType) {
    BasicInfoTableViewCellClickTypeGetCoupon, // 领券
    BasicInfoTableViewCellClickTypeDiscount, // 优惠
    BasicInfoTableViewCellClickTypeSelected, // 已选
    BasicInfoTableViewCellClickTypeServiceDescription, // 服务说明
    BasicInfoTableViewCellClickTypeConfig, // 配置
    BasicInfoTableViewCellClickTypeReduction, // 降价
    BasicInfoTableViewCellClickTypeBuyTip // 购买须知
};


@class ZHBGoodDetailBasicInfoTableViewCell;
@protocol ZHBGoodDetailBasicInfoTableViewCellDelegate <NSObject>

- (void)goodDetailBasicInfoTableViewCell:(ZHBGoodDetailBasicInfoTableViewCell *)goodBasicInfoCell
didClickWithBasicInfoTableViewCellClickType:(BasicInfoTableViewCellClickType)basicInfoCellClickType;

@end



#import <UIKit/UIKit.h>

@interface ZHBGoodDetailBasicInfoTableViewCell : UITableViewCell

@property (assign, nonatomic) id delegate;
@property (nonatomic, strong) ZHBGoodDetailViewModel *detailViewModel;

/** 领券 **/
@property (weak, nonatomic) IBOutlet UIView *getCouponView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *getCouponViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *getCouponTitle; // 领券左边
@property (weak, nonatomic) IBOutlet UILabel *getCouponLabel; // 领券右边

/** 优惠 **/
@property (weak, nonatomic) IBOutlet UIView *disCountView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disCountViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *discountTitle; // 优惠左边
@property (weak, nonatomic) IBOutlet UILabel *discountLabel; // 优惠右边

/** 配置 **/
@property (weak, nonatomic) IBOutlet UIView *configView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *configViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *configLabel; // 配置左边
@property (weak, nonatomic) IBOutlet UILabel *configTitle; // 配置右边

/** 已选 **/
@property (weak, nonatomic) IBOutlet UIView *selectedView;

/** 服务说明 **/
@property (strong, nonatomic) NSArray *serviceDataSource;
@property (weak, nonatomic) IBOutlet UIView *serviceDescriptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceDescriptionViewHeightCons;

/** 购买须知 **/
@property (weak, nonatomic) IBOutlet UIView *buyTipView; // 购买须知
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyTipViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyTipLIneViewHeightCons;

@property (weak, nonatomic) IBOutlet UILabel *buyTipTitle; // 左边
@property (weak, nonatomic) IBOutlet UILabel *tipLabel; // 右边

// 隐藏view
- (void)hiddenViewWithType:(BasicInfoTableViewCellClickType)basicInfoType;

@end
