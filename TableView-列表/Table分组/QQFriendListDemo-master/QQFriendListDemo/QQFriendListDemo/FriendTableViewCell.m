//
//  FriendTableViewCell.m
//  核心动画
//
//  Created by 朱伟阁 on 2019/1/27.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "FriendModel.h"

@implementation FriendTableViewCell

+ (instancetype)friendTableViewCellWithTableView:(UITableView *)tableview{
    FriendTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([FriendTableViewCell class])];
    if(cell == nil){
        cell = [[FriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([FriendTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setFriendModel:(FriendModel *)friendModel{
    _friendModel = friendModel;
    self.imageView.image = [UIImage imageNamed:friendModel.icon];
    self.textLabel.text = friendModel.name;
    self.detailTextLabel.text = friendModel.intro;
    NSString *isVip = [NSString stringWithFormat:@"%@",friendModel.vip];
    if([isVip isEqualToString:@"1"]){
        self.detailTextLabel.textColor = [UIColor redColor];
    }else{
        self.detailTextLabel.textColor = [UIColor blackColor];
    }
}

@end
