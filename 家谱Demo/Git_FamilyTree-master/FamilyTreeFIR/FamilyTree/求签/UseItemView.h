//
//  UseItemView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UseItemView;

@protocol UseItemViewDelegate <NSObject>

-(void)UseItemViewDidRespondsToUseBtn:(UseItemView *)useView;

@end

@interface UseItemView : UIView
@property (nonatomic,strong) UIButton *useBtn; /*试用按钮*/
@property (nonatomic,strong) UILabel *priceLabel; /*价格*/
/**图片*/
@property (nonatomic,strong) UIImageView *goodsImage;


@property (nonatomic,weak) id<UseItemViewDelegate> delegate; /*代理人*/

@end
