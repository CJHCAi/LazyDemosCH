//
//  HKCommodityDisplayView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PurchaseGoodsDelegete <NSObject>

-(void)purchase ;
-(void)selectGoods;

@end

@interface HKCommodityDisplayView : UIView
@property (nonatomic, weak)id <PurchaseGoodsDelegete>delegete;
-(void)setImageArray:(NSArray*)imageArray imagenum:(int)num;
@end
