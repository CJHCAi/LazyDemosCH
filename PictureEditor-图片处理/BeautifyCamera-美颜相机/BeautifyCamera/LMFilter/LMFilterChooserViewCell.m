//
//  LMFilterChooserViewCell.m
//  LMUpLoadPhoto
//
//  Created by xx11dragon on 15/8/31.
//  Copyright (c) 2015年 xx11dragon. All rights reserved.
//

#import "LMFilterChooserViewCell.h"

#import "GPUImage.h"
#import <Masonry/Masonry.h>


@interface LMFilterChooserViewCell () {
    GPUImageView *view1;
    GPUImageFilterGroup * group;
}

@property (nonatomic , strong) UIImageView *previewView;
@property (nonatomic , strong) UILabel *titleLabel;

@end

@implementation LMFilterChooserViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        self.previewView = [[UIImageView alloc] init];

        [self.previewView setImage:[UIImage imageNamed:@"filter_no_effect"]];

        self.layer.borderWidth = 1.5f;
        
        [self addSubview:self.previewView];
        [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(-20);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.height.equalTo(@20);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];

    }
    return self;
}


- (void)setFilter:(LMFilterGroup *)filter {
    [self.previewView setImage:filter.effectIcon];
    group = filter;
    self.titleLabel.text = filter.title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view1.bounds.size.height - 20, view1.bounds.size.width, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


- (GPUImageFilterGroup *)getFilter {
    return group;
}

- (void)setState:(UIControlState)state {

    switch (state) {
        case UIControlStateNormal: {
            self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
        }
            break;
        case UIControlStateSelected:{
            self.layer.borderColor = [[UIColor greenColor] colorWithAlphaComponent:0.6f].CGColor;
        }
            break;
        default:
            break;
    }
    
}

@end
