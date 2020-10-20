//
//  ZHBGoodDetailChildProductViewController.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/14.
//  Copyright © 2016年 zhbservice. All rights reserved.
//
// | 商品-详情-评价 | 商品页

#import "ZHBGoodDetailBasicInfoTableViewCell.h"

@class ZHBGoodDetailWebView;
@class ZHBGoodDetailViewModel;
@class ZHBGoodDetailChildProductViewController;
@class APXProductModel;


typedef NS_ENUM(NSUInteger, ChildProductViewScrollType) {
    ChildProductViewScrollTypeScrollToWebView, // 滑向web
    ChildProductViewScrollTypeScrollToTableView, // 滑向tab
};

@protocol ZHBGoodDetailChildProductViewControllerDelegate <NSObject>

// 领券,优惠,已选,服务说明等type
- (void)childProductViewController:(ZHBGoodDetailChildProductViewController *)childProductViewController
                 BasicInfoDidClick:(BasicInfoTableViewCellClickType)basicInfoTableViewCellClickType;
// 滑向web和tab
- (void)childProductViewController:(ZHBGoodDetailChildProductViewController *)childProductViewController
                      ScrollToType:(ChildProductViewScrollType)childProductViewScrollType;




// 滚动代理
- (void)childProductViewControllerScrollViewDidScroll:(CGFloat )offset;

@end


@interface ZHBGoodDetailChildProductViewController : UIViewController


@property (nonatomic, strong) ZHBGoodDetailWebView *goodDetailWebView;

@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) UIScrollView *allContentView;
@property (nonatomic, weak) id<ZHBGoodDetailChildProductViewControllerDelegate>delegate;
- (void)configureWebview:(ZHBGoodDetailWebView *)goodDetailWebView;

@end
