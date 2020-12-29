//
//  HKBlackListCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBlackListCell.h"

@interface HKBlackListCell ()
@property (nonatomic, strong)UIImageView * iconV;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *sexLevLabel;

@end

@implementation HKBlackListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.iconV];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.sexLevLabel];
    }
    return  self;
}
//
-(UIImageView *)iconV {
    if (!_iconV) {
        _iconV =[[UIImageView alloc] initWithFrame:CGRectMake(12,11,48,48)];
        _iconV.layer.cornerRadius =24;
        _iconV.layer.masksToBounds =YES;
        _iconV.contentMode =UIViewContentModeScaleAspectFill;
    }
    return _iconV;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconV.frame)+10,CGRectGetMinY(self.iconV.frame)+14,80,20)];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
    }
    return _nameLabel;
}
-(UILabel *)sexLevLabel {
    if (!_sexLevLabel) {
        _sexLevLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+10,CGRectGetMinY(self.iconV.frame)+18,30,12)];
        [AppUtils getConfigueLabel:_sexLevLabel font:[UIFont systemFontOfSize:9] aliment:NSTextAlignmentLeft textcolor:[UIColor whiteColor] text:@""];
      
    }
    return _sexLevLabel;
}
-(void)setList:(HKBlackList *)list {
    _list = list;
    [AppUtils seImageView:self.iconV withUrlSting:list.headImg placeholderImage:[UIImage imageNamed:@"Man"]];
    self.nameLabel.text = list.name;
    CGRect rect =[list.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCRegular15,NSForegroundColorAttributeName:[UIColor colorFromHexString:@"333333"]} context:nil];
    CGRect FrameL = self.nameLabel.frame;
    FrameL.size.width = rect.size.width;
    self.nameLabel.frame = FrameL;
    //sex 1.男  2女
     NSMutableAttributedString * textA =[self setLabelWithSex:list.sex.intValue andLevel:list.level];
    self.sexLevLabel.attributedText = textA;
    if (list.sex.intValue==1) {
        self.sexLevLabel.backgroundColor =RGB(123,198,243);
    }else {
        self.sexLevLabel.backgroundColor =RGB(255,131, 151);
    }
    self.sexLevLabel.layer.masksToBounds = YES;
    self.sexLevLabel.layer.cornerRadius = 5.5;
    if (!list.level.length) {
        self.sexLevLabel.hidden = YES;
    }else {
        self.sexLevLabel.hidden = NO;
    }
    NSString *lexs =[NSString stringWithFormat:@"LV.%@",list.level];
    CGRect rectS =[lexs boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil];
    
    self.sexLevLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+10,self.sexLevLabel.frame.origin.y,rectS.size.width+18,self.sexLevLabel.frame.size.height);
}
//获取性别等级字符串
-(NSMutableAttributedString *)setLabelWithSex:(NSInteger)sex andLevel:(NSString *)leavel {
    NSString *countStr =[NSString stringWithFormat:@"LV.%@",leavel];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    if (sex==1) {
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"Blackman"];
    }else {
         attch.image = [UIImage imageNamed:@"Blackwoman"];
    }
    attch.bounds = CGRectMake(2,-1,12,12);
    //创建带有图片的富文本
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",countStr]];
    [attri insertAttributedString:string atIndex:0];
    return  attri;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
