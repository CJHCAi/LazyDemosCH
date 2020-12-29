//
//  YCSearchTableViewCell.m
//  YClub
//
//  Created by yuepengfei on 17/5/9.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCSearchTableViewCell.h"

@interface YCSearchTableViewCell ()
{
    UILabel  *_titleLabel;
    UIView   *_lineView;
    UILabel  *_noResultLabel;
}
@end
@implementation YCSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubviews];
    }
    return self;
}
#pragma mark - addSubviews
- (void)addSubviews
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 49.5)];
    _titleLabel.textColor = YC_Base_TitleColor;
    _titleLabel.font      = [UIFont systemFontOfSize:15];
    _titleLabel.text      = @"热门搜索";
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, KSCREEN_WIDTH, 0.5)];
    _lineView.backgroundColor = YC_Base_LineColor;
    
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_lineView];
    [self.contentView addSubview:_noResultLabel];
}
#pragma mark - configModel
- (void)configHotTitle:(NSArray *)titles
{
    if (titles.count == 0) {
        
        _noResultLabel.hidden = NO;
        return;
    }
    _noResultLabel.hidden = YES;
    CGFloat totalWidth = 0;
    CGFloat height     = 65;
    
    for (NSString *title in titles) {
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setTitleColor:YC_Base_TitleColor forState:UIControlStateNormal];
        [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [searchBtn setTitle:title forState:UIControlStateNormal];
        int i = arc4random()%2;
        if (i) {
            
            UIImage *image = [UIImage imageNamed:@"yc_search_hotBtn_blue"];
            [searchBtn setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2] forState:UIControlStateNormal];
        } else {
            UIImage *image = [UIImage imageNamed:@"yc_search_hotBtn_red"];
            [searchBtn setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2] forState:UIControlStateNormal];
        }
        [self.contentView addSubview:searchBtn];
        
        CGFloat titleWidth =  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width+28;
        if (totalWidth + titleWidth >= KSCREEN_WIDTH-30) {
            
            height+=42;
            totalWidth = titleWidth+15;
            searchBtn.frame     = CGRectMake(15, height, titleWidth, 27);
            
        } else {
            
            totalWidth += 15;
            searchBtn.frame     = CGRectMake(totalWidth, height, titleWidth, 27);
            totalWidth += titleWidth;
        }
    }
}
+ (CGFloat)calculateCellHeightWithTitles:(NSArray *)titles
{
    CGFloat height = 50;
    
    if (titles.count == 0) {
        
        return height+=50;
    }
    height += 15;
    CGFloat totalWidth = 0;
    for (NSString *title in titles) {
        
        CGFloat titleWidth =  [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width+28;
        
        if (totalWidth + titleWidth >= KSCREEN_WIDTH-30) {
            
            height+=42;
            totalWidth = titleWidth+15;
        } else {
            
            totalWidth += 15;
            totalWidth += titleWidth;
        }
    }
    height += 42;
    return height;
}
#pragma mark - searchBtnAction
- (void)searchBtn:(UIButton *)sender
{
    if (kStringIsEmpty(sender.titleLabel.text)) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(doSearchWithHotKey:)]) {
        
        [self.delegate doSearchWithHotKey:sender.titleLabel.text];
    }
}
@end
