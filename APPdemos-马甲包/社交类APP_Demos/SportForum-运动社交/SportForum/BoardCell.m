//
//  BoardCell.m
//  SportForum
//
//  Created by liyuan on 14-8-20.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "BoardCell.h"
#import "CSButton.h"
#import "UIImageView+WebCache.h"

@implementation BoardCell

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
        
        //_imgLevelBK = [[UIImageView alloc]initWithFrame:CGRectZero];
        //[_viewBoard addSubview:_imgLevelBK];
        
        _lbLevel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbLevel];
        
        _lbScore = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewBoard addSubview:_lbScore];
        
        _lbNum = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbNum];
        
        _imgViewNum = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgViewNum];
        
        _btnPk = [CSButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btnPk];
        
        [self.contentView bringSubviewToFront:_imgViewNum];
        [self.contentView bringSubviewToFront:_lbNum];
    }
    
    return self;
}

-(void)setLeaderBoardItem:(LeaderBoardItem *)leaderBoardItem {
    if (leaderBoardItem == _leaderBoardItem) {
        return;
    }
    
    _leaderBoardItem = leaderBoardItem;
    
    //NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
    //NSUInteger nPKTimes = [[dict objectForKey:leaderBoardItem.userid]unsignedIntegerValue];
    
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
    
    /*UIImage *imgLev = [UIImage imageNamed:@"level-bg"];
    _imgLevelBK.frame = CGRectMake(CGRectGetMinX(_sexTypeImageView.frame), CGRectGetMaxY(_userImageView.frame) - 18, imgLev.size.width, imgLev.size.height);
    _imgLevelBK.image = imgLev;
    
    //_lbLevel.layer.contents = (id) imgLev.CGImage;
    //_lbLevel.backgroundColor = [UIColor colorWithPatternImage:imgLev];
    _lbLevel.backgroundColor = [UIColor clearColor];
    _lbLevel.text = [NSString stringWithFormat:@"LV.%ld", leaderBoardItem.rankLevel];
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
    _lbNickName.frame = CGRectMake(fStartPoint, 3, CGRectGetWidth(_viewBoard.frame) - 55 - fStartPoint, 20);
    _lbNickName.textAlignment = NSTextAlignmentLeft;
    
    _lbScore.backgroundColor = [UIColor clearColor];
    _lbScore.text = [NSString stringWithFormat:@"总分数：%ld", leaderBoardItem.score];
    _lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    _lbScore.font = [UIFont boldSystemFontOfSize:12];
    _lbScore.frame = CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) + 4, CGRectGetMaxY(_userImageView.frame) - 20, 150, 20);
    _lbScore.textAlignment = NSTextAlignmentLeft;
    
    _btnPk.frame = CGRectMake(_viewBoard.frame.size.width - 50, 7, 39, 35);
    [_btnPk.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [_btnPk setTitle:@"PK" forState:UIControlStateNormal];
    _btnPk.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnPk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPk setBackgroundImage:[UIImage imageNamed:@"btn-4-blue"] forState:UIControlStateNormal];
    [_btnPk setBackgroundImage:[UIImage imageNamed:@"btn-4-grey"] forState:UIControlStateDisabled];
    //_btnPk.enabled = (nPKTimes > 0 ? YES : NO);
    _btnPk.actionBlock = _pkClickBlock;
    
    _imgViewNum.frame = CGRectMake(CGRectGetMaxX(_btnPk.frame) - 10, 4, 16, 16);
    _imgViewNum.userInteractionEnabled = NO;
    _imgViewNum.image = [UIImage imageNamed:@"info-reddot"];
    _imgViewNum.hidden = YES;
    
    _lbNum.frame = _imgViewNum.frame;
    _lbNum.userInteractionEnabled = NO;
    _lbNum.backgroundColor = [UIColor clearColor];
    _lbNum.textColor = [UIColor whiteColor];
    _lbNum.font = [UIFont boldSystemFontOfSize:10];
    _lbNum.textAlignment = NSTextAlignmentCenter;
    //_lbNum.text = [NSString stringWithFormat:@"%ld", nPKTimes];
    _lbNum.hidden = YES;
}

+(CGFloat)heightOfCell{
    return 52;
}

@end
