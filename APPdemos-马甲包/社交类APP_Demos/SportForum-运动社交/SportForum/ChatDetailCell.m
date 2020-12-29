//
//  ChatDetailCell.m
//  SportForum
//
//  Created by liyuan on 14-6-24.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "ChatDetailCell.h"
#import "CommonUtility.h"
#import "UIImageView+WebCache.h"

#define FONT_CHAT [UIFont fontWithName:@"Arial" size:10]
#define COLOR_GRAY [UIColor colorWithRed:205.0 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1]

#define COLOR_TIME_LABLE [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1]

@implementation ChatDetailItem
@end

@implementation ChatDetailCell

const float cTopSpace = 5.0;
const float cLeftSpace = 10.0;
const float cTimeLableHeight = 20;
const float cImageViewHeight = 40;

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
        
        _viewChat = [[UIImageView alloc]init];
        [_viewChat setImage:imgBk];
        [self.contentView addSubview:_viewChat];
        
        _lbNickName = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_lbNickName];
        
        _lbTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_lbTime];
        
        _lbLatestContent = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_lbLatestContent];
        
        _lbNum = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_lbNum];
        
        _imgViewNum = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_imgViewNum];

        _userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_userImageView];
        
        _imgViewArr = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewChat addSubview:_imgViewArr];
        
        [_viewChat bringSubviewToFront:_imgViewNum];
        [_viewChat bringSubviewToFront:_lbNum];
        
        _viewDel = [[UIView alloc]init];
        _viewDel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_viewDel];
        
        _btnDel = [[CSButton alloc]init];
        [_viewDel addSubview:_btnDel];
        
        _imgViewDel = [[UIImageView alloc]init];
        [_imgViewDel setImage:imgBk];
        [_viewDel addSubview:_imgViewDel];
        
        _lbNickNameDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewDel addSubview:_lbNickNameDel];
        
        _lbTimeDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewDel addSubview:_lbTimeDel];
        
        _lbLatestConDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewDel addSubview:_lbLatestConDel];
        
        _lbNumDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewDel addSubview:_lbNumDel];
        
        _imgViewNumDel = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgViewDel addSubview:_imgViewNumDel];
        
        _userImgDel = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgViewDel addSubview:_userImgDel];
        
        [_imgViewDel bringSubviewToFront:_imgViewNumDel];
        [_imgViewDel bringSubviewToFront:_lbNumDel];
    }
    
    return self;
}

