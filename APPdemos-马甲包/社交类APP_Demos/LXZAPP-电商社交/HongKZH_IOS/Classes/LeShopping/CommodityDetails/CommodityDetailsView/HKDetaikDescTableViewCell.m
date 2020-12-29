//
//  HKDetaikDescTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetaikDescTableViewCell.h"
#import "CommodityDetailsRespone.h"
@interface HKDetaikDescTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleVIew;
@property (weak, nonatomic) IBOutlet UILabel *RMB;
@property (weak, nonatomic) IBOutlet UILabel *leCoin;
@property (weak, nonatomic) IBOutlet UILabel *promotion;
@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end

@implementation HKDetaikDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setRespone:(CommodityDetailsRespone *)respone{
    _respone = respone;
    self.titleVIew.text = respone.data.title;
    self.RMB.text = [NSString stringWithFormat:@"%.2f",respone.data.integral] ;
    self.leCoin.text = [NSString stringWithFormat:@"%ld",respone.data.lb] ;
    self.volumeLabel.text = [NSString stringWithFormat:@"月销%ld笔",respone.data.orders];
}
@end
