//
//  HKLogisticsNameTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLogisticsNameTableViewCell.h"
@interface HKLogisticsNameTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *courierNumber;
@property (weak, nonatomic) IBOutlet UILabel *courier;

@end

@implementation HKLogisticsNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)logisticsNameTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKLogisticsNameTableViewCell";
    
    HKLogisticsNameTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKLogisticsNameTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    self.courier.text = model.courier;
    self.courierNumber.text = model.courierNumber;
}
@end
