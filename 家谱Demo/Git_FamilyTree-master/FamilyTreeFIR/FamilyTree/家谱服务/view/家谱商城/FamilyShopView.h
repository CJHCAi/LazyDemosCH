//
//  FamilyShopView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyShopView;
@protocol FamilyShopViewDelegate <NSObject>

-(void)familyShopViewDidTapView:(FamilyShopView *)famShop;

@end
@interface FamilyShopView : UIView
@property (nonatomic,weak) id<FamilyShopViewDelegate> delegate; /*代理人*/

@end
