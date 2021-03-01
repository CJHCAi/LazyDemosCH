//
//  URLCardView.m
//  HTMLDescription
//
//  Created by 刘继新 on 2017/9/12.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import "URLCardView.h"
#import <YYWebImage/UIImageView+YYWebImage.h>

@implementation URLCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = CGSizeMake([[UIScreen mainScreen]bounds].size.width - 40, 100);
        frame.origin = CGPointMake(20, 220);
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.layer.borderWidth = 0.5;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 4;
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.frame = CGRectMake(10, 10, 80, 80);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, self.frame.size.width - 110, 20)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    self.desLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 35, self.frame.size.width - 110, 60)];
    self.desLable.font = [UIFont systemFontOfSize:15];
    self.desLable.textColor = [UIColor grayColor];
    self.desLable.numberOfLines = 0;
    [self addSubview:self.desLable];
}

- (void)setHTMLData:(HTMLModel *)data {
    self.titleLabel.text = data.title;
    self.desLable.text = data.descriptionText;
    NSURL *imgURL = [NSURL URLWithString:data.coverURL];
    [self.imageView yy_setImageWithURL:imgURL
                               options:YYWebImageOptionSetImageWithFadeAnimation];
}

@end
