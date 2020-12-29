//
//  GameBoardCell.m
//  SportForum
//
//  Created by liyuan on 2/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "GameBoardCell.h"
#import "CSButton.h"
#import "UIImageView+WebCache.h"

@implementation GameBoardCell

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
        
        _boardImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_boardImageView];
        
        _lbBoardRank = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbBoardRank];
        
        _userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_userImageView];
        
        _sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_sexTypeImageView];
        
        _lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbAge];
        
        _imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_imgViePhone];
        
        _imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_imgVieCoach];
        
        _lbNickName = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbNickName];
        
        _lbScore = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbScore];
        
        _lbTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbTime];
    }
    
    return self;
}

-(void)setLeaderBoardItem:(LeaderBoardItem *)leaderBoardItem {
    if (leaderBoardItem == _leaderBoardItem) {
        return;
    }
    
    _leaderBoardItem = leaderBoardItem;
    
    _viewBoard.frame = CGRectMake(2, 1, 302, 50);
    
    UIImage *image = nil;
    
    switch (leaderBoardItem.index) {
        case 1:
        {
            image = [UIImage imageNamed:@"crown-1"];
        }
            break;
        case 2:
        {
            image = [UIImage imageNamed:@"crown-2"];
        }
            break;
        case 3:
        {
            image = [UIImage imageNamed:@"crown-3"];
        }
            break;
        default:
            break;
    }
    
    if (image != nil) {
        _lbBoardRank.hidden = YES;
        _boardImageView.hidden = NO;
        _boardImageView.frame = CGRectMake(5, 7, 40, 36);
        [_boardImageView setImage:image];
    }
    else
    {
        _lbBoardRank.hidden = NO;
        _boardImageView.hidden = YES;
    }
    
    _lbBoardRank.backgroundColor = [UIColor clearColor];
    _lbBoardRank.text = [NSString stringWithFormat:@"%ld", leaderBoardItem.index];
    _lbBoardRank.textColor = [UIColor blackColor];
    _lbBoardRank.font = [UIFont boldSystemFontOfSize:16];
    _lbBoardRank.frame = CGRectMake(8, 15, 30, 20);
    _lbBoardRank.textAlignment = NSTextAlignmentCenter;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:leaderBoardItem.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _userImageView.layer.cornerRadius = 5.0;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.frame = CGRectMake(CGRectGetMaxX(_lbBoardRank.frame) + 8, 3, 40, 40);
    
    _sexTypeImageView.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 8, 5, 40, 18);
    [_sexTypeImageView setImage:[UIImage imageNamed:[leaderBoardItem.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
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

    _lbNickName.backgroundColor = [UIColor clearColor];
    _lbNickName.text = leaderBoardItem.nikename;
    _lbNickName.textColor = [UIColor blackColor];
    _lbNickName.font = [UIFont boldSystemFontOfSize:12];
    _lbNickName.frame = CGRectMake(fStartPoint, 3, CGRectGetWidth(_viewBoard.frame) - fStartPoint - 10, 20);
    _lbNickName.textAlignment = NSTextAlignmentLeft;
    
    _lbScore.backgroundColor = [UIColor clearColor];
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if([leaderBoardItem.userid isEqualToString:userInfo.userid])
    {
        _lbScore.text = [NSString stringWithFormat:@"本次分：%ld", leaderBoardItem.score];
    }
    else
    {
        _lbScore.text = [NSString stringWithFormat:@"最高分：%ld", leaderBoardItem.score];
    }
    
    _lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];//[UIColor colorWithRed:176.0 / 255.0 green:150.0 / 255.0 blue:32.0 / 255.0 alpha:1.0];
    _lbScore.font = [UIFont boldSystemFontOfSize:12];
    _lbScore.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 8, CGRectGetMaxY(_userImageView.frame) - 20, 150, 20);
    _lbScore.textAlignment = NSTextAlignmentLeft;
    
    _lbTime.backgroundColor = [UIColor clearColor];
    _lbTime.text = [[CommonUtility sharedInstance]compareCurrentTime:[NSDate dateWithTimeIntervalSince1970:leaderBoardItem.recent_login_time]];
    _lbTime.textColor = [UIColor darkGrayColor];
    _lbTime.font = [UIFont boldSystemFontOfSize:12];
    _lbTime.frame = CGRectMake(CGRectGetWidth(_viewBoard.frame) - 100, CGRectGetMaxY(_userImageView.frame) - 20, 90, 20);
    _lbTime.textAlignment = NSTextAlignmentRight;
    
    if (leaderBoardItem.recent_login_time > 0) {
        _lbTime.hidden = NO;
        _lbTime.text = [NSString stringWithFormat:@"%@玩过", [[CommonUtility sharedInstance]compareCurrentTime:[NSDate dateWithTimeIntervalSince1970:leaderBoardItem.recent_login_time]]];
    }
    else
    {
        _lbTime.hidden = YES;
    }
}

+(CGFloat)heightOfCell{
    return 52;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
