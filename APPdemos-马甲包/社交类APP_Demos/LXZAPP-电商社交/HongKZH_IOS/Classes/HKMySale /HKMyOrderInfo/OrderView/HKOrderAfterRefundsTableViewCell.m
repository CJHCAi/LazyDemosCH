//
//  HKOrderAfterRefundsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderAfterRefundsTableViewCell.h"

@implementation HKOrderAfterRefundsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
+(instancetype)orderAfterRefundsTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKOrderAfterRefundsTableViewCell";
    
    HKOrderAfterRefundsTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKOrderAfterRefundsTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
