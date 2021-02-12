//
//  CMEdgeListCell.m
//  明医智
//
//  Created by LiuLi on 2019/1/30.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMEdgeListCell.h"

@implementation CMEdgeListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ReuseID = @"CMEdgeListCell";
    CMEdgeListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseID];
    if (cell == nil) {
        cell = [[CMEdgeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseID];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (void)setNode:(CMNode *)node {
    _node = node;
    self.nodeLabel.text = node.name;
}

- (UILabel *)nodeLabel {
    if (!_nodeLabel) {
        _nodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nodeLabel.textAlignment = NSTextAlignmentLeft;
        _nodeLabel.numberOfLines = 1;
        _nodeLabel.font = [UIFont systemFontOfSize:14*Rate];
        _nodeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nodeLabel];
        [_nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo (0);
            make.left.mas_equalTo(25*Rate);
        }];
    }
    return _nodeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.nodeLabel.textColor = selected ? [UIColor blueColor] : [UIColor grayColor];
    
    // Configure the view for the selected state
}

@end
