//
//  RecommendCellTableViewCell.m
//  SportForum
//
//  Created by liyuan on 12/17/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "RecommendCellTableViewCell.h"
#import "CSButton.h"
#import "UIImageView+WebCache.h"

@implementation RecommendCellTableViewCell

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

        _viewCell = [[UIView alloc]init];
        _viewCell.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
        _viewCell.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_viewCell];
        
        _userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_userImageView];
        
        _sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_sexTypeImageView];
        
        _locImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_locImageView];
        
        _lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbAge];
        
        _imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_imgViePhone];
        
        _imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_imgVieCoach];
        
        _lbNickName = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbNickName];
        
        _imgLevelBK = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_imgLevelBK];
        
        _lbLevel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbLevel];
        
        _lbScore = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbScore];
        
        _lbTotalDistance = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbTotalDistance];
        
        _lbContent = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbContent];
        
        _lbLocation = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbLocation];
        
        _lbSep1 = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbSep1];
        
        _lbSep2 = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbSep2];
        
        _lbSep3 = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbSep3];
        
        _lbLocation = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewCell addSubview:_lbLocation];
        
        _btnImg = [CSButton buttonWithType:UIButtonTypeCustom];
        [_viewCell addSubview:_btnImg];
        [_viewCell bringSubviewToFront:_btnImg];
        
        _btnAttention = [CSButton buttonWithType:UIButtonTypeCustom];
        [_viewCell addSubview:_btnAttention];
    }
    
    return self;
}

