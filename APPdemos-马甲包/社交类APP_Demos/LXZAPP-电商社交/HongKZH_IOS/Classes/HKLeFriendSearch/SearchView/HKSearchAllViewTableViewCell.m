//
//  HKSearchAllViewTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchAllViewTableViewCell.h"
#import "HKSearchView.h"
@interface HKSearchAllViewTableViewCell()<HKSearchViewDelegate>
@property (nonatomic, strong)HKSearchView*searchV ;
@end

@implementation HKSearchAllViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)searchAllViewTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKSearchAllViewTableViewCell";
    HKSearchAllViewTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKSearchAllViewTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (IBAction)searchFriend:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchFriend)]) {
        [self.delegate searchFriend];
    }
}
- (IBAction)seachMessage:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(seachMessage)]) {
        [self.delegate seachMessage];
    }
}

- (IBAction)searchcCicle:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchcCicle)]) {
        [self.delegate searchcCicle];
    }
}

@end
