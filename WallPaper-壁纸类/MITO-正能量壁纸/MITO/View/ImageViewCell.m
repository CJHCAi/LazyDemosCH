//
//  ImageViewCell.m
//  MITO
//
//  Created by keenteam on 2017/12/16.
//  Copyright © 2017年 keenteam. All rights reserved.
//

#define imageCell @"imageCellIdentify"
#import "ImageViewCell.h"

@interface ImageViewCell ()


@end

@implementation ImageViewCell

- (NSString *)reuseIdentifier {
    return imageCell;
}

- (void)setModel:(PeoperModel *)model{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"LBLoadError.jpg"]];

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        
    }
    return self;
}

- (void) setUI{
    
    [self.contentView addSubview:self.imgView];

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
}

- (UIImageView *)imgView{

    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:self.frame];
       
    }
    return _imgView;
}

@end
