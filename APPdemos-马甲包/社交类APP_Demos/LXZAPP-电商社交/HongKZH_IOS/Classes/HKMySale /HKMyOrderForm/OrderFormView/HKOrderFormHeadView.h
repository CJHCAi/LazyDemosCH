//
//  HKOrderFormHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSellerorderListHeaderPesone.h"
typedef enum{
    OrderFormHeadType_Ing = 0,
    OrderFormHeadType_Finish = 7,
    OrderFormHeadType_Close = 10,
    OrderFormHeadType_wait = 3,
    OrderFormHeadType_waitPay = 1,
    OrderFormHeadType_goed = 4,
    OrderFormHeadType_afterSale =11
}OrderFormHeadType;
@protocol HKOrderFormHeadViewDelegate <NSObject>

@optional
-(void)selectStaueWithType:(OrderFormHeadType)type;
@end
@interface HKOrderFormHeadView : UIView
@property (nonatomic, strong)SellerorderListHeadeModel *model;
+(instancetype)orderFormHeadWithFrame:(CGRect)frame;
@property (nonatomic,assign) OrderFormHeadType headType;
@property (nonatomic,weak) id<HKOrderFormHeadViewDelegate> delegate;
@end
