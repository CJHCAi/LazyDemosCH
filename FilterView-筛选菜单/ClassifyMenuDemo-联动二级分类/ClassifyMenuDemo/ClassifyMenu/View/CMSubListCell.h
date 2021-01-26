//
//  CMSubListCell.h
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMSubListCell : UICollectionViewCell

@property (nonatomic,strong) CMNode *node;

@property (nonatomic,strong) UILabel *nodeLabel;



@end

NS_ASSUME_NONNULL_END
