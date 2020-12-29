//
//  HKCloseOrderTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCloseOrderTableViewCell.h"

@implementation HKCloseOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
+(instancetype)closeOrderTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKCloseOrderTableViewCell";
    
    HKCloseOrderTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKCloseOrderTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
@end
