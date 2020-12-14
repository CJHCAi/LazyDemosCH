//
//  YIMEditerTextFontCell.m
//  yimediter
//
//  Created by ybz on 2017/11/22.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerTextFontSizeCell.h"
#import "YIMScrollSelectView.h"
#import "NSBundle+YIMBundle.h"

@interface YIMEditerTextFontSizeCell()<YIMScrollSelectViewDatasource,YIMScrollSelectViewDelegate>{
    NSArray<NSNumber*>* _fontSizeArray;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)YIMScrollSelectView *selectView;
@end

@implementation YIMEditerTextFontSizeCell

-(void)setup{
    [super setup];
    NSMutableArray<NSNumber*>* fs = [NSMutableArray array];
    for (uint i = 8; i <= 20; i++) {
        [fs addObject:[NSNumber numberWithUnsignedInt:i]];
    }
    _fontSizeArray = fs;
    
    //标题Label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [[NSBundle YIMBundle]localizedStringForKey:@"字号" value:@"字号" table:nil];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    
    //滚动选择器
    YIMScrollSelectView *selectView = [[YIMScrollSelectView alloc]init];
    selectView.dataSource = self;
    selectView.delegate = self;
    [self.contentView addSubview:selectView];
    
    //地步分割线
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:1];
    
    self.titleLabel = titleLabel;
    self.selectView = selectView;
}
-(CGFloat)needHeight{
    return 64;
}
//更新布局
-(void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.attributedText.size.width, self.titleLabel.attributedText.size.height);
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.contentView.frame), self.titleLabel.attributedText.size.height/2 + 8);
    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 8, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(self.titleLabel.frame) - 8);
}
#pragma -mark get set
//设置字体大小
-(void)setFontSize:(NSInteger)fontSize{
    _fontSize = fontSize;
    for (NSInteger i = 0; i < _fontSizeArray.count;i++) {
        if (_fontSizeArray[i].integerValue == fontSize) {
            [self.selectView selectedIndex:i animation:true];
            break;
        }
    }
}

#pragma -mark YIMScrollSelectView Delegate and DataSource Functions
-(void)YIMScrollSelectView:(YIMScrollSelectView *)selectView didSelectedIndex:(NSInteger)index{
    NSInteger fontSize = _fontSizeArray[index].integerValue;
    _fontSize = fontSize;
    if (self.fontSizeChangeBlock) {
        self.fontSizeChangeBlock(fontSize);
    }
}
-(NSInteger)numberOfItems:(YIMScrollSelectView *)selectView{
    return _fontSizeArray.count;
}
-(UIView*)normalView:(YIMScrollSelectView *)selectView atIndex:(NSInteger)index{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = [NSString stringWithFormat:@"%d",_fontSizeArray[index].unsignedIntValue];
    return lbl;
}
-(UIView*)selectedView:(YIMScrollSelectView *)selectView atIndex:(NSInteger)index{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:18];
    lbl.textColor = self.setting.tintColor;
    lbl.text = [NSString stringWithFormat:@"%d",_fontSizeArray[index].unsignedIntValue];
    return lbl;
}
@end
