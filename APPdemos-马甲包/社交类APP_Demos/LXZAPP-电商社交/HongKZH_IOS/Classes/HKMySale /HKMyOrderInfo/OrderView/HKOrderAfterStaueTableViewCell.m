//
//  HKOrderAfterStaueTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderAfterStaueTableViewCell.h"
#import "HKOrderFromInfoRespone.h"
@interface HKOrderAfterStaueTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *afterTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HKOrderAfterStaueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
+(instancetype)orderAfterStaueTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKOrderAfterStaueTableViewCell";
    
    HKOrderAfterStaueTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKOrderAfterStaueTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setOrderInfoModel:(HKOrderFromInfoRespone *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    NSDictionary*dict = orderInfoModel.data.afterList.firstObject;
    self.timeLabel.text = dict[@"createDate"];
    self.afterTitle.text = dict[@"name"];
}
@end
