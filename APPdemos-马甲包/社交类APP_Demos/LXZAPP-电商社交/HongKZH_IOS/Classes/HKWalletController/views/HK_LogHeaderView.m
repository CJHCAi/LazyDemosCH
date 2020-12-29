//
//  HK_LogHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_LogHeaderView.h"

@interface HK_LogHeaderView ()
@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, strong)UILabel *countNumberLabel;
@property (nonatomic, strong)UIView *topLineV;
@property (nonatomic, strong)UIView *botLine;
@end

@implementation HK_LogHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.topLineV];
        [self addSubview:self.messageLabel];
        [self addSubview:self.countNumberLabel];
        [self addSubview:self.botLine];
        [self.botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(10);
        }];
    }
    return  self;
}
-(UIView *)topLineV {
    if (!_topLineV) {
        _topLineV =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        _topLineV.backgroundColor =RGB(245,245,245);
    }
    return _topLineV;
}
-(UIView *)botLine {
    if (!_botLine) {
        _botLine =[[UIView alloc] init];
        _botLine.backgroundColor =RGB(245,245,245);
    }
    return _botLine;
}
-(UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.countNumberLabel.frame)+8,kScreenWidth,14)];
        [AppUtils getConfigueLabel:_messageLabel font:PingFangSCRegular14 aliment:NSTextAlignmentCenter textcolor:RGB(102,102,102) text:@"您今日共计收入"];
    }
    return _messageLabel;
}
-(UILabel *)countNumberLabel {
    if (!_countNumberLabel) {
        _countNumberLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topLineV.frame)+32,kScreenWidth,35)];
        [AppUtils getConfigueLabel:_countNumberLabel font:BoldFont35 aliment:NSTextAlignmentCenter textcolor:keyColor text:@""];
        _countNumberLabel.attributedText =[self configuLabelImageWith:3580];
    }
    return _countNumberLabel;
}
-(NSMutableAttributedString *)configuLabelImageWith:(NSInteger)count {
    NSString *countStr =[NSString stringWithFormat:@"%zd",count];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"coin5"];
    attch.bounds = CGRectMake(0,-1,20,20);
    //创建带有图片的富文本
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",countStr]];
    [attri insertAttributedString:string atIndex:0];
    return  attri;
}

-(void)setTotalDetail {
    self.messageLabel.text =@"用乐币购物,享更低优惠";
    self.countNumberLabel.attributedText =[self configuLabelImageWith:[LoginUserData sharedInstance].integral];
}
@end
