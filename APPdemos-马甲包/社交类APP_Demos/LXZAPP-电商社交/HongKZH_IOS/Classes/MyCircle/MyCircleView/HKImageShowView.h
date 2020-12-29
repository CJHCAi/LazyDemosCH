//
//  HKImageShowView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKImageShowViewDelegate <NSObject>

@optional
-(void)gotoShopping:(NSInteger)tag;

@end
@interface HKImageShowView : UIView
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic,weak) id<HKImageShowViewDelegate> delegate;
@end
