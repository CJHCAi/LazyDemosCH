//
//  PPCalculView.h
//  amezMall_New
//
//  Created by Liao PanPan on 2017/4/24.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getMoneyBlock)(CGFloat totalMoney);

@interface PPCalculView : UIView

-(void)getMoneyClick:(getMoneyBlock)block;

@end
