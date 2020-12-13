//
//  LHListCell.m
//  LHRichEditor
//
//  Created by 刘昊 on 2018/5/9.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "LHListCell.h"

#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height
@interface LHListCell ()
{
    UIView *_backView;
    UIImageView *_imageView;
}
@end
@implementation LHListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self setUI];

    }
    return self;
}

- (void)initData
{
    
}

- (void)setUI{
    _backView = [UIView new];
    _backView.frame = CGRectMake(15, 0, kAppFrameWidth -30,93 );
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.borderWidth = 0.5;
    [self addSubview:_backView];
    
    _imageView = [UIImageView new];
    _imageView.frame = CGRectMake(0, 0, 63, 63);
    _imageView.center = CGPointMake(kAppFrameWidth -30 - 46.5, 46.5);
    [_backView addSubview:_imageView];
    
    _titleLab = [UILabel new];
    _titleLab.frame = CGRectMake(15, 0,kAppFrameWidth - (30) -(30), (93));
    _titleLab.textColor = [UIColor blueColor];
    [_backView addSubview:_titleLab];
}


- (void)setModel:(XSIndexModel *)model{
    _titleLab.text = model.content;
    if (model.img) {
         _imageView.hidden = NO;
        NSData *decodedImageData = [[NSData alloc]
                                    initWithBase64EncodedString:model.img  options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:decodedImageData];
        _imageView.image = image;
        if (image == nil) {
            _titleLab.frame = CGRectMake(15, 0,kAppFrameWidth  - (30) -(30), (93));
        }else{
            _titleLab.frame = CGRectMake( (15), 0,kAppFrameWidth  - (93) -(45), (93));
        }
    }else{
        _imageView.hidden = YES;
    }
    
}


@end
