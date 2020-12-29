//
//  HK_AddressInfoCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_AddressInfoCell.h"
#import "RadioButton.h"
#import "UIImageView+WebCache.h"
#import "RadioButton.h"
#import "HK_UserDeliveryAddressListModel.h"
#define MarginX 81
#define MarginY 10

#define SelectSiteLabel_Heigh 20
#define SelectSiteLabel_Width 100

#define PersonLabel_Heigh 20
#define PersonLabel_Width (kScreenWidth-20)/2

#define PhoneNumberLabel_Heigh 20
#define PhoneNumberLabel_Width (kScreenWidth-20)/2

#define PicImageView_Width   40
#define PicImageView_Hight   40

#define Label_Margin_picImageView 10

#define AddressTitleLabel_Hight 20
#define AddressTitleLabel_Width 80

#define AddressLabel_Hight  20
#define AddressLabel_Width  (kScreenWidth-30)

#define NumberLabel_Hight  20
#define NumberLabel_Width  (kScreenWidth-70)

#define PersonLabel_Width (kScreenWidth-20)/2
@interface HK_AddressInfoCell()
{
    UIView *bgView;
    HK_UserDeliveryAddressListModel *item;
}
@end
@implementation HK_AddressInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        item = [[HK_UserDeliveryAddressListModel alloc] init];
        [self addUserAddressInfoTableViewCell];
    }
    return self;
}

-(void)setUserAddrData:(HK_UserDeliveryAddressListModel *)userAddrData
{
    if (userAddrData) {
        item = userAddrData;
    }
    
    NSMutableString *address1 = [[NSMutableString alloc] init];
    if ([userAddrData.provinceName length] >0  &&[userAddrData.provinceName isKindOfClass:[NSString class] ]) {
        // 省
        NSString *string1 = [NSString stringWithFormat:@"%@",userAddrData.provinceName];
        [address1 appendString:string1];
    }
    if ([userAddrData.cityName length] >0  &&[userAddrData.cityName isKindOfClass:[NSString class] ]) {
        // 市
        NSString *string2 = [NSString stringWithFormat:@"%@",userAddrData.cityName];
        [address1 appendString:string2];
    }
    if ([userAddrData.areaName length] >0  &&[userAddrData.areaName isKindOfClass:[NSString class] ]) {
        // 区
        NSString *string3 = [NSString stringWithFormat:@"%@",userAddrData.areaName];
        [address1 appendString:string3];
    }
    [address1 appendString:userAddrData.address];
//        if ([address1 length] >0  &&[address1 isKindOfClass:[NSMutableString class] ]) {
//            addressNumTextField.text= address1;
//        }
    [self.addressTitleLabel setText:address1];
    CGSize size = CGSizeMake(AddressLabel_Width, 20000);
    NSDictionary *attributedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0],NSFontAttributeName, nil];
    CGRect textRect = [address1 boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributedDic context:nil];
    if (userAddrData.consignee && [userAddrData.consignee length] >0  &&[userAddrData.consignee isKindOfClass:[NSString class] ])
    {
        [self.personLabel setText:[NSString stringWithFormat:@"%@", userAddrData.consignee]];
    }
    
    if (userAddrData.phone && [userAddrData.phone length] >0  &&[userAddrData.phone isKindOfClass:[NSString class] ])
    {
     //手机号中间位数加***
        NSString *ph;
        if ([AppUtils verifyPhoneNumbers:userAddrData.phone]) {
           ph =[self makeString:userAddrData.phone];
        }
        [self.phoneNumberLabel setText:[NSString stringWithFormat:@"%@",ph]];
    }
    CGFloat px = 5;
    CGFloat py = 10;
    CGFloat pw = kScreenWidth-10;
    CGFloat ph = 5;
    self.lineDashedImageView.frame = CGRectMake(px, py+ph+3+5+10+10, kScreenWidth-MarginX, 0.5);
    
    bgView.frame = CGRectMake(self.bounds.origin.x , self.bounds.origin.y,kScreenWidth,py+ph+4+26+19+10+15+5-10);
    
    px = 5;
    py  = py + textRect.size.height+5+5+10-1.5;
    pw = kScreenWidth-10;
    ph = 50;
    self.buttonsView.frame = CGRectMake(px, py+10, pw, ph-10);
    
    px = 5;
    py  = py +50;
    pw = kScreenWidth-10;
    ph = 5;
    self.btoomBorderImageView.frame = CGRectMake(px, py, pw, ph-10);
    
    px = 5;
    py  = 15+5;
    pw = 5;
    ph = PersonLabel_Heigh+PhoneNumberLabel_Heigh+textRect.size.height + 50+20;
    self.leftBorderImageView.frame = CGRectMake(px, py, pw, ph);
    
    px = kScreenWidth-10;
    py  = 15+5;
    pw = 5;
    ph = ph;
    self.rightBorderImageView.frame = CGRectMake(px, py, pw, ph);

    [self.modificationButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(33);
        make.left.equalTo(self.mas_right).with.offset(-34);
        make.size.mas_equalTo(CGSizeMake(24 ,24));
    }];
    
    [self.modificationButtontwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.personLabel.mas_bottom).with.offset(9);
        make.left.equalTo(self).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(35 ,16));
    }];
    
    [self.deButtontwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self).with.offset(kScreenWidth-70+35-17);
        make.size.mas_equalTo(CGSizeMake(40 ,40));
    }];
    
    [_btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(19);
        make.size.mas_equalTo(CGSizeMake(19.0f ,19.0f));
    }];
    
    if ([userAddrData.isDefault isKindOfClass:[NSString class]]&&[userAddrData.isDefault  length] > 0)
        {
            if([userAddrData.isDefault isEqualToString:@"1"])
            {
                _authentication.image = [UIImage imageNamed:@"person_authentication"];
            }
            else
            {
                _authentication.image = [UIImage imageNamed:@"person_onauthentication"];
            }
        }
    
    [_authentication mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->bgView).with.offset(10);
        make.left.equalTo(self->bgView).with.offset(kScreenWidth-48);
        make.size.mas_equalTo(CGSizeMake(28 ,20));
    }];
    
    UIImageView *antherImage = [UIImageView new];
    antherImage.backgroundColor =UICOLOR_RGB_Alpha(0xe2e2e2, 1);
    [self addSubview:antherImage];
    [antherImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).with.offset(-0.5);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
}
-(NSString *)makeString:(NSString *)number{
    NSString *str1 = number;
    NSRange range = {3, 4};
    NSString *result = [str1 stringByReplacingCharactersInRange:range withString:@"****"];
    return result;
}


