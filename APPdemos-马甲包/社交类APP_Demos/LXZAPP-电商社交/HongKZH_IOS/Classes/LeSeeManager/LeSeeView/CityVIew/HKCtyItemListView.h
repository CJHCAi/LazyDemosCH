//
//  HKCtyItemListView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKCtyItemListViewDelegate <NSObject>

@optional
-(void)itemClick:(NSInteger)index;

@end
@interface HKCtyItemListView : UIView
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSArray *selfMediaArray;
@property (nonatomic,weak) id<HKCtyItemListViewDelegate> delegate;
@end
