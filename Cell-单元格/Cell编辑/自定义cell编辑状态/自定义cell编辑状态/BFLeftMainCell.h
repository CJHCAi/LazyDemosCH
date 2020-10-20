//
//  BFLeftMainCell.h
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFLeftMainCell : UITableViewCell

/** 商品图片 */
@property(nonatomic,weak) UIImageView *goodsImageView;
/** 标题 */
@property(nonatomic,weak) UILabel *goodsTitle;
/** 地点 */
@property(nonatomic,weak) UILabel *address;
/** 价格 */
@property(nonatomic,weak) UILabel *goodsPrice;
/** 标志 */
@property(nonatomic,weak) UIImageView *tipImageView;
/** 选中按钮 */
@property(nonatomic,weak) UIButton *collectBtn;

@end
