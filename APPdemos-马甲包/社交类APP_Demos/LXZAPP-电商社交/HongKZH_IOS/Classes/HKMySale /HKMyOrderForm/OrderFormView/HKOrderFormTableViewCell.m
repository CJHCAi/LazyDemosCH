//
//  HKOrderFormTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderFormTableViewCell.h"
#import "UIButton+ZSYYWebImage.h"
#import "HKOrderFormViewModel.h"
@interface HKOrderFormTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *limitTime;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation HKOrderFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)orderFormTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKOrderFormTableViewCell";
    
    HKOrderFormTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKOrderFormTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKSellerorderModel *)model{
    _model = model;
    if (model.subList.count>0) {
        SubModel *subM = model.subList.firstObject;
        [self.iconView zsYY_setBackgroundImageWithURL:subM.imgSrc forState:0 placeholder:kPlaceholderImage];
    }else{
        [self.iconView setBackgroundImage:kPlaceholderImage forState:0];
    }
    
    self.orderNumber.text = model.orderNumber;
    self.consignee.text = model.consignee;
    self.limitTime.text = model.createDate;
    self.stateLabel.text = [HKOrderFormViewModel orderFormWithStaue:model.state.intValue];
}
@end
