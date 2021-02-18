//
//  WCartTableFooterView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCartTableFooterView;
@protocol WcarTableFooterViewDelegate <NSObject>

-(void)WCartTableFooterView:(WCartTableFooterView *)footView didSelectedButton:(UIButton *)sender;

@end
@interface WCartTableFooterView : UIView
/**全选按钮*/
@property (nonatomic,strong) UIButton *footSelectBtn;
/**合计多少钱*/
@property (nonatomic,strong) UILabel *priceLabel;
/**结算*/
@property (nonatomic,strong) UIButton *clearPrice;

@property (nonatomic,weak) id<WcarTableFooterViewDelegate> delegate; /*代理人*/


@end
