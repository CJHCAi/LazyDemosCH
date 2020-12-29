//
//  HKHotAdvTypeListView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EnterpriseHotAdvTypeListRedpone;
@protocol HKHotAdvTypeListViewDelegate <NSObject>

-(void)clickType:(NSInteger)tag;

@end
@interface HKHotAdvTypeListView : UIView
@property (nonatomic, strong)EnterpriseHotAdvTypeListRedpone *model;
@property (nonatomic,weak) id<HKHotAdvTypeListViewDelegate> delegate;
@end
