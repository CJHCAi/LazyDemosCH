//
//  RelatedPeopleCell.m
//  SportForum
//
//  Created by liyuan on 14-9-15.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "RelatedPeopleCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUtility.h"

@implementation RelatedPeopleCell

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
        
        _viewRelated = [[UIImageView alloc]init];
        [_viewRelated setImage:imgBk];
        [self.contentView addSubview:_viewRelated];
        
        _userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_userImageView];
        
        _sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_sexTypeImageView];
        
        _lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_lbAge];
        
        //_imgLevelBK = [[UIImageView alloc]initWithFrame:CGRectZero];
        //[_viewRelated addSubview:_imgLevelBK];
        
        _lbLevel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_lbLevel];
        
        _imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_imgViePhone];
        
        _imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_imgVieCoach];
        
        _lbNickName = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_lbNickName];
        
        _lbScore = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_lbScore];
        
        _lbDistance = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_lbDistance];
        
        _lbLoginTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewRelated addSubview:_lbLoginTime];
    }
    
    return self;
}

-(void)setLeaderBoardItem:(LeaderBoardItem *)leaderBoardItem {
    if (leaderBoardItem == _leaderBoardItem) {
        return;
    }
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    _leaderBoardItem = leaderBoardItem;
    
    _viewRelated.frame = CGRectMake(5, 1, 300, 50);
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:leaderBoardItem.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _userImageView.frame = CGRectMake(8, 3, 40, 40);
    _userImageView.layer.cornerRadius = 5.0;
    _userImageView.layer.masksToBounds = YES;
    
    _sexTypeImageView.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 8, 5, 40, 18);
    [_sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:leaderBoardItem.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
    _sexTypeImageView.backgroundColor = [UIColor clearColor];
    
    _lbAge.backgroundColor = [UIColor clearColor];
    _lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:leaderBoardItem.birthday];
    _lbAge.textColor = [UIColor whiteColor];
    _lbAge.font = [UIFont systemFontOfSize:10];
    _lbAge.frame = CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) - 25, 7, 20, 10);
    _lbAge.textAlignment = NSTextAlignmentRight;
    
    CGFloat fStartPoint = CGRectGetMaxX(_sexTypeImageView.frame) + 4;
    
    _imgViePhone.frame = CGRectMake(fStartPoint, 7, 8, 14);
    [_imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
    _imgViePhone.backgroundColor = [UIColor clearColor];
    _imgViePhone.hidden = leaderBoardItem.phone_number.length > 0 ? NO : YES;
    
    if (!_imgViePhone.hidden) {
        fStartPoint = CGRectGetMaxX(_imgViePhone.frame) + 2;
    }
    
    [_imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    _imgVieCoach.backgroundColor = [UIColor clearColor];
    _imgVieCoach.hidden = ([leaderBoardItem.actor isEqualToString:@"coach"]) ? NO : YES;
    _imgVieCoach.frame = CGRectMake(fStartPoint, 3, 20, 20);
    
    if (!_imgVieCoach.hidden) {
        fStartPoint = CGRectGetMaxX(_imgVieCoach.frame) + 2;
    }

    /*UIImage *imgLev = [UIImage imageNamed:@"level-bg"];
    _imgLevelBK.frame = CGRectMake(CGRectGetMinX(_sexTypeImageView.frame), CGRectGetMaxY(_userImageView.frame) - 18, imgLev.size.width, imgLev.size.height);
    _imgLevelBK.image = imgLev;
    
    //_lbLevel.backgroundColor = [UIColor colorWithPatternImage:imgLev];
    //_lbLevel.layer.contents = (id) imgLev.CGImage;
    _lbLevel.backgroundColor = [UIColor clearColor];
    _lbLevel.text = [NSString stringWithFormat:@"LV.%lu", (unsigned long)leaderBoardItem.rankLevel];
    _lbLevel.textColor = [UIColor whiteColor];
    _lbLevel.font = [UIFont italicSystemFontOfSize:10];
    _lbLevel.frame = CGRectMake(CGRectGetMinX(_sexTypeImageView.frame), CGRectGetMaxY(_userImageView.frame) - 18, imgLev.size.width, imgLev.size.height);
    _lbLevel.textAlignment = NSTextAlignmentCenter;*/
    
    _lbLevel.backgroundColor = [UIColor clearColor];
    _lbLevel.text = [NSString stringWithFormat:@"LV.%ld", leaderBoardItem.rankLevel];
    _lbLevel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    _lbLevel.font = [UIFont italicSystemFontOfSize:12];
    _lbLevel.frame = CGRectMake(CGRectGetMinX(_sexTypeImageView.frame), CGRectGetMaxY(_userImageView.frame) - 20, 40, 20);
    _lbLevel.textAlignment = NSTextAlignmentCenter;
    
    _lbNickName.backgroundColor = [UIColor clearColor];
    _lbNickName.text = leaderBoardItem.nikename;
    _lbNickName.textColor = [UIColor blackColor];
    _lbNickName.font = [UIFont boldSystemFontOfSize:12];
    _lbNickName.frame = CGRectMake(fStartPoint, 3, CGRectGetWidth(_viewRelated.frame) - fStartPoint - 70, 20);
    _lbNickName.textAlignment = NSTextAlignmentLeft;
    
    _lbScore.backgroundColor = [UIColor clearColor];
    _lbScore.text = _bRewardList ? [NSString stringWithFormat:@"打赏数目：%lld", leaderBoardItem.coins / 100000000] : [NSString stringWithFormat:@"总分数：%lu", (unsigned long)leaderBoardItem.score];
    _lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    _lbScore.font = [UIFont boldSystemFontOfSize:12];
    _lbScore.frame = CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) + 4, CGRectGetMaxY(_userImageView.frame) - 20, 150, 20);
    _lbScore.textAlignment = NSTextAlignmentLeft;

    _lbDistance.backgroundColor = [UIColor clearColor];
    _lbDistance.textColor = [UIColor darkGrayColor];
    _lbDistance.font = [UIFont boldSystemFontOfSize:10];
    _lbDistance.frame = CGRectMake(CGRectGetWidth(_viewRelated.frame) - 70, CGRectGetMinY(_lbNickName.frame), 60, 20);
    _lbDistance.textAlignment = NSTextAlignmentRight;
    
    double dDistance = [[CommonUtility sharedInstance]getDistanceBySelfLon:userInfo.longitude SelfLantitude:userInfo.latitude OtherLon:leaderBoardItem.longitude OtherLat:leaderBoardItem.latitude];
    
    if(dDistance == -1)
    {
        _lbDistance.text = @"位置不明";
    }
    else if (dDistance < 1000) {
        _lbDistance.text = [NSString stringWithFormat:@"%.1f米", dDistance];
    }
    else
    {
        _lbDistance.text = [NSString stringWithFormat:@"%.1f公里", dDistance / 1000];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:leaderBoardItem.recent_login_time];
    _lbLoginTime.backgroundColor = [UIColor clearColor];
    _lbLoginTime.text = [[CommonUtility sharedInstance]compareCurrentTime:date];
    _lbLoginTime.textColor = [UIColor darkGrayColor];
    _lbLoginTime.font = [UIFont boldSystemFontOfSize:10];
    _lbLoginTime.frame = CGRectMake(CGRectGetWidth(_viewRelated.frame) - 70, CGRectGetMinY(_lbScore.frame), 60, 20);
    _lbLoginTime.textAlignment = NSTextAlignmentRight;
}

+(CGFloat)heightOfCell{
    return 52;
}

@end
