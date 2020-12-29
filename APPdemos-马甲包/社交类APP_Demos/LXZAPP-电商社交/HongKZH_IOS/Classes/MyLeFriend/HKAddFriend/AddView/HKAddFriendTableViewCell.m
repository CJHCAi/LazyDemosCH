//
//  HKAddFriendTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAddFriendTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "HKLevelView.h"
#import "HKAddHeadViewModel.h"
#import "UIView+BorderLine.h"
@interface HKAddFriendTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followL;
@property (weak, nonatomic) IBOutlet UILabel *fansL;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet HKLevelView *levelView;

@end

@implementation HKAddFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    [self.attentionBtn borderForColor:self.attentionBtn.titleLabel.textColor borderWidth:1 borderType:UIBorderSideTypeAll];
}
+(instancetype)addFriendCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKAddFriendTableViewCell";
    
    HKAddFriendTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKAddFriendTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setFriendM:(FriendList *)friendM{
    _friendM = friendM;
    [self.headIcon zsYY_setBackgroundImageWithURL:friendM.headImg forState:0 placeholder:kPlaceholderImage];
    self.nameLabel.text = friendM.name;
    self.followL.text = [NSString stringWithFormat:@"关注%ld人",friendM.gcount];
    self.fansL.text = [NSString stringWithFormat:@"粉丝%ld人",friendM.fcount];
    [self.levelView setSet:friendM.sex.intValue level:(int)friendM.level];
    if (_friendM.attentionType == 0) {
        [self.attentionBtn setTitle:@"关注" forState:0];
    }else{
        [self.attentionBtn setTitle:@"取消关注" forState:0];
    }
}
- (IBAction)headClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushUserDetail:)]) {
        [self.delegate pushUserDetail:self.friendM];
    }
}
- (IBAction)attention:(UIButton *)sender {
  
    if (self.friendM.attentionType == 1) {
        [HKAddHeadViewModel followDelete:@{@"loginUid":HKUSERLOGINID,@"followUserId":self.friendM.uid} success:^(BOOL isSuc) {
            if (isSuc) {
                self.friendM.attentionType = 0;
                self.friendM.fcount -= 1;
                [self setFriendM:self.friendM];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"取消关注"];
            }else {
              [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
              [SVProgressHUD showErrorWithStatus:@"操作失败"];
            }
        }];
    }else{
    [HKAddHeadViewModel followAdd:@{@"loginUid":HKUSERLOGINID,@"followUserId":self.friendM.uid} success:^(BOOL isSuc) {
        if (isSuc) {
            self.friendM.attentionType = 1;
            self.friendM.fcount += 1;
            [self setFriendM:self.friendM];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(attentionSomeOneWithModel:andIndexPath:)]) {
                [self.delegate attentionSomeOneWithModel:self.friendM andIndexPath:self.indexPath];
            }
        }else {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }
    }];
    }
   
}
@end
