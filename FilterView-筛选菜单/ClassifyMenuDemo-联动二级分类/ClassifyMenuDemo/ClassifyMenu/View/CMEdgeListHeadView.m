//
//  CMEdgeListHeadView.m
//  明医智
//
//  Created by LiuLi on 2019/1/17.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMEdgeListHeadView.h"
#import "CMenuConfig.h"

@implementation CMEdgeListHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)sectionTaped:(UITapGestureRecognizer *) recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapHeadView:)]) {
        [self.delegate tapHeadView:self];
    }
}

- (void)setNode:(CMNode *)node {
    _node = node;
    self.nameLabel.text = node.name;
    // 用于点击的时候获取控件
    if (node.isChoosed) {
        self.edgeLine.hidden = NO;
        self.nameLabel.font = [UIFont systemFontOfSize:15*Rate];
        self.nameLabel.textColor = [UIColor blueColor];
        self.backgroundColor = [UIColor whiteColor];
    }else {
        self.edgeLine.hidden = YES;
        self.nameLabel.font = [UIFont systemFontOfSize:14*Rate];
        self.nameLabel.textColor = [UIColor grayColor];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}

- (UIView *)edgeLine {
    if (!_edgeLine) {
        _edgeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5*(50*Rate-20*Rate), 4*Rate, 20*Rate)];
        _edgeLine.backgroundColor = [UIColor blueColor];
        [self addSubview:_edgeLine];
    }
    return _edgeLine;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*Rate, 0, 125*Rate-15*Rate, 49.5*Rate)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14*Rate];
        _nameLabel.textColor = [UIColor grayColor];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

//- (UIView *)line {
//    if (!_line) {
//        // 添加分割线
//        _line = [[UIView alloc] initWithFrame:CGRectMake(15*Rate, 49.5*Rate, 125*Rate-15*Rate, 0.5*Rate)];
//        [self addSubview:_line];
//    }
//    return _line;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
