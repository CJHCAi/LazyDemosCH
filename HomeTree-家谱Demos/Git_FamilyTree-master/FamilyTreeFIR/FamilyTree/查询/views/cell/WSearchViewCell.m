//
//  WSearchViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSearchViewCell.h"
@interface WSearchViewCell()

/**家谱背景*/
@property (nonatomic,strong) UIImageView *backImageView;

/**透明背景*/
@property (nonatomic,strong) UIView *backView;


@end
@implementation WSearchViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.portraitView];
        [self.backView addSubview:self.backImageView];
        [self.backView addSubview:self.famName];
        
    }
    return self;
}
#pragma mark *** getters ***
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        
    }
    return _backView;
}
-(UIImageView *)portraitView{
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] initWithFrame:AdaptationFrame(0, 20, 140, 140)];
        _portraitView.image = MImage(@"news_touxiang.png");
        
    }
    return _portraitView;
}
-(UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectXW(self.portraitView), CGRectY(self.portraitView), 526*AdaptationWidth(), 140*AdaptationWidth())];
        _backImageView.image = MImage(@"cx_bg1");
    }
    return _backImageView;
}
-(UILabel *)famName{
    if (!_famName) {
        _famName = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.portraitView)/AdaptationWidth()+50, 20, 450, 140)];
        _famName.font = WFont(50);
        _famName.textAlignment = 0;
        _famName.text = @"妖精的尾巴";
    }
    return _famName;
}
@end
