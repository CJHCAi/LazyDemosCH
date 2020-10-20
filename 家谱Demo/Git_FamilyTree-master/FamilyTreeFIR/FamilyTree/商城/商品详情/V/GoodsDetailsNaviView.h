//
//  GoodsDetailsNaviView.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsDetailsNaviViewDelegate <NSObject>
/**
 *  视图改变view随之改变
 */
- (void)changeView:(UIButton *)sender;


@end

@interface GoodsDetailsNaviView : UIView

@property (weak,nonatomic) id<GoodsDetailsNaviViewDelegate>delegate;
/**
 *  视图变为评价
 */
- (void)chooseView:(NSInteger)sender;
@end
