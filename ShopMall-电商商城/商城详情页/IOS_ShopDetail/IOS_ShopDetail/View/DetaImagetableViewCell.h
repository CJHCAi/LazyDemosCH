//
//  DetaImagetableViewCell.h
//  LD_app_ios_NetWin
//
//  Created by 苟应航 on 2018/7/6.
//  Copyright © 2018年 lddtgroup. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface DetaImagetableViewCell : UITableViewCell
@property(nonatomic,strong)GoodsModel *model;
@property(nonatomic,strong)UIImageView *image;
+(instancetype)WithDetaImagetableViewCell:(UITableView *)tableview;
@end
