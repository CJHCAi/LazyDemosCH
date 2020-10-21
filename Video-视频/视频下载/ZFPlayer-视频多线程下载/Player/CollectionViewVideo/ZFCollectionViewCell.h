//
//  ZFCollectionViewCell.h
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFVideoModel.h"
#import "ZFPlayer.h"

@interface ZFCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (nonatomic, strong) UIButton *playBtn;
/** model */
@property (nonatomic, strong) ZFVideoModel *model;
/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);

@end
