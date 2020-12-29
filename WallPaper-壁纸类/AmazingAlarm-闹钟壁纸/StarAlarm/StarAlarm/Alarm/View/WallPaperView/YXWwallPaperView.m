
//
//  YXWwallPaperView.m
//  StarAlarm
//
//  Created by dllo on 16/4/1.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWwallPaperView.h"

@interface YXWwallPaperView ()

@property (nonatomic, strong) UIView *wallPaperView;
@property (nonatomic, strong) UILabel *wallLabel;
@property (nonatomic, strong) UIImageView *smallWPImageView;

@end

@implementation YXWwallPaperView


+(instancetype)shareUseViewWith:(CGRect)frame {
    static YXWwallPaperView *useView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        useView = [[YXWwallPaperView alloc] initWithFrame:frame];
    });
    return useView;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    [self creatView];
    }
    return self;
}

- (void)creatView {
    //选中view
    self.wallPaperView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.wallPaperView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.203448275862069];
    //选中文字
    self.wallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 + 20,self.frame.size.width , 20)];
    self.wallLabel.text = @"已使用";
    self.wallLabel.textAlignment = NSTextAlignmentCenter;
    self.wallLabel.textColor = [UIColor whiteColor];
    //选中图片
    self.smallWPImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 16, self.frame.size.height / 2 - 16, 32, 32)];
    self.smallWPImageView.image = [UIImage imageNamed:@"xuanzhong"];
    [self addSubview:self.wallPaperView];
    [self.wallPaperView addSubview:self.wallLabel];
    [self.wallPaperView addSubview:self.smallWPImageView];
    
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
