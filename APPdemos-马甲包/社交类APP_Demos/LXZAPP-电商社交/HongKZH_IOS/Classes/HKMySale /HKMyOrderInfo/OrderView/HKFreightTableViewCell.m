//
//  HKFreightTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFreightTableViewCell.h"
@interface HKFreightTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *feightLabel;

@end

@implementation HKFreightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)freightTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKFreightTableViewCell";
    
    HKFreightTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKFreightTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setFreight:(NSInteger)freight{
    _freight = freight;
    self.feightLabel.text = [NSString stringWithFormat:@"%ld",freight];
}
@end
