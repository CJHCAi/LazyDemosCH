 //
//  YIMEditerTextColorCell.m
//  yimediter
//
//  Created by ybz on 2017/11/23.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerTextColorCell.h"
#import "YIMScrollSelectView.h"
#import "YIMEditerTextStyle.h"
#import "UIColor+YIMEditerExtend.h"
#import "NSBundle+YIMBundle.h"


@interface YIMEditerTextColorCell()<YIMScrollSelectViewDelegate,YIMScrollSelectViewDatasource>{
    NSArray<UIColor*>* _colorArray;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)YIMScrollSelectView *selectView;
@end


@implementation YIMEditerTextColorCell

-(void)setup{
    [super setup];
    _colorArray = [YIMEditerTextStyle styleAllColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [[NSBundle YIMBundle]localizedStringForKey:@"颜色" value:@"颜色" table:nil];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    
    YIMScrollSelectView *selectView = [[YIMScrollSelectView alloc]init];
    selectView.dataSource = self;
    selectView.delegate = self;
    [self.contentView addSubview:selectView];
    
    self.titleLabel = titleLabel;
    self.selectView = selectView;
}
-(CGFloat)needHeight{
    return 70;
}
-(void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.attributedText.size.width, self.titleLabel.attributedText.size.height);
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.frame), self.titleLabel.attributedText.size.height/2 + 8);
    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 8, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame) - 8);
}

#pragma -mark get set
-(void)setColor:(UIColor *)color{
    NSInteger index = -1;
    for (NSInteger i = 0;i < _colorArray.count;i++) {
        if ([[_colorArray[i] hexString] isEqualToString:[color hexString]]) {
            index = i;
        }
    }
    NSAssert(index!=-1, @"不包含选择颜色");
    _color = color;
    [self.selectView selectedIndex:index animation:true];
}


#pragma -mark SelecterView Delegate Functions
-(void)YIMScrollSelectView:(YIMScrollSelectView *)selectView didSelectedIndex:(NSInteger)index{
    _color = _colorArray[index];
    if (self.colorChangeBlock) {
        self.colorChangeBlock(_color);
    }
}
-(NSInteger)numberOfItems:(YIMScrollSelectView *)selectView{
    return _colorArray.count;
}
-(CGSize)itemSize:(YIMScrollSelectView *)selectView{
    return CGSizeMake(60, 30);
}
-(UIView*)normalView:(YIMScrollSelectView *)selectView atIndex:(NSInteger)index{
    UIView *view = [[UIView alloc]init];
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(20, 5, 20, 20)];
    colorView.tag = 10086;
    colorView.clipsToBounds = true;
    colorView.layer.cornerRadius = 10;
    colorView.backgroundColor = _colorArray[index];
    [view addSubview:colorView];
    return view;
}
-(UIView*)selectedView:(YIMScrollSelectView *)selectView atIndex:(NSInteger)index{
    UIView *view = [[UIView alloc]init];
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 30, 30)];
    colorView.tag = 10086;
    colorView.clipsToBounds = true;
    colorView.layer.cornerRadius = 15;
    colorView.backgroundColor = _colorArray[index];
    [view addSubview:colorView];
    return view;
}
-(void)animation:(YIMScrollSelectView *)selectView oldSelectedView:(UIView *)oldSelectedView oldNormalView:(UIView *)oldNormalView{
    UIView *oldSelectedColorView = [oldSelectedView viewWithTag:10086];
    oldSelectedColorView.frame = CGRectMake(20, 5, 20, 20);
    oldSelectedColorView.layer.cornerRadius = 10;
    UIView *oldNormalColorView = [oldNormalView viewWithTag:10086];
    oldNormalColorView.frame = CGRectMake(15, 0, 30, 30);
    oldNormalColorView.layer.cornerRadius = 15;
}

@end
