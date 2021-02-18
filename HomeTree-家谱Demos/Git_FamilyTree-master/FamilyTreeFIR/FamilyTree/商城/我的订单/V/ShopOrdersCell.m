
//
//  ShopOrdersCell.m
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ShopOrdersCell.h"

@interface ShopOrdersCell()<ShopActionViewDelegate>
/**
 *  订单id(暂时不知道具体接口直接赋值为编号)
 */
@property (strong,nonatomic) NSString *orderId;

@end

@implementation ShopOrdersCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 10)];
    [self addSubview:headV];
    headV.backgroundColor = LH_RGBCOLOR(230, 230, 230);

    _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectYH(headV)+10, 100, 15)];
    [self addSubview:_dateLb];
    _dateLb.font = MFont(11);
    _dateLb.textAlignment = NSTextAlignmentLeft;

    _statusLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-80,CGRectYH(headV)+10, 70, 15)];
    [self addSubview:_statusLb];
    _statusLb.font = MFont(14);
    _statusLb.textAlignment = NSTextAlignmentRight;
    _statusLb.textColor = [UIColor redColor];

    _totalLb = [[UILabel alloc]init];
    [self addSubview:_totalLb];
    _totalLb.font = MFont(12);
    _totalLb.textAlignment = NSTextAlignmentCenter;

    _allPayLb = [[UILabel alloc]init];
    [self addSubview:_allPayLb];
    _allPayLb.textAlignment = NSTextAlignmentRight;
    _allPayLb.font = MFont(12);

    _shopActionV = [[ShopActionView alloc]init];
    [self addSubview:_shopActionV];
    _shopActionV.delegate = self;


}

- (void)initShopView:(ShopGoodModel *)data{

    for (int i=0 ; i<data.goodArr.count; i++) {
        GoodCarModel *good = data.goodArr[i];
        ShopOrderView *shoporderV = [[ShopOrderView alloc]initWithFrame:CGRectMake(0, CGRectYH(_dateLb)+5+__kWidth/4*i, __kWidth, __kWidth/4)];
        [self addSubview:shoporderV];
        if (good.goodImg&&good.goodImg.length!=0) {
            shoporderV.goodIV.imageURL = [NSURL URLWithString:good.goodImg];
        }else{
        shoporderV.goodIV.backgroundColor = LH_RandomColor;
        }
        shoporderV.goodNameLb.text =  good.goodName;
        shoporderV.moneyLb.text = [NSString stringWithFormat:@"¥%@",good.goodMoney];
        shoporderV.quoteLb.text = good.goodQuote;
        NSMutableAttributedString *quoteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",shoporderV.quoteLb.text]];
        [quoteStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, quoteStr.length)];
        shoporderV.quoteLb.attributedText = quoteStr;//加横线
        shoporderV.orderNOLb.text = [NSString stringWithFormat:@"订单号：%@",good.orderNo];
        shoporderV.countLb.text = [NSString stringWithFormat:@"x%@",good.goodcount];
        self.orderNumber = good.orderNo;
        _orderId = good.goodId;
    }
    
    _totalLb.frame = CGRectMake(__kWidth/4-5,__kWidth/4*data.goodArr.count+40+10, 50, 20);

    _allPayLb.frame = CGRectMake(CGRectXW(_totalLb), __kWidth/4*data.goodArr.count+40+10, __kWidth-40-15-__kWidth/4, 20);

    _shopActionV.frame = CGRectMake(0, CGRectYH(_allPayLb)+10, __kWidth, 40);
    if ([data.status isEqualToString:@"待付款"]) {
        [_shopActionV initWith:0];
    }else if([data.status isEqualToString:@"已取消"]){
        [_shopActionV initWith:1];
    }else if ([data.status isEqualToString:@"已付款"]){
        [_shopActionV initWith:2];
    }else if ([data.status isEqualToString:@"已发货"]){
        [_shopActionV initWith:3];
    }else{
        [_shopActionV initWith:4];
    }
}

-(void)shopAction:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    [self.delegate orderAction:_orderId action:sender];
    [self.delegate orderActionWithNumber:_orderId action:sender];
}


@end
