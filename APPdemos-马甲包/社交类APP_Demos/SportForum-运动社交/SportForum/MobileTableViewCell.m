//
//  MobileTableViewCell.m
//  SportForum
//
//  Created by liyuan on 1/7/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "MobileTableViewCell.h"
#import "CSButton.h"
#import "UIImageView+WebCache.h"

@implementation MobileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
        imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
        
        _viewBoard = [[UIImageView alloc]init];
        [_viewBoard setImage:imgBk];
        [self.contentView addSubview:_viewBoard];
        
        _userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_userImageView];
        
        _sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_sexTypeImageView];
        
        _lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbAge];
        
        _lbNickName = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbNickName];
        
        _imgLevelBK = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_imgLevelBK];
        
        _lbLevel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbLevel];
        
        _lbScore = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbScore];
        
        _btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btnAction];
    }
    
    return self;
}

-(void)setUserInfoItem:(UserInfo *)userInfoItem {
    _userInfoItem = userInfoItem;
    
    _viewBoard.frame = CGRectMake(5, 1, 300, 50);
    
    _userImageView.frame = CGRectMake(8, 3, 40, 40);
    _userImageView.layer.cornerRadius = 5.0;
    _userImageView.layer.masksToBounds = YES;
    
    _lbNickName.backgroundColor = [UIColor clearColor];
    _lbNickName.text = _userInfoItem.nikename;
    _lbNickName.textColor = [UIColor blackColor];
    _lbNickName.font = [UIFont boldSystemFontOfSize:12];
    _lbNickName.textAlignment = NSTextAlignmentLeft;
    
    _lbScore.backgroundColor = [UIColor clearColor];
    _lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];//[UIColor colorWithRed:176.0 / 255.0 green:150.0 / 255.0 blue:32.0 / 255.0 alpha:1.0];
    _lbScore.font = [UIFont boldSystemFontOfSize:12];
    _lbScore.textAlignment = NSTextAlignmentLeft;

    _btnAction.frame = CGRectMake(_viewBoard.frame.size.width - 80, 7, 75, 35);
    [_btnAction.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    _btnAction.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnAction setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [_btnAction setBackgroundImage:[UIImage imageNamed:@"bluebutton"] forState:UIControlStateNormal];

    if (userInfoItem.sex_type == nil) {
        [_btnAction setTitle:@"邀请" forState:UIControlStateNormal];
        _btnAction.actionBlock = _inviteBlock;
        
        [_userImageView setImage:[UIImage imageNamed:_userInfoItem.profile_image]];
        
        _userImageView.hidden = YES;
        _sexTypeImageView.hidden = YES;
        _lbAge.hidden = YES;
        _lbLevel.hidden = YES;
        _imgLevelBK.hidden = YES;
        
        _lbNickName.frame = CGRectMake(10, 3, 150, 20);
        
        _lbScore.text = _userInfoItem.phone_number;
        _lbScore.frame = CGRectMake(CGRectGetMinX(_lbNickName.frame), CGRectGetMaxY(_userImageView.frame) - 22, 150, 20);
    }
    else
    {
        [_btnAction setTitle:@"关注" forState:UIControlStateNormal];
        _btnAction.actionBlock = _attentionBlock;

        [_userImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoItem.profile_image]
                          placeholderImage:[UIImage imageNamed:@"mobile-contact-2"]];
        
        _userImageView.hidden = NO;
        _sexTypeImageView.hidden = NO;
        _lbAge.hidden = NO;
        _lbLevel.hidden = NO;
        _imgLevelBK.hidden = NO;
        
        _sexTypeImageView.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 8, 3, 40, 18);
        [_sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_userInfoItem.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
        _sexTypeImageView.backgroundColor = [UIColor clearColor];
        
        _lbAge.backgroundColor = [UIColor clearColor];
        _lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_userInfoItem.birthday];
        _lbAge.textColor = [UIColor whiteColor];
        _lbAge.font = [UIFont systemFontOfSize:10];
        _lbAge.frame = CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) - 25, 5, 20, 10);
        _lbAge.textAlignment = NSTextAlignmentRight;
        
        UIImage *imgLev = [UIImage imageNamed:@"level-bg"];
        _imgLevelBK.frame = CGRectMake(CGRectGetMinX(_sexTypeImageView.frame), CGRectGetMaxY(_userImageView.frame) - 18, imgLev.size.width, imgLev.size.height);
        _imgLevelBK.image = imgLev;
        
        //_lbLevel.backgroundColor = [UIColor colorWithPatternImage:imgLev];
        //_lbLevel.layer.contents = (id) imgLev.CGImage;
        _lbLevel.backgroundColor = [UIColor clearColor];
        _lbLevel.text = [NSString stringWithFormat:@"LV.%lu", (unsigned long)_userInfoItem.proper_info.rankLevel];
        _lbLevel.textColor = [UIColor whiteColor];
        _lbLevel.font = [UIFont italicSystemFontOfSize:10];
        _lbLevel.frame = CGRectMake(CGRectGetMinX(_sexTypeImageView.frame), CGRectGetMaxY(_userImageView.frame) - 18, imgLev.size.width, imgLev.size.height);
        _lbLevel.textAlignment = NSTextAlignmentCenter;
        
        _lbNickName.frame = CGRectMake(CGRectGetMaxX(_lbLevel.frame) + 8, 3, 150, 20);
        
        _lbScore.text = [NSString stringWithFormat:@"总分数：%lu", (unsigned long)_userInfoItem.proper_info.rankscore];
        _lbScore.frame = CGRectMake(CGRectGetMinX(_lbNickName.frame), CGRectGetMaxY(_userImageView.frame) - 22, 150, 20);
    }
}

+(CGFloat)heightOfCell{
    return 52;
}

@end