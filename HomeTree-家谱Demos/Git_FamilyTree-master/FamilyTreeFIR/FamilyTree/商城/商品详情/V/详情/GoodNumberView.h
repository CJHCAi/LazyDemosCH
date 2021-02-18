//
//  GoodNumberView.h
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodNumberViewDelegate <NSObject>
/**
 *  修改数量
 *
 *  @param text   显示文本
 *  @param sender 增减按钮
 *
 *  @return 数量
 */
- (void)changeCountLb:(UILabel *)text action:(UIButton*)sender;

@end

@interface GoodNumberView : UIView
/**
 *  数量文本
 */
@property (strong,nonatomic) UILabel *countLb;
/**数量*/
@property (nonatomic,strong) UILabel *numLabel;
@property (weak,nonatomic) id<GoodNumberViewDelegate>delegate;
@end
