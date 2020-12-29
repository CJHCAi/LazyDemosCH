//
//  HKComIntroCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKComIntroCell.h"

@interface HKComIntroCell ()

@property (nonatomic, strong)UILabel * contentLabel;
@property (nonatomic, strong)UIView  *line ;
@property (nonatomic, strong)UIButton *rowBtn;
@end

@implementation HKComIntroCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.rowBtn];
        [self.contentView addSubview:self.line];
    }
    return  self;
}

-(UIButton *)rowBtn {
    if (!_rowBtn) {
        _rowBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _rowBtn.frame = CGRectMake(kScreenWidth-15-40,15,40,40);
        [_rowBtn setImage:[UIImage imageNamed:@"introDown"] forState:UIControlStateNormal];
        [_rowBtn setImage:[UIImage imageNamed:@"introup"] forState:UIControlStateSelected];
        [_rowBtn addTarget:self
                    action:@selector(changeHight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rowBtn;
}

-(void)changeHight:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.contentLabel.frame = CGRectMake(15,15,kScreenWidth-30,80);
    }else {
         self.contentLabel.frame = CGRectMake(15,15,kScreenWidth-30,50);
    }
    if (self.block) {
        self.block(sender.selected);
    }
}
-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(15,15,kScreenWidth-30,50)];
        [AppUtils getConfigueLabel:_contentLabel font:PingFangSCRegular14 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
-(void)setResponse:(HKCompanyResPonse *)response {
    self.contentLabel.text = response.data.introduce;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
