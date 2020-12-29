//
//  HKAddreesTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddreesTableViewCell.h"
#import "HKMobileRequestModel.h"
@interface HKAddreesTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@end

@implementation HKAddreesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)addreesTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKAddreesTableViewCell";
    
    HKAddreesTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKAddreesTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKMobileModel *)model{
    _model = model;
    switch (model.state.intValue) {
        case 1:{
            [self.inviteBtn setTitle:@"邀请" forState:0];
            self.inviteBtn.userInteractionEnabled = YES;
        }
            break;
        case 2:{
            [self.inviteBtn setTitle:@"好友" forState:0];
            self.inviteBtn.userInteractionEnabled = NO;
        }
            break;
        case 3:{
            [self.inviteBtn setTitle:@"已关注" forState:0];
            self.inviteBtn.userInteractionEnabled = NO;
        }
            break;
        case 4:{
            [self.inviteBtn setTitle:@"关注" forState:0];
            self.inviteBtn.userInteractionEnabled = YES;
        }
            break;
        default:
            break;
    }
    
    
}
-(void)setName:(NSString *)name{
    _name = name;
    self.nameL.text = name;
}
@end
