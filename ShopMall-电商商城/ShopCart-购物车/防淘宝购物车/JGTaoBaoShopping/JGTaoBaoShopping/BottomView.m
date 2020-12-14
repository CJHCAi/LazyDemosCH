//
//  BottomView.m
//  仿淘宝
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "BottomView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Image(name) [UIImage imageNamed:name]
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


@interface BottomView ()
{
    UIButton *SelectedAll;
    
    UILabel *AllPrice;
}
@end

@implementation BottomView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
     
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = COLOR(230, 230, 230, 1);
        [self addSubview:line];
        
        SelectedAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [SelectedAll setImage:Image(@"check_box_nor") forState:UIControlStateNormal];
        SelectedAll.frame = CGRectMake(5, 7, 30, 30);
        [SelectedAll addTarget:self action:@selector(touchSelectedALL) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:SelectedAll];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(SelectedAll.frame), 12, 40, 20)];
        label1.text = @"全选";
        label1.font = [UIFont systemFontOfSize:15];
        [self addSubview:label1];
        
        //结算
        UIButton *BalanceAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        [BalanceAccount setTitle:@"结算" forState:UIControlStateNormal];
        [BalanceAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        BalanceAccount.backgroundColor = [UIColor orangeColor];
        BalanceAccount.frame = CGRectMake(self.frame.size.width/3 * 2 + 10, 0, self.frame.size.width/3 - 10, 44);
        BalanceAccount.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:BalanceAccount];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(BalanceAccount.frame) - 50, 12, 50, 20)];
        label2.text = @"不含运费";
        label2.font = [UIFont systemFontOfSize:10];
        label2.textColor = [UIColor grayColor];
        [self addSubview:label2];
        
        //合计商品价格
        AllPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 12, self.frame.size.width - CGRectGetMaxX(label1.frame) - (self.frame.size.width - CGRectGetMinX(label2.frame)) - 10, 20)];
        AllPrice.text = @"合计: ￥0";
        AllPrice.font = [UIFont systemFontOfSize:13];
        AllPrice.textAlignment = UITextLayoutDirectionRight;
        [self addSubview:AllPrice];
        
        AllPrice.attributedText = [self String:AllPrice.text RangeString:@"￥0"];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Refresh:) name:@"BottomRefresh" object:nil];
        
    }
    return self;

}

-(void)init:(NSDictionary *)dict GoodsData:(NSMutableArray *)goods
{
    [SelectedAll setImage:Image(dict[@"SelectIcon"]) forState:UIControlStateNormal];
    
    _AllSelected = [dict[@"SelectedType"] boolValue];
    
    NSLog(@"%@",dict[@"SelectedType"]);
    
    [self setMoney:goods];

}
-(void)Refresh:(NSNotification *)info
{
    [self setMoney:info.userInfo[@"Data"]];

}
-(void)setMoney:(NSMutableArray *)data
{
    int index1 = 0;
    int index2 = 0;

    double goodsSum = 0.0;
    
    for (NSInteger i = 0; i < data.count; i ++) {
        NSArray *arr = data[i];
        for (NSInteger j = 0 ; j < arr.count; j ++) {
            index1 ++;
            NSDictionary *goodsDict = arr[j];
            if ([goodsDict[@"Type"] isEqualToString:@"1"]) {
                index2 ++;
                double product;
                double Price = [goodsDict[@"GoodsPrice"] doubleValue];
                NSInteger goodsNum = [goodsDict[@"GoodsNumber"] integerValue];
                
                product = Price * goodsNum;
                
                goodsSum = goodsSum + product;
            }
        }
    }
    
    NSString *String  = [NSString stringWithFormat:@"合计: ￥%.2f",goodsSum];
    
    AllPrice.attributedText = [self String:String RangeString:[NSString stringWithFormat:@"￥%.2f",goodsSum]];
    if (index2 == index1 ) {
        [SelectedAll setImage:Image(@"check_box_sel") forState:UIControlStateNormal];
    }
}

//计算总价
-(void)touchSelectedALL
{

    if (_AllSelected) {
        [self.delegate DidSelectedAllGoods];
        [SelectedAll setImage:Image(@"check_box_sel") forState:UIControlStateNormal];
    }else{
        [self.delegate NoDidSelectedAllGoods];
        [SelectedAll setImage:Image(@"check_box_nor") forState:UIControlStateNormal];
    }
    
    _AllSelected = !_AllSelected;

}

- (NSMutableAttributedString *)String:(NSString *)String RangeString:(NSString *)RangeString
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:String];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:RangeString];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
    
    return hintString;
}

@end
