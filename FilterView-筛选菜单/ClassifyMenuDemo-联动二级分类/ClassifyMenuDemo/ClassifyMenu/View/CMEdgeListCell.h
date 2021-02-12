//
//  CMEdgeListCell.h
//  明医智
//
//  Created by LiuLi on 2019/1/30.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNode.h"
#import "CMenuConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMEdgeListCell : UITableViewCell

@property (nonatomic,strong) UILabel *nodeLabel;

@property (nonatomic,strong) CMNode *node;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
