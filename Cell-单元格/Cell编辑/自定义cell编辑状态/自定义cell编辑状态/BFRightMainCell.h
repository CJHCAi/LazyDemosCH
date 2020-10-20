//
//  BFRightMainCell.h
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFRightMainCell : UITableViewCell
/** 商铺图片 */
@property(nonatomic,weak) UIImageView *shopImageView;
/** 商铺名称 */
@property(nonatomic,weak) UILabel *shopName;
/** 商铺会员标志 */
@property(nonatomic,weak) UIButton *isVipBtn;
/** 商铺主营 */
@property(nonatomic,weak) UILabel *shopSales;
/** 选中按钮 */
@property(nonatomic,weak) UIButton *collectBtn;

@end
