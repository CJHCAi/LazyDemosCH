//
//  HKSearchTypeTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchTypeTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "HKLESearchBaseModel.h"
#import "UIButton+ZSYYWebImage.h"
#import "LEFriendSearchModel.h"
#import "HKFriendRespond.h"
#import "LEFriendDbManage.h"
@interface HKSearchTypeTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLaebl;

@end

@implementation HKSearchTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)searchTypeCellWithTableView:(UITableView*)tableView{
    HKSearchTypeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"HKSearchTypeTableViewCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKSearchTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HKSearchTypeTableViewCell"]; //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"HKSearchTypeTableViewCell"];
        
    }
    return cell;
}
-(void)setModelWithType:(int)type andModel:(NSObject*)Model{
    
    if (type == 0) {
        self.nameTop.constant = 17;
        self.titleTextLaebl.hidden = YES;
    }else{
        self.nameTop.constant = 7;
        self.titleTextLaebl.hidden = NO;
    }
    if (type == 0) {
        FriendsModel*frindM = (FriendsModel*)Model;
        [self.headBtn zsYY_setBackgroundImageWithURL:frindM.headImg forState:UIControlStateNormal placeholder:kPlaceholderImage];
        self.nameLabel.text = frindM.name;
    }else if(type == 2){
        CirclesModel* cirModel = (CirclesModel*)Model;
        [self.headBtn zsYY_setBackgroundImageWithURL:cirModel.coverImgSrc forState:UIControlStateNormal placeholder:kPlaceholderImage];
        self.nameLabel.text = cirModel.circleName;
        self.titleTextLaebl.text = cirModel.categoryName;
    }else if (type == 1){
        RCSearchConversationResult*messageM = (RCSearchConversationResult*)Model;
        HKFriendModel*queryM = [[HKFriendModel alloc]init];
        queryM.uid = messageM.conversation.targetId;
         HKFriendModel *userModel  = (HKFriendModel*)[[LEFriendDbManage sharedZSDBManageBaseModel]queryWithModel:queryM];
        self.nameLabel.text = userModel.name;
        self.titleTextLaebl.text = [NSString stringWithFormat:@"%d条相关消息",messageM.matchCount];
        [self.headBtn zsYY_setBackgroundImageWithURL:userModel.headImg forState:0 placeholder:kPlaceholderHeadImage];
        
    }
}
-(void)setMessageM:(RCMessage *)messageM{
    _messageM = messageM;
    HKFriendModel*queryM = [[HKFriendModel alloc]init];
    queryM.uid = messageM.targetId;
    HKFriendModel *userModel  = (HKFriendModel*)[[LEFriendDbManage sharedZSDBManageBaseModel]queryWithModel:queryM];
    self.nameLabel.text = userModel.name;
    [self.headBtn zsYY_setBackgroundImageWithURL:userModel.headImg forState:0 placeholder:kPlaceholderImage];
//    self.titleTextLaebl.text = messageM.;
}

@end
