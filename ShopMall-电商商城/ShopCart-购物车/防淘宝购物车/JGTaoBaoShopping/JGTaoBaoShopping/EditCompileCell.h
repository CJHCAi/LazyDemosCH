//
//  EditCompileCell.h
//  JGTaoBaoShopping
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "PPNumberButton.h"



@protocol ShoppingSelectedDelegate <NSObject>

-(void)SelectedConfirmCell:(UITableViewCell *)cell;
-(void)SelectedCancelCell:(UITableViewCell *)cell;

-(void)ChangeGoodsNumberCell:(UITableViewCell *)cell Number:(NSInteger)num;
-(void)DeleteTheGoodsCell:(UITableViewCell *)cell;

@end

@interface EditCompileCell : MGSwipeTableCell


/**
 *  商品介绍
 */
@property (nonatomic, retain)UILabel *Goods_Desc;
/**
 *  商品的图片
 */
@property (nonatomic, retain)UIImageView *Goods_Icon;
/**
 *  下单数量
 */
@property (nonatomic, retain)PPNumberButton *Goods_NBCount;
/**
 *  选中按钮
 */
@property (nonatomic, retain)UIButton *Goods_Circle;
/**
 *  删除按钮
 */
@property (nonatomic, retain)UIButton *Goods_Delete;



-(void)withData:(NSDictionary *)info;

@property (nonatomic, weak)id<ShoppingSelectedDelegate> SelectedDelegate;

@end

