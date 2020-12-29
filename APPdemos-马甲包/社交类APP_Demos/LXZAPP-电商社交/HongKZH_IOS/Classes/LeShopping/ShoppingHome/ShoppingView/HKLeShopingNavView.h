//
//  HKLeShopingNavView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLeShopingNavViewDelegate <NSObject>

@optional
-(void)gotoVc:(NSInteger)tag;
-(void)goToSearchVc;
@end
@interface HKLeShopingNavView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
-(void)setNavTitle;
@property (nonatomic,weak) id<HKLeShopingNavViewDelegate> delegate;
-(void)loadCartNum;

@property(nonatomic, assign) BOOL isSelect;
@end
