//
//  CXSearchCollectionReusableView.m
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXSearchCollectionReusableView.h"

@interface CXSearchCollectionReusableView()

@property (weak,nonatomic) UILabel *textLabel;

@property (weak,nonatomic) UIImageView *imageView;

@property (weak,nonatomic) UIButton *delectButton;

@end

@implementation CXSearchCollectionReusableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18.0f, (self.frame.size.height - 18.0f / 2), 18, 18)];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(18 +5.0f + 18, (self.frame.size.height - 18.0f / 2), 100.0f, 18)];
    label.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    label.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:label];
    self.textLabel = label;
    
    UIButton *delectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 65 - 18 , (self.frame.size.height - 30.0f / 2), 65, 30)];
    [delectButton setTitleColor:[UIColor colorWithWhite:0.498 alpha:1.000] forState:UIControlStateNormal];
    [delectButton setContentEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [delectButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [delectButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [delectButton setTitle:@"清空" forState:UIControlStateNormal];
    [delectButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delectButton];
    _delectButton = delectButton;
}

- (void)deleteClick {
    if ([self.delegate respondsToSelector:@selector(deleteDatas:)]) {
        [self.delegate deleteDatas:self];
    }
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.textLabel.text = text;
}

- (void)setHidenDeleteBtn:(BOOL)hidenDeleteBtn {
    _hidenDeleteBtn = hidenDeleteBtn;
    self.delectButton.hidden = _hidenDeleteBtn;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

@end
