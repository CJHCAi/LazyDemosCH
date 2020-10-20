//
//  WSearchGoodsCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSearchGoodsCell : UITableViewCell
/**图片*/
@property (nonatomic,strong) UIImageView *cellImage;
/**文字*/
@property (nonatomic,strong) UILabel *cellLabel;
/**价格*/
@property (nonatomic,strong) UILabel *cellPrice;
/**商品id*/
@property (nonatomic,strong) NSString *goodsId;


@end
