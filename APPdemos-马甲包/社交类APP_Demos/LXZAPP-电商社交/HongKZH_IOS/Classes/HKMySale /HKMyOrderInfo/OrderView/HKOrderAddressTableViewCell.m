//
//  HKOrderAddressTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderAddressTableViewCell.h"
@interface HKOrderAddressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliver;
@property (weak, nonatomic) IBOutlet UIView *deliverView;
@property (weak, nonatomic) IBOutlet UIButton *topnum;
@property (weak, nonatomic) IBOutlet UILabel *deliverTime;
@property (weak, nonatomic) IBOutlet UIButton *modifyImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@end

@implementation HKOrderAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)orderAddressTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKOrderAddressTableViewCell";
    
    HKOrderAddressTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKOrderAddressTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
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
    self.name.text = model.address.consignee;
    self.phone.text = model.phone;
    self.address.text = model.address.address;
    OrderFormStatue staue = (OrderFormStatue)model.state.intValue;
    if (model.deliverTime.length>0) {
        self.deliverTime.text = model.deliverTime;
    }else{
        self.deliverTime.text = @"";
    }
    if (staue == OrderFormStatue_cnsignment||staue == OrderFormStatue_consignee||staue == OrderFormStatue_finish) {
        self.deliver.constant = 82;
        self.deliverView.hidden = NO;
        self.modifyBtn.hidden = YES;
        self.modifyImage.hidden = YES;
    }else{
        self.modifyBtn.hidden = NO;
        self.modifyImage.hidden = NO;
        self.deliver.constant = 0;
         self.deliverView.hidden = YES;
    }
}
- (IBAction)MaskmodifyAddress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(modifyTheAddress)]) {
        [self.delegate modifyTheAddress];
    }
}
- (IBAction)lookLogistics:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(toVcLookLogistics)]) {
        [self.delegate toVcLookLogistics];
    }
}
@end