-(void)setLeaderBoardItem:(LeaderBoardItem *)leaderBoardItem {
    if (leaderBoardItem == _leaderBoardItem) {
        return;
    }
    
    _leaderBoardItem = leaderBoardItem;
    
    _viewCell.frame = CGRectMake(5, 5, 300, 160);
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:leaderBoardItem.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _userImageView.layer.cornerRadius = 5.0;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.frame = CGRectMake(5, 5, 65, 65);
    
    _lbNickName.backgroundColor = [UIColor clearColor];
    _lbNickName.text = leaderBoardItem.nikename.length > 0 ? leaderBoardItem.nikename : @"匿名";
    _lbNickName.textColor = [UIColor blackColor];
    _lbNickName.font = [UIFont boldSystemFontOfSize:12];
    _lbNickName.textAlignment = NSTextAlignmentCenter;
    _lbNickName.frame = CGRectMake(5, CGRectGetMaxY(_userImageView.frame) + 5, 65, 20);
    
    [_sexTypeImageView setImage:[UIImage imageNamed:[leaderBoardItem.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
    _sexTypeImageView.backgroundColor = [UIColor clearColor];
    
    _lbAge.backgroundColor = [UIColor clearColor];
    _lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:leaderBoardItem.birthday];
    _lbAge.textColor = [UIColor whiteColor];
    _lbAge.font = [UIFont boldSystemFontOfSize:10];
    _lbAge.textAlignment = NSTextAlignmentRight;
    
    [_imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    _imgVieCoach.backgroundColor = [UIColor clearColor];
    _imgVieCoach.hidden = ([leaderBoardItem.actor isEqualToString:@"coach"]) ? NO : YES;
    _imgVieCoach.frame = CGRectMake(75 - 20, CGRectGetMaxY(_lbNickName.frame) + 5, 20, 20);
    
    [_imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
    _imgViePhone.backgroundColor = [UIColor clearColor];
    _imgViePhone.hidden = leaderBoardItem.phone_number.length > 0 ? NO : YES;
    
    if (_imgVieCoach.hidden) {
        _imgViePhone.frame = CGRectMake(75 - 13, CGRectGetMaxY(_lbNickName.frame) + 7, 8, 14);
    }
    else
    {
        _imgViePhone.frame = CGRectMake(75 - 20 - 10, CGRectGetMaxY(_lbNickName.frame) + 7, 8, 14);
    }
    
    if(!_imgViePhone.hidden && !_imgVieCoach.hidden)
    {
        _sexTypeImageView.frame = CGRectMake(75 - 20 - 10 - 42, CGRectGetMaxY(_lbNickName.frame) + 5, 40, 18);
    }
    else
    {
        _sexTypeImageView.frame = CGRectMake((75 - 40) / 2, CGRectGetMaxY(_lbNickName.frame) + 5, 40, 18);
    }
    
    _lbAge.frame = CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) - 25, CGRectGetMinY(_sexTypeImageView.frame) + 3, 20, 10);
    
    UIImage * imgLev = [UIImage imageNamed:@"level-bg"];
    imgLev = [imgLev stretchableImageWithLeftCapWidth:floorf(imgLev.size.width/2) topCapHeight:floorf(imgLev.size.height/2)];
    _imgLevelBK.image = imgLev;
    _imgLevelBK.frame = CGRectMake(5, CGRectGetMaxY(_sexTypeImageView.frame) + 5, 65, 20);
    
    //_lbLevel.backgroundColor = [UIColor colorWithPatternImage:imgLev];
    //_lbLevel.layer.contents = (id) imgLev.CGImage;
    _lbLevel.backgroundColor = [UIColor clearColor];
    _lbLevel.text = [NSString stringWithFormat:@"LV.%ld", leaderBoardItem.rankLevel];
    _lbLevel.textColor = [UIColor whiteColor];
    _lbLevel.font = [UIFont italicSystemFontOfSize:12];
    _lbLevel.textAlignment = NSTextAlignmentCenter;
    _lbLevel.frame = CGRectMake((75 - imgLev.size.width) / 2, CGRectGetMaxY(_sexTypeImageView.frame) + 5, imgLev.size.width, imgLev.size.height);
    
    _lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    _lbSep1.frame = CGRectMake(75, 0, 1, CGRectGetHeight(_viewCell.frame));
    
    _lbScore.backgroundColor = [UIColor clearColor];
    _lbScore.text = [NSString stringWithFormat:@"总分数：%ld", leaderBoardItem.score];
    _lbScore.textColor = [UIColor lightGrayColor];
    _lbScore.font = [UIFont boldSystemFontOfSize:12];
    _lbScore.textAlignment = NSTextAlignmentLeft;
    _lbScore.frame = CGRectMake(CGRectGetMaxX(_lbSep1.frame) + 5, 5, 100, 20);
    
    _lbTotalDistance.backgroundColor = [UIColor clearColor];
    _lbTotalDistance.text = leaderBoardItem.total_distance > 0 ? [NSString stringWithFormat:@"总里程：%.2f公里", leaderBoardItem.total_distance / 1000.00] : @"无运动数据";
    _lbTotalDistance.textColor = [UIColor lightGrayColor];
    _lbTotalDistance.font = [UIFont boldSystemFontOfSize:12];
    _lbTotalDistance.textAlignment = NSTextAlignmentRight;
    _lbTotalDistance.frame = CGRectMake(CGRectGetMaxX(_lbScore.frame), 5, CGRectGetWidth(_viewCell.frame) - CGRectGetMaxX(_lbScore.frame) - 5, 20);
    
    _locImageView.image = [UIImage imageNamed:@"location-icon"];
    _locImageView.frame = CGRectMake(CGRectGetMinX(_lbScore.frame), CGRectGetMaxY(_lbScore.frame) + 5, 17, 17);
    _lbLocation.backgroundColor = [UIColor clearColor];
    _lbLocation.textColor = [UIColor lightGrayColor];
    _lbLocation.font = [UIFont boldSystemFontOfSize:12];
    _lbLocation.frame = CGRectMake(CGRectGetMaxX(_locImageView.frame) + 5, CGRectGetMaxY(_lbScore.frame) + 5, 180, 20);

    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    double dDistance = [[CommonUtility sharedInstance]getDistanceBySelfLon:userInfo.longitude SelfLantitude:userInfo.latitude OtherLon:leaderBoardItem.longitude OtherLat:leaderBoardItem.latitude];
    
    if(dDistance == -1)
    {
        _lbLocation.text = leaderBoardItem.locaddr.length > 0 ? leaderBoardItem.locaddr : @"位置不明";
    }
    else if (dDistance < 1000) {
        if(leaderBoardItem.locaddr.length > 0)
        {
            _lbLocation.text = [NSString stringWithFormat:@"%@, 距离%.2f米", leaderBoardItem.locaddr, dDistance];
        }
        else
        {
            _lbLocation.text = [NSString stringWithFormat:@"距离%.2f米", dDistance];
        }
    }
    else
    {
        if(leaderBoardItem.locaddr.length > 0)
        {
            _lbLocation.text = [NSString stringWithFormat:@"%@, 距离%.2f公里", leaderBoardItem.locaddr, dDistance / 1000];
        }
        else
        {
            _lbLocation.text = [NSString stringWithFormat:@"距离%.2f公里", dDistance / 1000];
        }
    }
    
    _lbSep2.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    _lbSep2.frame = CGRectMake(CGRectGetMaxX(_lbSep1.frame), CGRectGetMaxY(_lbLocation.frame) + 5, CGRectGetWidth(_viewCell.frame) - CGRectGetMaxX(_lbSep1.frame), 1);
    
    _lbContent.backgroundColor = [UIColor clearColor];
    _lbContent.textColor = [UIColor lightGrayColor];
    _lbContent.text = leaderBoardItem.status.length > 0 ? leaderBoardItem.status : @"暂无博文";
    _lbContent.font = [UIFont boldSystemFontOfSize:12];
    _lbContent.numberOfLines = 0;
    _lbContent.textAlignment = NSTextAlignmentLeft;
    _lbContent.frame = CGRectMake(CGRectGetMaxX(_lbSep1.frame) + 5, CGRectGetMaxY(_lbSep2.frame) + 5, CGRectGetWidth(_viewCell.frame) - CGRectGetMaxX(_lbSep1.frame) - 10, 40);
    
    _lbSep3.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    _lbSep3.frame = CGRectMake(CGRectGetMaxX(_lbSep1.frame), CGRectGetMaxY(_lbContent.frame) + 5, CGRectGetWidth(_viewCell.frame) - CGRectGetMaxX(_lbSep1.frame), 1);
    
    [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    [_btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnAttention.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_btnAttention setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [_btnAttention setBackgroundImage:[UIImage imageNamed:@"btn-3-blue"] forState:UIControlStateNormal];
    _btnAttention.backgroundColor = [UIColor clearColor];
    _btnAttention.frame = CGRectMake((CGRectGetWidth(_viewCell.frame) - CGRectGetMaxX(_lbSep1.frame) - 123) / 2 + CGRectGetMaxX(_lbSep1.frame), CGRectGetMaxY(_lbSep3.frame) + (CGRectGetHeight(_viewCell.frame) - CGRectGetMaxY(_lbSep3.frame) - 38 ) / 2, 123, 38);
    _btnAttention.actionBlock = _attentionClickBlock;
    
    _btnImg.backgroundColor = [UIColor clearColor];
    _btnImg.frame = _userImageView.frame;
    _btnImg.actionBlock = _imgClickBlock;
}

+(CGFloat)heightOfCell{
    return 165;
}

@end
