//
//  Hk_detailFooterView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

//联系卖家 -->在线客服
#import <UIKit/UIKit.h>

@protocol ContactFootViewDelegete <NSObject>

-(void)ClickFootBtnWithTag:(NSInteger)index;

@end

@interface Hk_detailFooterView : UIView

+(instancetype)initWithFrame:(CGRect)frame OrderStatus:(NSString *)states;

@property (nonatomic, weak)id <ContactFootViewDelegete>delegete;

@end
