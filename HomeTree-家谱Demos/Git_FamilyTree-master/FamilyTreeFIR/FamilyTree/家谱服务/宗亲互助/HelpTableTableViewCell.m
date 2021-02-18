//
//  HelpTableTableViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "HelpTableTableViewCell.h"
@interface HelpTableTableViewCell()
@property (nonatomic,strong) UIImageView *leftImageView; /*左边图*/
@property (nonatomic,strong) UILabel *oneLabel; /*label1*/


@end
@implementation HelpTableTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.oneLabel];
        //[self.contentView addSubview:self.twoLabel];
        
        self.leftImageView.sd_layout.leftSpaceToView(self.contentView,5).topSpaceToView(self.contentView,0).heightIs(0.2*Screen_width).widthIs(0.4*Screen_width);
        self.oneLabel.sd_layout.leftSpaceToView(self.leftImageView,5).rightSpaceToView(self.contentView,20).topEqualToView(self.leftImageView).heightIs(40);
        //self.twoLabel.sd_layout.leftEqualToView(self.oneLabel).topSpaceToView(self.oneLabel,5).rightEqualToView(self.oneLabel).bottomEqualToView(self.leftImageView);
        
    }
    return self;
}

-(void)setModel:(FamilyHelpDatalistModel *)model{
    _model = model;
    [_leftImageView setImageWithURL:[NSURL URLWithString:model.ZqCover] placeholder:MImage(@"sj_bg")];
    _oneLabel.text = model.ZqTitle;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark *** getters ***

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        
    }
    return _leftImageView;
}
-(UILabel *)oneLabel{
    if (!_oneLabel) {
        _oneLabel = [UILabel new];
        _oneLabel.font = MFont(15);
        //_oneLabel.text = @"只能拐杖,让关爱如影随形";
        _oneLabel.numberOfLines = 0;
    }
    return _oneLabel;
}
//-(UILabel *)twoLabel{
//    if (!_twoLabel) {
//        _twoLabel = [UILabel new];
//        _twoLabel.font = MFont(12);
//        _twoLabel.text = @"跌倒报警,gprs定位,跌倒报警,gprs定位跌倒报警,gprs定位跌倒报警,gprs定位跌倒报警,gprs定位跌倒报";
//        _twoLabel.numberOfLines = 0;
//    }
//    return _twoLabel;
//}
@end
