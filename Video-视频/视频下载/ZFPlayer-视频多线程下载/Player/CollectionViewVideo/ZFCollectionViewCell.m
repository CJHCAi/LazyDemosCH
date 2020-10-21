//
//  ZFCollectionViewCell.m
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ZFCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    // 必须指定tag值，不然在ZFPlayerView里无法取到playerView加到哪里了
    self.topicImageView.tag = 200;
    // 代码添加playerBtn到imageView上
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.topicImageView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topicImageView);
        make.width.height.mas_equalTo(50);
    }];
}

- (void)setModel:(ZFVideoModel *)model {
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.titleLabel.text = model.title;
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}
@end
