//
//  HKLogisticsInfoTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLogisticsInfoTableViewCell.h"
#import "HKLogisticsInfoModel.h"
@interface HKLogisticsInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *context;

@end

@implementation HKLogisticsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)logisticsInfoTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKLogisticsInfoTableViewCell";
    
    HKLogisticsInfoTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKLogisticsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKLogisticsInfoModel *)model{
    _model = model;
    self.context.text = model.context;
    self.timeLabel.text = model.time;
}
@end
