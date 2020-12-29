//
//  PayCoinTableViewCell.m
//  SportForum
//
//  Created by liyuan on 15/3/6.
//  Copyright (c) 2015年 zhengying. All rights reserved.
//

#import "PayCoinTableViewCell.h"
#import "CSButton.h"

@implementation PayCoinItem

@end

@implementation PayCoinTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgView];
        
        _lbPayDesc = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbPayDesc];
        
        _lbSep = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbSep];
        
        _btnPay = [CSButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btnPay];
    }
    
    return self;
}

-(void)setPayCoinItem:(PayCoinItem *)payCoinItem {
    if (payCoinItem == _payCoinItem) {
        return;
    }
    
    _payCoinItem = payCoinItem;
    
    [_imgView setImage:[UIImage imageNamed:payCoinItem.payImage]];
    _imgView.frame = CGRectMake(5, 5, 55, 49);
    
    _lbPayDesc.backgroundColor = [UIColor clearColor];
    _lbPayDesc.text = payCoinItem.payDesc;
    _lbPayDesc.textColor = [UIColor darkGrayColor];
    _lbPayDesc.font = [UIFont boldSystemFontOfSize:14];
    _lbPayDesc.frame = CGRectMake(CGRectGetMaxX(_imgView.frame) + 10, CGRectGetMidY(_imgView.frame) - 10, 150, 20);
    _lbPayDesc.textAlignment = NSTextAlignmentLeft;
    
    [_btnPay setTitle:[NSString stringWithFormat:@"%lu元", payCoinItem.payValue] forState:UIControlStateNormal];
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPay setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [_btnPay setBackgroundImage:[UIImage imageNamed:@"btn-3-blue"] forState:UIControlStateNormal];
    _btnPay.backgroundColor = [UIColor clearColor];
    _btnPay.frame = CGRectMake(182, 11, 123, 38);
    _btnPay.actionBlock = _payClickBlock;
    
    _lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    _lbSep.frame = CGRectMake(0, 59, self.contentView.frame.size.width, 1);
}

+(CGFloat)heightOfCell{
    return 60;
}

@end