-(void)generateDelCell:(ChatDetailItem *)chatDetailItem
{
    _viewDel.frame = CGRectMake(5, 1, 300, 50);
    
    [_btnDel setBackgroundImage:[UIImage imageNamed:@"message-delete"] forState:UIControlStateNormal];
    _btnDel.frame = CGRectMake(0, 5, 40, 40);
    _btnDel.actionBlock = _delClickBlock;
    
    _imgViewDel.frame = CGRectMake(CGRectGetMaxX(_btnDel.frame) + 5, 0, 300 - (CGRectGetMaxX(_btnDel.frame) + 5), 50);
    
    if ([chatDetailItem.nickName isEqualToString:@"系统消息"]) {
        [_userImgDel setImage:[UIImage imageNamed:chatDetailItem.userImage]];
    }
    else
    {
        [_userImgDel sd_setImageWithURL:[NSURL URLWithString:chatDetailItem.userImage]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    }
    
    _userImgDel.frame = CGRectMake(8, 3, 40, 40);
    _userImgDel.layer.cornerRadius = 5.0;
    _userImgDel.layer.masksToBounds = YES;
    
    _lbNickNameDel.backgroundColor = [UIColor clearColor];
    _lbNickNameDel.text = chatDetailItem.nickName;
    _lbNickNameDel.textColor = [UIColor blackColor];
    _lbNickNameDel.font = [UIFont boldSystemFontOfSize:14];
    _lbNickNameDel.frame = CGRectMake(CGRectGetMaxX(_userImgDel.frame) + 15, cTopSpace, 100, cTimeLableHeight);
    _lbNickNameDel.textAlignment = NSTextAlignmentLeft;
    
    if (chatDetailItem.unReadCount > 0) {
        _imgViewNumDel.userInteractionEnabled = NO;
        _imgViewNumDel.hidden = NO;
        
        _lbNumDel.userInteractionEnabled = NO;
        _lbNumDel.backgroundColor = [UIColor clearColor];
        _lbNumDel.textColor = [UIColor whiteColor];
        _lbNumDel.font = [UIFont boldSystemFontOfSize:10];
        _lbNumDel.textAlignment = NSTextAlignmentCenter;
        _lbNumDel.text = [NSString stringWithFormat:@"%ld", (long)chatDetailItem.unReadCount];
        
        if (chatDetailItem.unReadCount >= 100) {
            _lbNumDel.hidden = YES;
            _imgViewNumDel.frame = CGRectMake(CGRectGetMaxX(_userImgDel.frame) - 4, 2, 9, 9);
            _imgViewNumDel.image = [UIImage imageNamed:@"info-reddot-small"];
        }
        else
        {
            _lbNumDel.hidden = NO;
            _imgViewNumDel.frame = CGRectMake(CGRectGetMaxX(_userImgDel.frame) - 8, 2, 16, 16);
            _imgViewNumDel.image = [UIImage imageNamed:@"info-reddot"];
        }
        
        _lbNumDel.frame = _imgViewNumDel.frame;
        
        _lbLatestConDel.text = [NSString stringWithFormat:@"[%ld条新消息]%@", (long)chatDetailItem.unReadCount, chatDetailItem.latestContent];
    }
    else
    {
        _imgViewNumDel.hidden = YES;
        _lbNumDel.hidden = YES;
        _lbLatestConDel.text = chatDetailItem.latestContent;
    }
    
    _lbLatestConDel.backgroundColor = [UIColor clearColor];
    _lbLatestConDel.textColor = [UIColor darkGrayColor];
    _lbLatestConDel.font = [UIFont systemFontOfSize:12];
    _lbLatestConDel.frame = CGRectMake(CGRectGetMaxX(_userImgDel.frame) + 15, CGRectGetMaxY(_userImgDel.frame) - cTimeLableHeight, CGRectGetWidth(_imgViewDel.frame) - (CGRectGetMaxX(_userImgDel.frame) + 15), cTimeLableHeight);
    _lbLatestConDel.textAlignment = NSTextAlignmentLeft;
    
    if (chatDetailItem.time != nil) {
        [_lbTimeDel setFrame:CGRectMake(CGRectGetMaxX(_lbNickNameDel.frame), cTopSpace, CGRectGetWidth(_imgViewDel.frame) - CGRectGetMaxX(_lbNickNameDel.frame) - 10, cTimeLableHeight)];
        // Time lable to center

        [_lbTimeDel setBackgroundColor:[UIColor clearColor]];
        
        NSString *strTime = [[CommonUtility sharedInstance]compareCurrentTime:chatDetailItem.time];
        
        NSRange range = [strTime rangeOfString:@"年前"];//判断字符串是否包含
        
        if (range.length >0)//包含
        {
            [_lbTimeDel setText:@""];
        }
        else//不包含
        {
            [_lbTimeDel setText:strTime];
        }
        
        [_lbTimeDel setFont:[UIFont systemFontOfSize:11]];
        _lbTimeDel.textColor = [UIColor darkGrayColor];
        _lbTimeDel.backgroundColor = [UIColor clearColor];
        _lbTimeDel.textAlignment = NSTextAlignmentRight;
    } else {
        _lbTimeDel.hidden = YES;
    }
}

-(void)generateNormalCell:(ChatDetailItem *)chatDetailItem
{
    CGRect rectTime = CGRectZero;
    
    _viewChat.frame = CGRectMake(5, 1, 300, 50);
    
    if ([_chatDetailItem.nickName isEqualToString:@"系统消息"]) {
        [_userImageView setImage:[UIImage imageNamed:chatDetailItem.userImage]];
    }
    else
    {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:chatDetailItem.userImage]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    }
    
    _userImageView.frame = CGRectMake(8, 3, 40, 40);
    _userImageView.layer.cornerRadius = 5.0;
    _userImageView.layer.masksToBounds = YES;
    
    _lbNickName.backgroundColor = [UIColor clearColor];
    _lbNickName.text = chatDetailItem.nickName;
    _lbNickName.textColor = [UIColor blackColor];
    _lbNickName.font = [UIFont boldSystemFontOfSize:14];
    _lbNickName.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 15, cTopSpace, 150, cTimeLableHeight);
    _lbNickName.textAlignment = NSTextAlignmentLeft;
    
    if (chatDetailItem.unReadCount > 0) {
        _imgViewNum.userInteractionEnabled = NO;
        _imgViewNum.hidden = NO;
        
        _lbNum.userInteractionEnabled = NO;
        _lbNum.backgroundColor = [UIColor clearColor];
        _lbNum.textColor = [UIColor whiteColor];
        _lbNum.font = [UIFont boldSystemFontOfSize:10];
        _lbNum.textAlignment = NSTextAlignmentCenter;
        _lbNum.text = [NSString stringWithFormat:@"%ld", (long)chatDetailItem.unReadCount];
        
        if (chatDetailItem.unReadCount >= 100) {
            _lbNum.hidden = YES;
            _imgViewNum.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) - 4, 2, 9, 9);
            _imgViewNum.image = [UIImage imageNamed:@"info-reddot-small"];
        }
        else
        {
            _lbNum.hidden = NO;
            _imgViewNum.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) - 8, 2, 16, 16);
            _imgViewNum.image = [UIImage imageNamed:@"info-reddot"];
        }
        
        _lbNum.frame = _imgViewNum.frame;
        
        _lbLatestContent.text = [NSString stringWithFormat:@"[%ld条新消息]%@", (long)chatDetailItem.unReadCount, chatDetailItem.latestContent];
    }
    else
    {
        _imgViewNum.hidden = YES;
        _lbNum.hidden = YES;
        _lbLatestContent.text = chatDetailItem.latestContent;
    }
    
    _lbLatestContent.backgroundColor = [UIColor clearColor];
    _lbLatestContent.textColor = [UIColor darkGrayColor];
    _lbLatestContent.font = [UIFont systemFontOfSize:12];
    _lbLatestContent.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 15, CGRectGetMaxY(_userImageView.frame) - cTimeLableHeight, CGRectGetWidth(_viewChat.frame) - cLeftSpace - 30 - (CGRectGetMaxX(_userImageView.frame) + 15), cTimeLableHeight);
    _lbLatestContent.textAlignment = NSTextAlignmentLeft;
    
    UIImage *image = [UIImage imageNamed:@"arrow-1"];
    [_imgViewArr setImage:image];
    _imgViewArr.frame = CGRectMake(_viewChat.frame.size.width - 15 - image.size.width, 15, image.size.width, image.size.height);
    
    if (chatDetailItem.time != nil) {
        [_lbTime setFrame:CGRectMake(0, cTopSpace, 100, cTimeLableHeight)];
        // Time lable to center
        rectTime = _lbTime.frame;
        
        _lbTime.frame = CGRectMake(CGRectGetWidth(_viewChat.frame) - rectTime.size.width - cLeftSpace - 20,
                                   rectTime.origin.y, rectTime.size.width, rectTime.size.height);
        [_lbTime setBackgroundColor:[UIColor clearColor]];
        NSString *strTime = [[CommonUtility sharedInstance]compareCurrentTime:chatDetailItem.time];
        
        NSRange range = [strTime rangeOfString:@"年前"];//判断字符串是否包含
        
        if (range.length >0)//包含
        {
            [_lbTime setText:@""];
        }
        else//不包含
        {
            [_lbTime setText:strTime];
        }
        
        [_lbTime setFont:[UIFont systemFontOfSize:11]];
        _lbTime.textColor = [UIColor darkGrayColor];
        _lbTime.backgroundColor = [UIColor clearColor];
        _lbTime.textAlignment = NSTextAlignmentRight;
    } else {
        _lbTime.hidden = YES;
    }
}

-(void)setChatDetailItem:(ChatDetailItem *)chatDetailItem {
    _chatDetailItem = chatDetailItem;
    
    [self generateNormalCell:chatDetailItem];
    [self generateDelCell:chatDetailItem];
    
    if (_bEditMode) {
        _viewDel.hidden = NO;
        _viewChat.hidden = YES;
    }
    else
    {
        _viewDel.hidden = YES;
        _viewChat.hidden = NO;
    }
}

+(CGFloat)heightOfCell{
    return 52;
}

@end