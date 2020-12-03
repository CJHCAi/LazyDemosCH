//
//  IFRangeSlider.h
//  MaMaShoppingPro
//
//  Created by 谭鄱仑 on 14-9-19.
//  Copyright (c) 2014年 谭鄱仑. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TPLRangeSliderItem : UIImageView




@property(nonatomic,strong)void (^pan)(UIPanGestureRecognizer * pan ,int itemStyle,TPLRangeSliderItem * item);
@property(nonatomic,assign)int itemStyle;//0为左边，1为右边

@property(nonatomic,assign)int range;

@end


@interface TPLRangeSlider : UIControl




@property(nonatomic,assign)CGFloat  titleHeight;
@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,strong)UIColor * titleColor;
@property(nonatomic,strong)UIFont  * titleFont;

//滑动块
@property(nonatomic,readonly)TPLRangeSliderItem * leftItem;
@property(nonatomic,readonly)TPLRangeSliderItem * rightItem;

//滑动条
@property(nonatomic,strong)UIColor * bottomColor;
@property(nonatomic,strong)UIColor * upColor;
@property(nonatomic,assign)CGFloat sliderItemSize;
@property(nonatomic,assign)CGFloat bottomViewHeight;
@property(nonatomic,assign)CGFloat upViewHeight;
@end
