//
//  TypeRankingView.h
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingModel.h"
@interface TypeRankingView : UIView

/**
 *  数据数组
 */
@property (strong,nonatomic) RankingModel *dataRank;
-(instancetype)initWithFrame:(CGRect)frame data:(RankingModel *)rankData;
@end
