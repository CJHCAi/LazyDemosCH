//
//  MobileTableViewCell.h
//  SportForum
//
//  Created by liyuan on 1/7/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AttentionClickBlock)(void);
typedef void (^InviteClickBlock)(void);

@interface MobileTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UIImageView *sexTypeImageView;
@property(nonatomic, strong) UILabel *lbNickName;
@property(nonatomic, strong) UILabel *lbScore;
@property(nonatomic, strong) UILabel *lbAge;
@property(nonatomic, strong) UILabel *lbLevel;
@property(nonatomic, strong) UIImageView *imgLevelBK;
@property(nonatomic, strong) UIImageView *viewBoard;
@property(nonatomic, strong) CSButton *btnAction;
@property(nonatomic, strong) UserInfo *userInfoItem;
@property(nonatomic, strong) AttentionClickBlock attentionBlock;
@property(nonatomic, strong) InviteClickBlock inviteBlock;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
