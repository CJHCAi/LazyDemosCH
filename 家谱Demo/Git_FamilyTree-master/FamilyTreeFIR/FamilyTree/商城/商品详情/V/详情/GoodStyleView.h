//
//  GoodStyleView.h
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"
@protocol GoodStyleViewDelegate <NSObject>
/**
 *  款式选择
 */
- (void)goodStyleChoose:(UIButton*)sender;

@end

@interface GoodStyleView : UIView
/**
 *  界面初始化赋值
 */
- (void)initStyleBtns:(NSMutableArray<GoodStyleModel*>*)arr;

@property (weak,nonatomic) id<GoodStyleViewDelegate>delegate;
@end
