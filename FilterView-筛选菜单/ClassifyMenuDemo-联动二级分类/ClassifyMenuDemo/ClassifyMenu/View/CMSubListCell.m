//
//  CMSubListCell.m
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMSubListCell.h"
#import "CMenuConfig.h"

@implementation CMSubListCell

- (void)setNode:(CMNode *)node {
    _node = node;
    self.nodeLabel.text = node.name;
    if (node.isChoosed) {
        self.nodeLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor blueColor];
    }else {
        self.nodeLabel.textColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

- (UILabel *)nodeLabel {
    if (!_nodeLabel) {
        _nodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nodeLabel.textAlignment = NSTextAlignmentCenter;
        _nodeLabel.numberOfLines = 1;
        _nodeLabel.font = [UIFont systemFontOfSize:13*Rate];
        _nodeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nodeLabel];
        [_nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo (0);
        }];
    }
    return _nodeLabel;
}

@end
