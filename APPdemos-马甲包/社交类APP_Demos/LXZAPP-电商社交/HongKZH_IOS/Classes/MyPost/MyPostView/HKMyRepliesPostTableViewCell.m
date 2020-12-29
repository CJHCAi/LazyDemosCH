//
//  HKMyRepliesPostTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyRepliesPostTableViewCell.h"
@interface HKMyRepliesPostTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HKMyRepliesPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)myRepliesPostTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKMyRepliesPostTableViewCell";
    
    HKMyRepliesPostTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKMyRepliesPostTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(MyRepliesPostsModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"回复%@:%@",model.userName,model.content];
    self.timeLabel.text = model.createDate;
}
-(void)setDelModel:(HKMyDelPostsModel *)delModel{
    _delModel = delModel;
    if (delModel.type.intValue == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"主题帖：%@",delModel.title];
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"主题帖：原贴：%@",delModel.title];
    }
    self.timeLabel.text = delModel.createDate;
}
@end
