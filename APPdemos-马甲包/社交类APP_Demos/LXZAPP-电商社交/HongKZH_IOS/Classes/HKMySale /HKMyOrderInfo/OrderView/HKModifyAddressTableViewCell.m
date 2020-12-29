//
//  HKModifyAddressTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKModifyAddressTableViewCell.h"
#import "ChinaArea.h"
@interface HKModifyAddressTableViewCell()
@property (weak, nonatomic) IBOutlet UITextField *consignee;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextView *detailedAddress;

@end

@implementation HKModifyAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)modifyAddressTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKModifyAddressTableViewCell";
    
    HKModifyAddressTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKModifyAddressTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    self.consignee.text = model.address.consignee;
    self.phone.text = model.address.phone;

    self.area.text = [ChinaArea getAddress:model.address.provinceId city:model.address.cityId area:model.address.areaId];
    self.detailedAddress.text = model.address.address;
}
- (IBAction)selectCity:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showSelectCity)]) {
        [self.delegate showSelectCity];
    }
}
@end
