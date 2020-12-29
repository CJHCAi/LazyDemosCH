//
//  SelfMediaHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTop10ListRespone.h"
@class HKSowingRespone;
@protocol SelfMediaHeadViewDelegate <NSObject>

@optional
-(void)selectWithTag:(NSInteger)tag;
-(void)clickItme:(CategoryTop10ListModel*)model;
@end
@interface SelfMediaHeadView : UIView
@property (nonatomic, strong)HKSowingRespone *sowM;
@property (nonatomic, strong)CategoryTop10ListRespone *top10;
@property (nonatomic,weak) id<SelfMediaHeadViewDelegate> delegate;
@property (nonatomic, assign)NSInteger num;

@property (nonatomic,assign) BOOL isHideDown;


@end
