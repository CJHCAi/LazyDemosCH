//
//  DTHomeButton.m
//  DTcollege
//
//  Created by 信达 on 2018/7/24.
//  Copyright © 2018年 ZDQK. All rights reserved.
//

#import "DTHomeButton.h"

@implementation DTHomeButton


- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title
           withImageURLString:(NSString *)imageURLString{
    
    if (self = [super initWithFrame:frame]) {
        self.titleString = title;
        self.imageURLString = imageURLString;
        self.titleColor = @"#343434";
        [self createSubViews];
        
    }
    return self;
}

- (void)createSubViews{
    
    self.btnImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    //加载网络图片
    //[self.btnImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLString] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
//    self.btnImage.image = [UIImage imageNamed:@"bg"];
    CGFloat ran = arc4random_uniform(256)/255.0;
    self.btnImage.backgroundColor = [UIColor colorWithRed:ran green:ran blue:ran alpha:1];
    [self addSubview:self.btnImage];

    self.btnTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.btnTitle.textColor = [UIColor whiteColor];
    self.btnTitle.font = [UIFont systemFontOfSize:14];
    self.btnTitle.textAlignment = NSTextAlignmentCenter;
    self.btnTitle.text = self.titleString;
    [self addSubview:self.btnTitle];

    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.btnImage.frame = self.bounds;
    self.btnTitle.frame = CGRectMake(0,self.bounds.size.height-10-20, self.frame.size.width, 20);
   
}

@end
