//
//  TJPhotoCollectionCell.m
//  TJGifMaker
//
//  Created by TanJian on 17/6/16.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJPhotoCollectionCell.h"

@interface TJPhotoCollectionCell ()

@property (strong, nonatomic) UIImageView * photoView;
@property (strong, nonatomic) UIButton * selectBtn;

@end

@implementation TJPhotoCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    [self configerUI];
    
    return self;
}

-(void)configerUI{
    
    self.photoView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.clipsToBounds = YES;
    [self.contentView addSubview:_photoView];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(self.bounds.size.width - 40,0, 40, 40);
    [_selectBtn setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 12, 0);
    [_selectBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    
}

-(void)setImage:(UIImage *)image{
    if (image) {
        _image = image;
        _photoView.image = image;
        _selectBtn.selected = NO;
    }
}

-(void)buttonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (self.selectedBlock) {
            self.selectedBlock(self.index);
        }
    }else{
        if (self.unSelectedBlock) {
            self.unSelectedBlock(self.index);
        }
    }
    
}


@end
