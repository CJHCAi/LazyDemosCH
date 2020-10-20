
//
//  GoodShopView.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodShopView.h"
#import "GoodColorView.h"
#import "GoodStyleView.h"
#import "GoodNumberView.h"

@interface GoodShopView()<GoodColorViewDelegate,GoodStyleViewDelegate,GoodNumberViewDelegate>
/**
 *  款式选择视图
 */
@property (strong,nonatomic) GoodStyleView *goodStyleV;
/**
 *  颜色选择视图
 */
@property (strong,nonatomic) GoodColorView *goodColorV;
/**
 *  数量选择视图
 */
@property (strong,nonatomic) GoodNumberView *goodNumberV;

@property (strong,nonatomic) NSArray<GoodStyleModel*> *styleArr;

@property (strong,nonatomic) NSArray<GoodColorModel*> *colorArr;
@end

@implementation GoodShopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initView{
    _styleArr = [NSArray array];
    _colorArr = [NSArray array];
    _goodPayModel = [[GoodPayModel alloc]init];
    _goodNameLb = [[UILabel alloc]init];
    [self addSubview:_goodNameLb];
    _goodNameLb.font = MFont(14);
    _goodNameLb.textColor = LH_RGBCOLOR(90, 90, 90);
    _goodNameLb.textAlignment = NSTextAlignmentLeft;
    _goodNameLb.numberOfLines = 0;

    _payMoneyLb = [[UILabel alloc]init];
    [self addSubview:_payMoneyLb];
    _payMoneyLb.font = MFont(15);
    _payMoneyLb.textAlignment = NSTextAlignmentLeft;
    _payMoneyLb.textColor = [UIColor redColor];

    _quoteLb = [[UILabel alloc]init];
    [self addSubview:_quoteLb];
    _quoteLb.font = MFont(10);
    _quoteLb.textColor = [UIColor lightGrayColor];
    _quoteLb.textAlignment = NSTextAlignmentLeft;

    _goodColorV = [[GoodColorView alloc]initWithFrame:CGRectMake(0, CGRectYH(_quoteLb)+5, __kWidth, 20)];
//    [self addSubview:_goodColorV];
//    _goodColorV.delegate = self;


    _goodStyleV = [[GoodStyleView alloc]initWithFrame:CGRectMake(0, CGRectYH(_quoteLb)+5, __kWidth, 25)];
    [self addSubview:_goodStyleV];
    _goodStyleV.delegate = self;


    _goodNumberV = [[GoodNumberView alloc]initWithFrame:CGRectMake(0, CGRectYH(_quoteLb)+30, __kWidth, 25)];
    [self addSubview:_goodNumberV];
    _goodNumberV.delegate = self;


}
-(void)getGoodData:(GoodDetailModel *)sender{
     [_goodColorV initBtnsArray:sender.colorList];
      [_goodStyleV initStyleBtns:sender.styleList];
    _colorArr = sender.colorList;
    _styleArr = sender.styleList;
}

#pragma mark -GoodNumberViewDelegate
-(void)changeCountLb:(UILabel *)text action:(UIButton *)sender{
    NSInteger count = [text.text integerValue];
    if (sender.tag -90) {
        count ++;
    }else{
        if (count>1) {
            count--;
        }
    }
    _goodPayModel.goodCount = [NSString stringWithFormat:@"%ld",(long)count];
    text.text = [NSString stringWithFormat:@"%ld",(long)count];
}

#pragma mark -GoodColorViewDelegate
-(void)goodColorChoose:(UIButton *)sender{
    _goodPayModel.goodColor = _colorArr[sender.tag].goodColor;
}
#pragma mark -GoodStyleViewDelegate
-(void)goodStyleChoose:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    _goodPayModel.goodStyle = _styleArr[sender.tag -11].goodStyle;
    
    
    NSArray *detaiArr = [USERDEFAULT objectForKey:kNSUserDefaultsgoodsDetail][_goodPayModel.goodStyle];
    _goodPayModel.goodStyleId = [NSString stringWithFormat:@"%@",detaiArr[0]];;
    _quoteLb.text = [NSString stringWithFormat:@"%@",detaiArr[1]];
    _payMoneyLb.text = [NSString stringWithFormat:@"¥%@",detaiArr[2]];
    
    NSMutableAttributedString *quoteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",_quoteLb.text]];
    [quoteStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, quoteStr.length)];
    _quoteLb.attributedText = quoteStr;//加横线
    

    
    
}
#pragma mark ==更新约束==
- (void)updateFrame{
    [self heightWithLabel:_goodNameLb];
    _payMoneyLb.frame = CGRectMake(15, CGRectYH(_goodNameLb)+5, 80, 15);
    _quoteLb.frame = CGRectMake(CGRectXW(_payMoneyLb), CGRectYH(_goodNameLb)+10, 80, 10);
    CGFloat height =0.0;
    if (_colorArr.count%4) {
        height = 25*(_colorArr.count/4+1);
    }else{
        height = 25*(_colorArr.count/4);
    }
    _goodColorV.frame = CGRectMake(0, CGRectYH(_quoteLb)+5, __kWidth, height);
    _goodStyleV.frame = CGRectMake(0, CGRectYH(_quoteLb)+5, __kWidth, 25*(_styleArr.count/2+_styleArr.count%2));
    _goodNumberV.frame = CGRectMake(0, CGRectYH(_goodStyleV), __kWidth, 25);

    _height = CGRectYH(_goodStyleV)+30+5;
}

#pragma mark ==更新文本高度==
-(void)heightWithLabel:(UILabel *)sender{
    NSString *str = sender.text;
    CGFloat height = 0.0;
    if (str.length*14>__kWidth-30) {
        for (int i=0; i<str.length*14/(__kWidth-30)+1; i++) {
            if (str.length*14>(__kWidth-30)*i&&str.length*14<(__kWidth-30)*(i+1)) {
                height = (i+1)*17.0;
            }
        }
    }else{
        height = 15.0;
    }

    sender.frame = CGRectMake(15, 15, __kWidth-30, height);

}

@end
