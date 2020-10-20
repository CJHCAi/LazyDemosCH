//
//  GoodColorView.h
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailModel.h"
@protocol GoodColorViewDelegate <NSObject>
/**
 * 选择颜色
 */
- (void)goodColorChoose:(UIButton *)sender;

@end

@interface GoodColorView : UIView
/**
 *  视图初始化赋值
 */
- (void)initBtnsArray:(NSMutableArray<GoodColorModel*> *)arr;

@property (weak,nonatomic) id<GoodColorViewDelegate>delegate;
@end