-(CGSize)calcSelfSize;
{
    return CGSizeMake((kScreenWidth-10)/2, [HK_Tool HeightForView:self bottom:self.addressTitleLabel offset:40]);
}

- (void)addUserAddressInfoTableViewCell
{
    bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth ,self.frame.size.height));
    }];
    
    self.personLabel = [UILabel new];
    self.personLabel.backgroundColor = [UIColor clearColor];
    self.personLabel.font = [UIFont systemFontOfSize: 15.0];
    self.personLabel.textAlignment = NSTextAlignmentLeft;
    self.personLabel.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    //     self.personLabel.text = model.name;
    [bgView addSubview: self.personLabel];
    [ self.personLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->bgView).with.offset(18);
        make.left.equalTo(self->bgView).with.offset(16);
        make.width.mas_equalTo(81-16);
        make.height.mas_lessThanOrEqualTo(100000);
    
        
    }];
    
    
    _authentication = [UIImageView new];
    [bgView addSubview:_authentication];
    [_authentication mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->bgView).with.offset(10);
        make.left.equalTo(self->bgView).with.offset(kScreenWidth-48);
        make.size.mas_equalTo(CGSizeMake(28 ,20));
    }];
    
    
    self.phoneNumberLabel = [UILabel new];
    self.phoneNumberLabel.backgroundColor = [UIColor clearColor];
    self.phoneNumberLabel.font = [UIFont systemFontOfSize: 15.0];
    self.phoneNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneNumberLabel.textColor =UICOLOR_RGB_Alpha(0x333333, 1);
