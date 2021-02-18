//
//  RankingTableViewCell.h
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingTableViewCell : UITableViewCell
/**
 *  排名
 */
@property (strong,nonatomic) UILabel *numberLb;
/**
 *  用户
 */
@property (strong,nonatomic) UILabel *nameLb;
/**
 *  家族
 */
@property (strong,nonatomic) UILabel *familyLb;
/**
 *  活跃度
 */
@property (strong,nonatomic) UILabel *activenessLb;
/**
 *  奖励
 */
@property (strong,nonatomic) UILabel *rewardLb;

@property (nonatomic,assign) UITableViewCellStyle cellStyle; /*style*/

-(void)initView;

@end
