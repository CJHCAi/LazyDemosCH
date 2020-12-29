//
//  HKMarketDataTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMarketDataTableViewCell.h"
#import "MarketDataRespone.h"
@interface HKMarketDataTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *leTreasure;
@property (weak, nonatomic) IBOutlet UILabel *treasureNum;
@property (weak, nonatomic) IBOutlet UILabel *leDouNum;
@property (weak, nonatomic) IBOutlet UILabel *leCoin;

@end

@implementation HKMarketDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
}
-(void)setRespone:(MarketDataRespone *)respone{
    _respone = respone;
    self.treasureNum.text = [NSString stringWithFormat:@"%ld",respone.data.lobo];
    self.leDouNum.text =[NSString stringWithFormat:@"%ld",respone.data.bean];
    self.leCoin.text = [NSString stringWithFormat:@"%.2lf",respone.data.integral];;
}
@end
