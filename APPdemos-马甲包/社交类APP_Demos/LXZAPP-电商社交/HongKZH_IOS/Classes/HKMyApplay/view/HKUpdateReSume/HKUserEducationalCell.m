//
//  HKUserEducationalCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserEducationalCell.h"
#import "HKUserEducationalInnerCell.h"

@implementation HKUserEducationalCell

- (void)setItems:(NSArray *)items {
    [super setItems:items];
    CGFloat height = items.count*71+52;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self.tableView reloadData];
    [self layoutIfNeeded];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.items.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *button = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                        frame:CGRectZero
                                                        taget:self
                                                       action:nil
                                                   supperView:cell.contentView];
        [button setTitle:@"添加教育经历" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"jlfbtj"] forState:UIControlStateNormal];
        button.titleLabel.font = PingFangSCRegular14;
        [button setTitleColor:UICOLOR_HEX(0x4090f7) forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        [button setUserInteractionEnabled:NO];
        return cell;
    } else {
        HK_UserEducationalData *data = self.items[indexPath.row];
        HKUserEducationalInnerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKUserEducationalInnerCell class])];
        if (cell == nil) {
            cell = [HKUserEducationalInnerCell userEducationalInnerCellWithBlock:^{
                if (self.block) {
                    HK_UserEducationalData *data1 = self.items[indexPath.row];
                    self.block(indexPath.row,data1);
                }
            } data:data];
        }
        cell.data = data;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.items.count) {
        return 52;
    } else {
        return 71;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.items.count) {
        if (self.addResumeBlock) {
            self.addResumeBlock();
        }
    }
}


@end
