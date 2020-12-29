//
//  XLChannelItem.m
//  XLChannelControlDemo
//
//  Created by Apple on 2017/1/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#define BorderColor  [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1]
#define PlaceholderColor [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1]
#define TextColor [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1]

#import "XLChannelItem.h"

@interface XLChannelItem ()
{
    UILabel *_textLabel;
    UIImageView *productImg;
    UIImageView *deOraddImg;
}
@end

@implementation XLChannelItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = true;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 1.0f;
    self.backgroundColor = [UIColor whiteColor];
    
    productImg = [[UIImageView alloc] init];
    [productImg setImage:[UIImage imageNamed:@"imgDefault_bg"]];
    [productImg.layer setCornerRadius:2];
    productImg.clipsToBounds = YES;
    [self addSubview:productImg];
    
    deOraddImg = [[UIImageView alloc] init];
    [deOraddImg.layer setCornerRadius:2];
    deOraddImg.clipsToBounds = YES;
    [self addSubview:deOraddImg];
    deOraddImg.hidden = YES;
    
    _textLabel = [UILabel new];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = UICOLOR_RGB_Alpha(0x666666, 1);
    _textLabel.font = [UIFont systemFontOfSize:14];
//    _textLabel.adjustsFontSizeToFitWidth = true;
    _textLabel.userInteractionEnabled = true;
    [self addSubview:_textLabel];
}

-(void)isHiend
{
    productImg.hidden =  YES;
}

-(void)isOrChange:(BOOL)isHiend
{
    deOraddImg.hidden = isHiend;
}

-(void)isOrHiend:(BOOL)isHiend
{
    if (isHiend)
    {
        [deOraddImg setImage:[UIImage imageNamed:@"channel_delege"]];
    }
    else
    {
        [deOraddImg setImage:[UIImage imageNamed:@"channel_add"]];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    _textLabel.frame = self.bounds;
//     productImg.frame = CGRectMake(32, 26, 70*kScreenWidth/375, 70*kScreenWidth/375);
    [productImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(26);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(70*kScreenWidth/375);
        make.height.mas_equalTo(70*kScreenWidth/375);
    }];
    [deOraddImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(16);
        make.left.equalTo(self.mas_right).with.offset(-38);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->productImg.mas_bottom).with.offset(2);
        make.left.equalTo(self).with.offset(0);
        make.width.mas_equalTo(self.size.width);
        make.height.mas_lessThanOrEqualTo(100000);
    }];
    if (_isPlaceholder) {
        self.layer.borderColor = PlaceholderColor.CGColor;
        _textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    }else{
        self.layer.borderColor = BorderColor.CGColor;
        _textLabel.textColor = TextColor;
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _textLabel.text = title;
}

-(void)setImage:(NSString *)image
{
    _image = image;
    
    if ([_image isEqualToString:@"channel_commend"]||[_image isEqualToString:@"channel_advert"]) {
        [productImg setImage:[UIImage imageNamed:_image]];
    }
    else
    {
        if (image.length>0) {
            [productImg sd_setImageWithURL:[NSURL URLWithString:_image] placeholderImage:[UIImage imageNamed:@"imgDefault_bg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    [image  fadeIn:self->productImg withDuration: 0.2 andWait : 0.2];
                }
            }];
        }
        else
        {
            [productImg setImage:[UIImage imageNamed:@"imgDefault_bg"]];
        }
    }
    
}

-(void)setCategoryId:(NSString *)categoryId
{
    _categoryId = categoryId;
}

@end
