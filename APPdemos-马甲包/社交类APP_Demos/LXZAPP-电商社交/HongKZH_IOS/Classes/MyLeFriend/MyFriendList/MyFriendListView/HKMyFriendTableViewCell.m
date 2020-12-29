//
//  HKMyFriendTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFriendTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "HKLevelView.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKMyFriendTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet HKLevelView *level;

@end

@implementation HKMyFriendTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super awakeFromNib];
}
+(instancetype)myFriendTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKMyFriendTableViewCell";
    
    HKMyFriendTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKMyFriendTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (IBAction)headViewClick:(id)sender {
    if (self.delegete  && [self.delegete respondsToSelector:@selector(pushUserDetailControllerWithModel:)]) {
        [self.delegete  pushUserDetailControllerWithModel:self.friendM];
    }
}
-(void)setFriendM:(HKFriendModel *)friendM{
    _friendM = friendM;
    [self.headBtn hk_setBackgroundImageWithURL:friendM.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.nameLabel.text = friendM.name;
    [self.level setSet:friendM.sex.intValue level:(int)friendM.level];
}
@end
