//
//  SelecterToolsScrolView.h
//  SelecterTools
//
//  Created by zhao on 16/3/15.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnClick)(UIButton *);


typedef enum : NSUInteger {
    TriggerTypeOfBtnClick,
    TriggerTypeOfScrViewScroll,
} TriggerType;

@interface SelecterToolsScrolView : UIScrollView

@property int kuandu;
-(void)updateSelecterToolsIndex:(NSInteger )index;

@property (nonatomic, assign) BOOL isHiddenLine;

#pragma mark  - 【商品详情使用】
-(instancetype)initWithSeletershopdetails:(NSArray *)titleArr andBool:(BOOL) Bool andBtnBlock:(BtnClick)btnClick;

@end
