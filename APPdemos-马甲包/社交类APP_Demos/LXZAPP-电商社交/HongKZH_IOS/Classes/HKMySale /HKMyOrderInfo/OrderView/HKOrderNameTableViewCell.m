//
//  HKOrderNameTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderNameTableViewCell.h"
#import "UIButton+ZSYYWebImage.h"
#import "ZSUserHeadBtn.h"
#import "HKOrderFormViewModel.h"
@implementation HKOrderNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)orderNameTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKOrderNameTableViewCell";
    
    HKOrderNameTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKOrderNameTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderImage];
    self.nameLabel.text  = model.name;
    self.staue.text = [HKOrderFormViewModel orderFormWithStaue:model.state.intValue];
}
@end
