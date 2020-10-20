//
//  MonthStarView.h
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"
@interface MonthStarView : UIView
/**
 *  头像
 */
@property (strong,nonatomic) UIImageView *headIV;
/**
 *  姓氏
 */
@property (strong,nonatomic) UILabel *surnameLb;
/**
 *  辈分
 */
@property (strong,nonatomic) UILabel *generationLb;
/**
 *  名字
 */
@property (strong,nonatomic) UILabel *nameLb;
/**
 *  字辈
 */
@property (strong,nonatomic) UILabel *characterLb;
/**
 *  排行
 */
@property (strong,nonatomic) UILabel *rankingLb;
/**
 *  往期每月之星
 */
@property (strong,nonatomic) UITableView *pastTableView;
/**
 *  往期数据数组
 */
@property (strong,nonatomic) NSArray <Lsmyzxr *>*dataArr;
@end
