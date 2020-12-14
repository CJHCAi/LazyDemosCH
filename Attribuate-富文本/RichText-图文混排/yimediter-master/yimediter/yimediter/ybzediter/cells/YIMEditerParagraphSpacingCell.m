//
//  YIMEditerParagraphSpacingCell.m
//  yimediter
//
//  Created by ybz on 2017/12/2.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphSpacingCell.h"
#import "YIMScrollSelectView.h"
#import "NSBundle+YIMBundle.h"

@interface YIMEditerParagraphSpacingCell()<YIMScrollSelectViewDelegate,YIMScrollSelectViewDatasource> {
    CGFloat _minHeight;
    CGFloat _step;
    CGFloat _number;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)YIMScrollSelectView *selectView;
@property(nonatomic,strong)UILabel *numberLabel;
@end

@implementation YIMEditerParagraphSpacingCell

-(void)setup{
    [super setup];
    _number = 40;
    _step = 0.1;
    _minHeight = 5;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [[NSBundle YIMBundle]localizedStringForKey:@"行间距" value:@"行间距" table:nil];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:numberLabel];
    
    YIMScrollSelectView *selectView = [[YIMScrollSelectView alloc]init];
    selectView.dataSource = self;
    selectView.delegate = self;
    [self.contentView addSubview:selectView];
    
    self.titleLabel = titleLabel;
    self.selectView = selectView;
    self.numberLabel = numberLabel;
}
-(CGFloat)needHeight{
    return 69;
}
-(void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, 4, self.frame.size.width, self.titleLabel.attributedText.size.height);
    self.numberLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+4, self.frame.size.width, 12);
    
    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame) + 2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.numberLabel.frame) - 2);
}

-(void)setSpacingHeight:(CGFloat)spacingHeight{
    _spacingHeight = spacingHeight;
    [self.selectView selectedIndex:(spacingHeight - _minHeight)/_step animation:true];
}

-(NSInteger)numberOfItems:(YIMScrollSelectView *)selectView{
    return _number;
}
-(CGSize)itemSize:(YIMScrollSelectView *)selectView{
    return CGSizeMake(5, 20);
}
-(UIView*)normalView:(YIMScrollSelectView *)selectView atIndex:(NSInteger)index{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 40)];
    UIView *shotView = [[UIView alloc]init];
    shotView.backgroundColor = [UIColor blackColor];
    CGFloat jd = 8;
    if (index%10 == 0) {
        jd = 0;
    }else if (index % 5 == 0){
        jd = 4;
    }
    CGFloat w = 1/[UIScreen mainScreen].scale;
    shotView.frame = CGRectMake(CGRectGetMidX(contentView.frame)-(w/2), jd, w, CGRectGetHeight(contentView.frame) - jd);
    [contentView addSubview:shotView];
    return contentView;
} -(UIView*)selectedView:(YIMScrollSelectView *)selectView atIndex:(NSInteger)index{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 40)];
    UIView *shotView = [[UIView alloc]init];
    shotView.backgroundColor = self.setting.tintColor;
    CGFloat jd = 8;
    if (index%10 == 0) {
        jd = 0;
    }else if (index % 5 == 0){
        jd = 4;
    }
    CGFloat w = 1/[UIScreen mainScreen].scale;
    shotView.frame = CGRectMake(CGRectGetMidX(contentView.frame)-(w/2), jd, w, CGRectGetHeight(contentView.frame) - jd);
    [contentView addSubview:shotView];
    return contentView;
}
-(void)YIMScrollSelectView:(YIMScrollSelectView *)selectView didSelectedIndex:(NSInteger)index{
    self.numberLabel.text = [NSString stringWithFormat:@"%.1f", _minHeight + (index * _step)];
    if (self.spacingChange) {
        self.spacingChange(_minHeight + (index * _step));
    }
}
-(BOOL)YIMScrollSelectView:(YIMScrollSelectView *)selectView didScrollSelected:(NSInteger)index{
    CGFloat h = MIN(_minHeight + (_number * _step), MAX(_minHeight, _minHeight + (index * _step)));
    self.numberLabel.text = [NSString stringWithFormat:@"%.1f", h];
    if (self.spacingChange) {
        self.spacingChange(h);
    }
    return true;
}




@end
