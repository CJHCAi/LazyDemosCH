//
//  WCartTableViewCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodNumberView.h"

@class WCartTableViewCell;
@protocol WCartTableViewCellDelegate <NSObject>
-(void)WCartTableViewCell:(WCartTableViewCell *)cartCell atIndexPath:(NSIndexPath *)indexPath changedCellNumber:(NSString *)number;
@end

@interface WCartTableViewCell : UITableViewCell<GoodNumberViewDelegate>
/**图片*/
@property (nonatomic,strong) UIImageView *cellImage;
/**商品名字*/
@property (nonatomic,strong) UILabel *cellName;
/**款式*/
@property (nonatomic,strong) UILabel *cellType;
/**数量*/
@property (nonatomic,strong) GoodNumberView *cellNumber;
/**活动单价*/
@property (nonatomic,strong) UILabel *cellPrice;
/**原单价*/
@property (nonatomic,strong) NSString *cellDisPrice;
/**选择按钮*/
@property (nonatomic,strong) UIButton *cellSelectBtn;


/**购物车id*/
@property (nonatomic,strong) NSString *cellCarId;
/**商品id*/
@property (nonatomic,strong) NSString *cellGoodsId;
/**坐标*/
@property (nonatomic,strong) NSIndexPath *indexPath;
/**商品类型id*/
@property (nonatomic,strong) NSString *cellTypeId;




@property (nonatomic,weak) id<WCartTableViewCellDelegate> delegate; /*代理人*/



@end
