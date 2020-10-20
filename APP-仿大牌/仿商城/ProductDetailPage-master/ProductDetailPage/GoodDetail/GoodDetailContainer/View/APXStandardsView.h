//
//  APXStandardsView.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/30.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APXNumberControl.h"
#import "ZHBProductAttrsInfoModel.h"
@class ZHBProdictDetailInfoModel;

#define StandardViewHeight  (kScreenHeight/4*3)//View 高度 根据应用情况调节
#define StandardViewWidth   (kScreenWidth)  // view宽度

typedef NS_ENUM(NSUInteger, StandardBottomBtnType) {
    StandardBottomBtnTypeSlectProperty = 0, //加入购物车&立即购买
    StandardBottomBtnTypeAddToShopCar, // 加入购物车
    StandardBottomBtnTypeBuy, // 立即购买
};

@class APXStandardsView;

@protocol APXStandardsViewDelegate <NSObject>


// 点击规格分类按键回调 sender 点击的按键 selectID 选中规格id standName 规格名称 index  规格所在cell的row
- (void)Standards:(APXStandardsView *)standardView selectedTheStandName:(NSString *)standName andIndexPtah:(NSIndexPath *)indexPath;

// 点击图片
- (void)Standards:(APXStandardsView *)standardView imgDidClick:(UIImageView *)img;

// 点击取消按钮
- (void)Standards:(APXStandardsView *)standardView dismissBtnClick:(id)sender;

// 加入购物车
- (void)Standards:(APXStandardsView *)standardView addToShopCarButtonClicked:(id)sender;

// 立即购买
- (void)Standards:(APXStandardsView *)standardView buyButtonClicked:(id)sender;

@end

@interface APXStandardsView : UIView<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) id <APXStandardsViewDelegate> delegate;

#pragma mark - 必要条件

@property (nonatomic, assign) StandardBottomBtnType standardBottomBtnType;

//商品简介view
@property(nonatomic, strong) UIImageView *mainImgView;//商品图片
@property(nonatomic, strong) UILabel *priceLab;//价格
@property (nonatomic, strong) UILabel *discountPriceLab;

// numberControl - 相当于 numberChooseControl.currentValue
@property(nonatomic, assign) NSInteger buyNum;//购买数量 read － write(初始值) 默认1可不设置

// numberChooseControl里面暴露了以下属性 minNumber maxNumber currentValue leftTipLabel(购买数量字样)
@property(nonatomic, strong) APXNumberControl *numberChooseControl;

// 规格数据
@property(nonatomic, strong) NSArray<ZHBProductAttrsInfoModel *> *standardArr;

// 内部属性 detailProductModel
@property (nonatomic, strong) ZHBProdictDetailInfoModel *detailInfoModel;

// reload 内部的collection
- (void)standardsViewReload;

- (void)changeStandardViewButtonEnable:(BOOL)enable;

@end



