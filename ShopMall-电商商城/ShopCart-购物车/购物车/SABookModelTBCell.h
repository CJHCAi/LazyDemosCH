//
//  SABookModelTBCell.h
//  01-购物车
//
//  Created by Shenao on 2017/5/17.
//  Copyright © 2017年 hcios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SABookModel,SABookModelTBCell;

@protocol SABookCellDelegate <NSObject>

- (void)bookCellDidClickPlusButton:(SABookModelTBCell * )bookCell;

- (void)bookCellDidClickMinusButton:(SABookModelTBCell * )bookCell;

@end


@interface SABookModelTBCell : UITableViewCell

@property (nonatomic,strong) SABookModel * bookModel;

@property (nonatomic,weak)  id<SABookCellDelegate> delegate;//代理

@end
