//
//  UtilProtocol.h
//  XiYou_IOS
//
//  Created by regan on 15/11/17.
//  Copyright © 2015年 regan. All rights reserved.
//

#ifndef UtilHKProtocol_h
#define UtilHKProtocol_h


@class HK_GladlyFriendTitleView;
@class HK_GladlyBuyView;
@class NK_BuySlideTitleView;
@class NK_LookSlideTitleView;
@class HK_LookRecommendSideTitleView;
@class HK_ProductTitleView;
@class HK_GladlyCitySlideView;

@class XY_TitleView;
@class XY_LoginTitleView;
@class XY_choiceTitleScrollView;
@class XY_ProductHeaderView;
@class XY_ProductBottomView;
@class XY_AllOrderTitleView;
@class XY_ChoiceHeaderView;
@class XY_productTitleScrollView;
@class XY_CouponTitleView;
@class XY_RedPacketTitleView;
@class XY_LayoutTitleScrollView;
@class XY_ChoiceTitleView;
@class XY_FemaleTitleView;

@protocol HKNavigationBarDelegate <NSObject>

@optional
-(void)leftBtnHKPressed:(id)sender;
-(void)rightBtnHKPressed:(id)sender;
@end

@protocol HK_SelfMediaLeftDelegate <NSObject>
@optional
-(void)gotoLeftView;
@end

@protocol HK_SelfMediaRightDelegate <NSObject>
@optional
-(void)gotoRightView;
@end

@protocol HK_SelfMediaSeachDelegate <NSObject>
@optional
-(void)gotoSeachView;
@end

@protocol HK_GladlyBuyTitleLeftDelegate <NSObject>
@optional
-(void)gotoLeftView;
@end

@protocol HK_GladlyBuyTitleRightDelegate <NSObject>
@optional
-(void)gotoRightView;
@end

@protocol HK_GladlyBuyTitleSeachDelegate <NSObject>
@optional
-(void)gotoSeachView;
@end

@protocol HK_GladlyFriendTitleLeftDelegate <NSObject>
@optional
-(void)gotoLeftView;
@end

@protocol HK_GladlyFriendTitleRightDelegate <NSObject>
@optional
-(void)gotoRightView;
@end

@protocol HK_GladlyFriendTitleSeachDelegate <NSObject>
@optional
-(void)gotoSeachView;
@end

@protocol HK_GladlyLookLeftDelegate <NSObject>
@optional
-(void)gotoLeftView;
@end

@protocol HK_GladlyLookRightDelegate <NSObject>
@optional
-(void)gotoRightView;
@end

@protocol HK_GladlyLookSeachDelegate <NSObject>
@optional
-(void)gotoSeachView;
@end

@protocol HK_GladlyFriendTitleViewDelegate <NSObject>
@optional
-(void)titleView:(HK_GladlyFriendTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;
@end

@protocol HK_LookRecommendSideTitleDelegate <NSObject>
@optional
-(void)titleView:(HK_LookRecommendSideTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;
@end

@protocol HK_GladlyCommendCellDelegate <NSObject>
@optional
-(void)gotoUserView:(NSString*)userid;
@end

@protocol HK_BuySlideTitleViewDelegate <NSObject>
@optional
-(void)titleView:(NK_BuySlideTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;
@end

@protocol HK_LookSlideTitleViewDelegate <NSObject>
@optional
-(void)titleView:(NK_LookSlideTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;
@end

@protocol HK_GladlyListRightDelegate <NSObject>
@optional
-(void)gotoRightFriendGoodView;
@end

@protocol GladlyUserCellDelegate<NSObject>
-(void)selIndexValue:(NSInteger)index;
@end

@protocol EnterpriseBlockDelegate<NSObject>
-(void)blockUp:(BOOL)isblock;
@end

@protocol EnterpriseDetailsDelegate<NSObject>
-(void)selIndexValue:(NSInteger)index;
@end

@protocol HK_ClasslyViewDelegate <NSObject>
@optional
-(void)gotoClasslyView:(NSString*)categary_id categaryTitle:(NSString*)categary_title;
@end


@protocol HK_ProductTitleViewDelegate <NSObject>

@optional
-(void)titleView:(HK_ProductTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end

@protocol HK_GladlyCitySlideViewDelegate <NSObject>

@optional
-(void)titleView:(HK_GladlyCitySlideView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end


@protocol CustomSettlementDelegate <NSObject>

@optional
-(void)allbtnClick;
-(void)settlementClick;
@end

@protocol HK_GladlyChannelTitleRightDelegate <NSObject>
@optional
-(void)gotoRightView:(BOOL)isHiend;
@end



@protocol XY_TitleViewDelegate <NSObject>

@optional
-(void)titleView:(XY_TitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end

@protocol XY_LoginTitleViewDelegate <NSObject>

@optional
-(void)titleView:(XY_LoginTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end



@protocol XY_FemaleTitleViewDelegate <NSObject>

@optional
-(void)titleView:(XY_FemaleTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end


@protocol XY_ChoiceTitleViewDelegate <NSObject>

@optional
-(void)titleView:(XY_ChoiceTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end

@protocol XY_MyOrderTitleViewDelegate <NSObject>

@optional
-(void)titleView:(XY_AllOrderTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end

@protocol XY_CouponTitleDelegate <NSObject>

@optional
-(void)titleView:(XY_CouponTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end

@protocol XY_RedPacketTitleDelegate <NSObject>

@optional
-(void)titleView:(XY_RedPacketTitleView*)titleView scrollToIndex:(NSInteger)tagIndex;

@end

@protocol XY_choiceTitleScrollViewDelegate <NSObject>

@optional

-(void)scrollClick:(XY_choiceTitleScrollView*)click clickIndex:(NSInteger)clickIndex;
@end

@protocol XY_productTitleScrollViewDelegate <NSObject>

@optional

-(void)scrollClick:(XY_productTitleScrollView*)click clickIndex:(NSInteger)clickIndex;
@end


@protocol XY_choiceHeardScrollViewDelegate <NSObject>

@optional

-(void)scrollHeaderClick:(XY_ChoiceHeaderView*)click clickIndex:(NSInteger)clickIndex;////////
@end


@protocol XY_gotoMoreSpecialViewDelegate <NSObject>

@optional

-(void)gotoMoreSpecialView;
@end


@protocol XY_ProductHeaderViewDelegate <NSObject>

@optional

-(void)scrollClick:(XY_ProductHeaderView*)click clickIndex:(NSInteger)clickIndex;
@end

@protocol XY_ProductBottomViewDelegate <NSObject>

@optional

-(void)bottomViewClick:(XY_ProductBottomView*)click clickIndex:(NSInteger)clickIndex;
@end

@protocol XY_gotoXiYouDelegate <NSObject>

@optional

-(void)gotoXiYouView;
@end

@protocol KindsViewDelegate <NSObject>
-(void)KindsViewUp:(NSInteger)number;
@end

@protocol BrandsViewDelegate <NSObject>
-(void)BrandsViewUp:(NSInteger)number;
@end



@protocol SlideGotoView <NSObject>
-(void)SlideGotoView;
@end



#endif /* UtilProtocol_h */

