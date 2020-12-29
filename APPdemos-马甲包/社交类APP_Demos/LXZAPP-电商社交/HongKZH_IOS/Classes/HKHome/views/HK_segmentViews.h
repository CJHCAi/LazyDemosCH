//
//  HK_segmentViews.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol segMentClickDelegete <NSObject>

-(void)clickSegIndex:(NSInteger)index;

-(void)goHistory;

@end

@interface HK_segmentViews : UIView

@property (nonatomic, strong)UIView *sliderV;

@property (nonatomic, weak)id <segMentClickDelegete>delegete;

-(void)setSegCongigueWithIndex:(NSInteger)index;


@end