//    self.phoneNumberLabel.text = model.mobileNum;
    [self->bgView addSubview:self.phoneNumberLabel];
    [self.phoneNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->bgView).with.offset(18);
        make.left.equalTo(self->bgView).with.offset(81);
        make.width.mas_equalTo(kScreenWidth-81);
        make.height.mas_lessThanOrEqualTo(100000);
    }];
    
    //    UIImageView *onLneTopImage = [UIImageView new];
    //    onLneTopImage.backgroundColor =UICOLOR_RGB_Alpha(0xcccccc, 1);
    //    [self addSubview:onLneTopImage];
    //    [onLneTopImage mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.personLabel.mas_bottom).with.offset(3);
    //        make.self.left.equalTo(self).with.offset(20);
    //        make.size.mas_equalTo(CGSizeMake(kScreenWidth-20, 0.5));
    //    }];
    
    self.addressTitleLabel = [UILabel new];
    self.addressTitleLabel.backgroundColor = [UIColor clearColor];
    self.addressTitleLabel.font = [UIFont systemFontOfSize: 13.0];
    self.addressTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.addressTitleLabel.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
    self.addressTitleLabel.numberOfLines = 10;
    //    NSString *tarString = [NSString stringWithFormat:@"%@",model.addressinfo];
    NSString *tarString = @"";
    //        _lableDestail.lineBreakMode =  NSLineBreakByWordWrapping;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tarString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:3];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tarString length])];
    self.addressTitleLabel.attributedText = attributedString;
    //        _lableDestail.numberOfLines = 0;
    self.addressTitleLabel.numberOfLines = 2;
    self.addressTitleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    
    [bgView addSubview:self.addressTitleLabel];
    [self.addressTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->bgView).with.offset(44-13);
        make.self.left.equalTo(self->bgView).with.offset(81);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-115,40));
    }];
    
    
    self.modificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.modificationButton setImage:[UIImage imageNamed:@"address_write"] forState:UIControlStateNormal];
    [self.modificationButton addTarget:self action:@selector(didCLickModificationButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.modificationButton];
    
    
    self.modificationButtontwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.modificationButtontwo setTitle:@"默认" forState:UIControlStateNormal];
    self.modificationButtontwo.backgroundColor = keyColor;
    self.modificationButtontwo.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.modificationButtontwo setTitleColor:UICOLOR_RGB_Alpha(0xffffff,1) forState:UIControlStateNormal];
    [self.modificationButtontwo addTarget:self action:@selector(didCLickModificationButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.modificationButtontwo];
    
    
    CGFloat px = 5;
    CGFloat py = 10;
    CGFloat pw = kScreenWidth-10;
    CGFloat ph = 5;
    
    px = 5;
    py  = py + AddressLabel_Hight +30;
    pw = kScreenWidth-10;
    ph = 5;
    self.btoomBorderImageView = [[UIImageView alloc]init];
    self.btoomBorderImageView.frame = CGRectMake(px, py, pw, ph);
    [bgView addSubview:self.btoomBorderImageView];
    
    px = 5;
    py  = 15;
    pw = 5;
    ph = 130;
    self.leftBorderImageView = [[UIImageView alloc]init];
    self.leftBorderImageView.frame = CGRectMake(px, py, pw, ph);
    [bgView addSubview:self.leftBorderImageView];
    
    px = kScreenWidth-10;
    py  = 15;
    pw = 5;
    ph = 130;
    self.rightBorderImageView = [[UIImageView alloc]init];
    self.rightBorderImageView.frame = CGRectMake(px, py, pw, ph);
    [bgView addSubview:self.rightBorderImageView];
    
    CGRect rect = CGRectZero;
    rect.origin.x = 13+3;
    rect.origin.y = 7+4.5-2;
    rect.size.height = 19.0f;
    rect.size.width = 19.0f;
    
    _btn = [[RadioButton alloc] initWithFrame:rect];
    
    [_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:17];
    _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    
    [self addSubview:_btn];
}

- (void)didCLickModificationButton
{
    if (_modificationBlock) {
        _modificationBlock(self->item);
    }
}

-(void)didCLickDeButton
{
    if (_deleteBlock) {
        _deleteBlock();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
