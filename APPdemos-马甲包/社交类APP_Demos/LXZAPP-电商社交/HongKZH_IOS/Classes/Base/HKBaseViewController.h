//
//  HKBaseViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@interface HKBaseViewController : HK_BaseView
-(void)searchGoods;
-(void)setSearchUI;
-(void)setrightBarButtonItemWithImageName:(NSString*)imageStr;
-(void)rightBarButtonItemClick;
-(void)setrightBarButtonItemWithTitle:(NSString*)title;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, assign) NSInteger index;
+(void)showPreWithsuperVc:(HKBaseViewController*)supVc subVc:(HKBaseViewController*)subVc;
+(void)showPreWithsuperVc:(HKBaseViewController *)supVc subVc:(HKBaseViewController *)subVc color:(UIColor*)color;
@end
