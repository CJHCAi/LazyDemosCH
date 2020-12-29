//
//  AccountBoardTableViewCell.m
//  SportForum
//
//  Created by liyuan on 4/20/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "AccountBoardTableViewCell.h"
#import "CSButton.h"
#import "UIImageView+WebCache.h"

@implementation AccountBoardTableViewCell

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
        
        _lbDistance = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbDistance];
        
        _lbLoginTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbLoginTime];
    }
    
    return self;
}

-(NSString*)generateTitle
{
    NSString *strTitle = @"体魄值";
    
    if ([_strBoardType isEqualToString:@"physique"]) {
        strTitle = @"体魄值";
    }
    else if([_strBoardType isEqualToString:@"literature"]) {
        strTitle = @"文学值";
    }
    else if([_strBoardType isEqualToString:@"magic"]) {
        strTitle = @"魔法值";
    }
    
    return strTitle;
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
    _lbNickName.frame = CGRectMake(fStartPoint, 3, CGRectGetWidth(_viewBoard.frame) - fStartPoint - 65, 20);
    _lbNickName.textAlignment = NSTextAlignmentLeft;
    
    _lbScore.backgroundColor = [UIColor clearColor];
    _lbScore.text = [NSString stringWithFormat:@"%@: %ld", [self generateTitle], leaderBoardItem.score];
    
    _lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];//[UIColor colorWithRed:176.0 / 255.0 green:150.0 / 255.0 blue:32.0 / 255.0 alpha:1.0];
    _lbScore.font = [UIFont boldSystemFontOfSize:12];
    _lbScore.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 8, CGRectGetMaxY(_userImageView.frame) - 20, 150, 20);
    _lbScore.textAlignment = NSTextAlignmentLeft;
    
    _lbDistance.backgroundColor = [UIColor clearColor];
    _lbDistance.textColor = [UIColor darkGrayColor];
    _lbDistance.font = [UIFont boldSystemFontOfSize:10];
    _lbDistance.frame = CGRectMake(CGRectGetWidth(_viewBoard.frame) - 85, CGRectGetMinY(_lbNickName.frame), 75, 20);
    _lbDistance.textAlignment = NSTextAlignmentRight;
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
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
    
    NSString *strTime = [[CommonUtility sharedInstance]compareCurrentTime:date];
    
    NSRange range = [strTime rangeOfString:@"年前"];//判断字符串是否包含
    
    if (range.length >0)//包含
    {
        [_lbLoginTime setText:@""];
    }
    else//不包含
    {
        [_lbLoginTime setText:strTime];
    }

    _lbLoginTime.textColor = [UIColor darkGrayColor];
    _lbLoginTime.font = [UIFont boldSystemFontOfSize:10];
    _lbLoginTime.frame = CGRectMake(CGRectGetWidth(_viewBoard.frame) - 70, CGRectGetMinY(_lbScore.frame), 60, 20);
    _lbLoginTime.textAlignment = NSTextAlignmentRight;}

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
