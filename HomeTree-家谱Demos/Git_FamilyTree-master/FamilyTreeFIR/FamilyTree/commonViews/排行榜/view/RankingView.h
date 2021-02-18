//
//  RankingView.h
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingView : UIView
/**
 *  排行第一头像
 */
@property (strong,nonatomic) UIImageView *topIV;
/**
 *  排行第一姓名
 */
@property (strong,nonatomic) UILabel *topNameLb;
/**
 *  排行第一活跃度
 */
@property (strong,nonatomic) UILabel *topScoreLb;
/**
 *  排行第二头像
 */
@property (strong,nonatomic) UIImageView *secondIV;
/**
 *  排行第二姓名
 */
@property (strong,nonatomic) UILabel *secondNameLb;
/**
 *  排行第二活跃度
 */
@property (strong,nonatomic) UILabel *secondScoreLb;
/**
 *  排行第三头像
 */
@property (strong,nonatomic) UIImageView *thirdIV;
/**
 *  排行第三姓名
 */
@property (strong,nonatomic) UILabel *thirdNameLb;
/**
 *  排行第三活跃度
 */
@property (strong,nonatomic) UILabel *thirdScoreLb;


@end
