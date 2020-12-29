//
//  SystemNotifyCell.m
//  SportForum
//
//  Created by liyuan on 14-7-2.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "SystemNotifyCell.h"
#import "CommonUtility.h"
#import "UIImageView+WebCache.h"

#define FONT_CHAT [UIFont fontWithName:@"Arial" size:10]
#define COLOR_GRAY [UIColor colorWithRed:205.0 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1]

#define COLOR_TIME_LABLE [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1]

@implementation SystemNotifyItem
@end

@implementation SystemNotifyCell

const float cSystemTopSpace = 5.0;
const float cSystemLeftSpace = 10.0;
const float cSystemTimeLableHeight = 15;
const float cSystemImageViewHeight = 40;

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
        
        _viewSystem = [[UIImageView alloc]init];
        [_viewSystem setImage:imgBk];
        [self.contentView addSubview:_viewSystem];
        
        _lbNotifyName = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_lbNotifyName];
        
        _lbTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_lbTime];
        
        _lbTotalNotify = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_lbTotalNotify];
        
        _lbNum = [[UILabel alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_lbNum];
        
        _imgViewNum = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_imgViewNum];
        
        _articleImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_articleImgView];
        
        _notifyImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_notifyImageView];
        
        _imgViewArr = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_viewSystem addSubview:_imgViewArr];
        
        [_viewSystem bringSubviewToFront:_imgViewNum];
        [_viewSystem bringSubviewToFront:_lbNum];
        
        _viewDel = [[UIView alloc]init];
        _viewDel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_viewDel];
        
        _btnDel = [[CSButton alloc]init];
        [_viewDel addSubview:_btnDel];
        
        _imgViewSystemDel = [[UIImageView alloc]init];
        [_imgViewSystemDel setImage:imgBk];
        [_viewDel addSubview:_imgViewSystemDel];
        
        _lbNotifyNameDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_lbNotifyNameDel];
        
        _lbTimeDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_lbTimeDel];
        
        _lbTotalNotifyDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_lbTotalNotifyDel];
        
        _lbNumDel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_lbNumDel];
        
        _imgViewNumDel = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_imgViewNumDel];
        
        _articleImgViewDel = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_articleImgViewDel];
        
        _notifyImgViewDel = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imgViewSystemDel addSubview:_notifyImgViewDel];
        
        [_imgViewSystemDel bringSubviewToFront:_imgViewNumDel];
        [_imgViewSystemDel bringSubviewToFront:_lbNumDel];
    }
    
    return self;
}

-(void)generateDelView:(SystemNotifyItem *)systemNotifyItem {
    _viewDel.frame = CGRectMake(5, 1, 300, 50);
    
    [_btnDel setBackgroundImage:[UIImage imageNamed:@"message-delete"] forState:UIControlStateNormal];
    _btnDel.frame = CGRectMake(0, 5, 40, 40);
    _btnDel.actionBlock = _delClickBlock;
    
    _imgViewSystemDel.frame = CGRectMake(CGRectGetMaxX(_btnDel.frame) + 5, 0, 300 - (CGRectGetMaxX(_btnDel.frame) + 5), 50);
    
    _notifyImgViewDel.frame = CGRectMake(8, 3, 40, 40);
    _notifyImgViewDel.layer.cornerRadius = 5.0;
    _notifyImgViewDel.layer.masksToBounds = YES;
    
    _lbNotifyNameDel.backgroundColor = [UIColor clearColor];
    _lbNotifyNameDel.textColor = [UIColor blackColor];
    _lbNotifyNameDel.font = [UIFont boldSystemFontOfSize:14];
    _lbNotifyNameDel.frame = CGRectMake(CGRectGetMaxX(_notifyImgViewDel.frame) + 10, 5, 170, cSystemTimeLableHeight);
    _lbNotifyNameDel.textAlignment = NSTextAlignmentLeft;
    
    _lbTotalNotifyDel.backgroundColor = [UIColor clearColor];
    _lbTotalNotifyDel.textColor = [UIColor darkGrayColor];
    _lbTotalNotifyDel.font = [UIFont systemFontOfSize:12];
    _lbTotalNotifyDel.frame = CGRectMake(CGRectGetMaxX(_notifyImgViewDel.frame) + 10, CGRectGetMaxY(_notifyImgViewDel.frame) - 20, 150, cSystemTimeLableHeight);
    _lbTotalNotifyDel.textAlignment = NSTextAlignmentLeft;
    
    [_articleImgViewDel sd_setImageWithURL:[NSURL URLWithString:systemNotifyItem.strImage] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _articleImgViewDel.frame = CGRectMake(CGRectGetWidth(_imgViewSystemDel.frame) - 8 - 40, 3, 40, 40);
    _articleImgViewDel.layer.cornerRadius = 5.0;
    _articleImgViewDel.layer.masksToBounds = YES;
    
    _lbTimeDel.hidden = YES;
    /*
    if (systemNotifyItem.time != nil) {
        
        _lbTimeDel.frame = CGRectMake(CGRectGetMinX(_articleImgViewDel.frame) - cSystemLeftSpace - 60, CGRectGetMinY(_lbNotifyName.frame), 60, cSystemTimeLableHeight);
        [_lbTimeDel setBackgroundColor:[UIColor clearColor]];
        [_lbTimeDel setText:[[CommonUtility sharedInstance]compareCurrentTime:systemNotifyItem.time]];
        [_lbTimeDel setFont:[UIFont systemFontOfSize:11]];
        _lbTimeDel.textColor = [UIColor darkGrayColor];
        _lbTimeDel.textAlignment = NSTextAlignmentRight;
    } else {
        _lbTimeDel.hidden = YES;
    }*/
    
    UIImage *imageNotify = nil;
    
    if (systemNotifyItem.eNotifyType == e_notify_comment) {
        _lbNotifyNameDel.text = @"有人回复了你的博文";
        _lbTotalNotifyDel.text = [NSString stringWithFormat:@"此博文共%ld个回复", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_coach_comment)
    {
        _lbNotifyNameDel.text = @"有人回复了你";
        _lbTotalNotifyDel.text = [NSString stringWithFormat:@"此博文共%ld个点评", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_at)
    {
        _lbNotifyNameDel.text = @"有人在博文中@了你";
        _lbTotalNotifyDel.text = @"去看看是什么事吧！";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_record)
    {
        _lbNotifyNameDel.text = @"有人提交记录了";
        _lbTotalNotifyDel.text = @"去看看Ta的运动记录";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_coach_pass_comment)
    {
        _lbNotifyNameDel.text = @"跑步成绩通过审核";
        _lbTotalNotifyDel.text = @"请查看审核通过的运动记录！";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_coach_npass_comment)
    {
        _lbNotifyNameDel.text = @"跑步成绩被拒绝";
        _lbTotalNotifyDel.text = @"请查看被拒绝的运动记录！";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_thumb)
    {
        _lbNotifyNameDel.text = @"有人赞了你的博文";
        _lbTotalNotifyDel.text = [NSString stringWithFormat:@"此博文共%ld个赞", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"contact-system-info-hearted"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_subscribe)
    {
        _lbNotifyNameDel.text = [NSString stringWithFormat:@"%@关注了你", systemNotifyItem.strNikeName];
        _lbTotalNotifyDel.text = @"去Ta的主页看看吧";
        imageNotify = [UIImage imageNamed:@"other-info-follow"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_reward)
    {
        _lbNotifyNameDel.text = @"有人给你打赏了";
        _lbTotalNotifyDel.text = [NSString stringWithFormat:@"此博文共得赏%ld个金币", systemNotifyItem.unTotalCount / 100000000];
        imageNotify = [UIImage imageNamed:@"contact-system-info-money"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_tx)
    {
        _lbNotifyNameDel.text = @"有人给你转帐了";
        _lbTotalNotifyDel.text = [NSString stringWithFormat:@"本次共转账%ld个金币", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"contact-system-info-money"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_send_heart)
    {
        _lbNotifyNameDel.text = @"有人给你发送心跳";
        _lbTotalNotifyDel.text = @"和Ta一起感知运动的韵律吧";
        imageNotify = [UIImage imageNamed:@"contact-system-info-heartRate"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_receive_heart)
    {
        _lbNotifyNameDel.text = @"有人接收了你的心跳";
        _lbTotalNotifyDel.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-info-heartRate"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_runshare)
    {
        _lbNotifyNameDel.text = @"有人约你一起跑步了";
        _lbTotalNotifyDel.text = @"和Ta一起跑步吧";
        imageNotify = [UIImage imageNamed:@"contact-system-run-together"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_runshared)
    {
        _lbNotifyNameDel.text = @"有人接受约跑了";
        _lbTotalNotifyDel.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-run-together"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_postshare)
    {
        _lbNotifyNameDel.text = @"有人发表了新文章";
        _lbTotalNotifyDel.text = @"去给Ta的文章点个赞吧";
        imageNotify = [UIImage imageNamed:@"contact-system-praise-ask"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_postshared)
    {
        _lbNotifyNameDel.text = @"有人赞了你的博文";
        _lbTotalNotifyDel.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-praise-ask"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_pkshare)
    {
        _lbNotifyNameDel.text = @"有人向你发起了挑战";
        _lbTotalNotifyDel.text = @"去接受Ta的挑战吧";
        imageNotify = [UIImage imageNamed:@"contact-system-PK"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_pkshared)
    {
        _lbNotifyNameDel.text = @"有人接受了你的挑战";
        _lbTotalNotifyDel.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-PK"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_info)
    {
        _lbNotifyNameDel.text = @"去领取50个金币奖励";
        _lbTotalNotifyDel.text = @"速度完善个人资料吧！";
        imageNotify = [UIImage imageNamed:@"other-info-follow"];
    }
    
    [_notifyImgViewDel setImage:imageNotify];
    
    if (systemNotifyItem.unReadCount > 0) {
        _imgViewNumDel.userInteractionEnabled = NO;
        _imgViewNumDel.hidden = NO;
        
        _lbNumDel.userInteractionEnabled = NO;
        _lbNumDel.backgroundColor = [UIColor clearColor];
        _lbNumDel.textColor = [UIColor whiteColor];
        _lbNumDel.font = [UIFont boldSystemFontOfSize:10];
        _lbNumDel.textAlignment = NSTextAlignmentCenter;
        _lbNumDel.text = [NSString stringWithFormat:@"%ld", systemNotifyItem.unReadCount];
        
        if (systemNotifyItem.unReadCount >= 100) {
            _lbNumDel.hidden = YES;
            _imgViewNumDel.frame = CGRectMake(CGRectGetMaxX(_notifyImgViewDel.frame) - 4, 2, 9, 9);
            _imgViewNumDel.image = [UIImage imageNamed:@"info-reddot-small"];
        }
        else
        {
            _lbNumDel.hidden = NO;
            _imgViewNumDel.frame = CGRectMake(CGRectGetMaxX(_notifyImgViewDel.frame) - 8, 2, 16, 16);
            _imgViewNumDel.image = [UIImage imageNamed:@"info-reddot"];
        }
        
        _lbNumDel.frame = _imgViewNumDel.frame;
    }
    else
    {
        _imgViewNumDel.hidden = YES;
        _lbNumDel.hidden = YES;
    }
}

-(void)generateNormalCell:(SystemNotifyItem *)systemNotifyItem {
    _viewSystem.frame = CGRectMake(5, 1, 300, 50);
    _notifyImageView.frame = CGRectMake(8, 3, 40, 40);
    _notifyImageView.layer.cornerRadius = 5.0;
    _notifyImageView.layer.masksToBounds = YES;
    
    UIImage *image = [UIImage imageNamed:@"arrow-1"];
    
    _lbNotifyName.backgroundColor = [UIColor clearColor];
    _lbNotifyName.textColor = [UIColor blackColor];
    _lbNotifyName.font = [UIFont boldSystemFontOfSize:14];
    _lbNotifyName.frame = CGRectMake(CGRectGetMaxX(_notifyImageView.frame) + 10, 5, 300 - image.size.width - 15 - 40 - (CGRectGetMaxX(_notifyImageView.frame) + 45 + cSystemLeftSpace), cSystemTimeLableHeight);
    _lbNotifyName.textAlignment = NSTextAlignmentLeft;
    
    _lbTotalNotify.backgroundColor = [UIColor clearColor];
    _lbTotalNotify.textColor = [UIColor darkGrayColor];
    _lbTotalNotify.font = [UIFont systemFontOfSize:12];
    _lbTotalNotify.frame = CGRectMake(CGRectGetMaxX(_notifyImageView.frame) + 10, CGRectGetMaxY(_notifyImageView.frame) - 20, 170, cSystemTimeLableHeight);
    _lbTotalNotify.textAlignment = NSTextAlignmentLeft;
    
    [_imgViewArr setImage:image];
    _imgViewArr.frame = CGRectMake(_viewSystem.frame.size.width - 10 - image.size.width, 15, image.size.width, image.size.height);
    
    [_articleImgView sd_setImageWithURL:[NSURL URLWithString:systemNotifyItem.strImage] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _articleImgView.frame = CGRectMake(300 - image.size.width - 15 - 40, 3, 40, 40);
    _articleImgView.layer.cornerRadius = 5.0;
    _articleImgView.layer.masksToBounds = YES;
    
    if (systemNotifyItem.time != nil) {
        _lbTime.frame = CGRectMake(CGRectGetMinX(_articleImgView.frame) - cSystemLeftSpace - 45, CGRectGetMinY(_lbNotifyName.frame), 50, cSystemTimeLableHeight);
        [_lbTime setBackgroundColor:[UIColor clearColor]];
        [_lbTime setText:[[CommonUtility sharedInstance]compareCurrentTime:systemNotifyItem.time]];
        [_lbTime setFont:[UIFont systemFontOfSize:11]];
        _lbTime.textColor = [UIColor darkGrayColor];
        _lbTime.textAlignment = NSTextAlignmentRight;
    } else {
        _lbTime.hidden = YES;
    }
    
    UIImage *imageNotify = nil;
    
    if (systemNotifyItem.eNotifyType == e_notify_comment) {
        _lbNotifyName.text = @"有人回复了你的博文";
        _lbTotalNotify.text = [NSString stringWithFormat:@"此博文共%ld个回复", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_coach_comment)
    {
        _lbNotifyName.text = @"有人回复了你";
        _lbTotalNotify.text = [NSString stringWithFormat:@"此博文共%ld个点评", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_at)
    {
        _lbNotifyName.text = @"有人在博文中@了你";
        _lbTotalNotify.text = @"去看看是什么事吧！";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_record)
    {
        _lbNotifyName.text = @"有人提交记录了";
        _lbTotalNotify.text = @"去看看Ta的运动记录";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_coach_pass_comment)
    {
        _lbNotifyName.text = @"跑步成绩通过审核";
        _lbTotalNotify.text = @"请查看审核通过的运动记录！";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_coach_npass_comment)
    {
        _lbNotifyName.text = @"跑步成绩被拒绝";
        _lbTotalNotify.text = @"请查看被拒绝的运动记录！";
        imageNotify = [UIImage imageNamed:@"me-reply-icon"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_thumb)
    {
        _lbNotifyName.text = @"有人赞了你的博文";
        _lbTotalNotify.text = [NSString stringWithFormat:@"此博文共%ld个赞", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"contact-system-info-hearted"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_subscribe)
    {
        _lbNotifyName.text = [NSString stringWithFormat:@"%@关注了你", systemNotifyItem.strNikeName];
        _lbTotalNotify.text = @"去Ta的主页看看吧";
        imageNotify = [UIImage imageNamed:@"other-info-follow"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_reward)
    {
        _lbNotifyName.text = @"有人给你打赏了";
        _lbTotalNotify.text = [NSString stringWithFormat:@"此博文共得赏%ld个金币", systemNotifyItem.unTotalCount / 100000000];
        imageNotify = [UIImage imageNamed:@"contact-system-info-money"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_tx)
    {
        _lbNotifyName.text = @"有人给你转帐了";
        _lbTotalNotify.text = [NSString stringWithFormat:@"本次共转账%ld个金币", systemNotifyItem.unTotalCount];
        imageNotify = [UIImage imageNamed:@"contact-system-info-money"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_send_heart)
    {
        _lbNotifyName.text = @"有人给你发送了心跳";
        _lbTotalNotify.text = @"和Ta一起感知运动的韵律吧";
        imageNotify = [UIImage imageNamed:@"contact-system-info-heartRate"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_receive_heart)
    {
        _lbNotifyName.text = @"有人接收了你的心跳";
        _lbTotalNotify.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-info-heartRate"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_runshare)
    {
        _lbNotifyName.text = @"有人约你一起跑步了";
        _lbTotalNotify.text = @"和Ta一起跑步吧";
        imageNotify = [UIImage imageNamed:@"contact-system-run-together"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_runshared)
    {
        _lbNotifyName.text = @"有人接受约跑了";
        _lbTotalNotify.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-run-together"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_postshare)
    {
        _lbNotifyName.text = @"有人发表了新文章";
        _lbTotalNotify.text = @"去给Ta的文章点个赞吧";
        imageNotify = [UIImage imageNamed:@"contact-system-praise-ask"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_postshared)
    {
        _lbNotifyName.text = @"有人赞了你的博文";
        _lbTotalNotify.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-praise-ask"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_pkshare)
    {
        _lbNotifyName.text = @"有人向你发起了挑战";
        _lbTotalNotify.text = @"去接受Ta的挑战吧";
        imageNotify = [UIImage imageNamed:@"contact-system-PK"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_pkshared)
    {
        _lbNotifyName.text = @"有人接受了你的挑战";
        _lbTotalNotify.text = @"Ta成为你的朋友了，去聊聊吧！";
        imageNotify = [UIImage imageNamed:@"contact-system-PK"];
    }
    else if(systemNotifyItem.eNotifyType == e_notify_info)
    {
        _lbNotifyName.text = @"去领取50个金币奖励";
        _lbTotalNotify.text = @"速度完善个人资料吧！";
        imageNotify = [UIImage imageNamed:@"other-info-follow"];
    }
    
    [_notifyImageView setImage:imageNotify];
    
    if (systemNotifyItem.unReadCount > 0) {
        _imgViewNum.userInteractionEnabled = NO;
        _imgViewNum.hidden = NO;
        
        _lbNum.userInteractionEnabled = NO;
        _lbNum.backgroundColor = [UIColor clearColor];
        _lbNum.textColor = [UIColor whiteColor];
        _lbNum.font = [UIFont boldSystemFontOfSize:10];
        _lbNum.textAlignment = NSTextAlignmentCenter;
        _lbNum.text = [NSString stringWithFormat:@"%ld", systemNotifyItem.unReadCount];
        
        if (systemNotifyItem.unReadCount >= 100) {
            _lbNum.hidden = YES;
            _imgViewNum.frame = CGRectMake(CGRectGetMaxX(_notifyImageView.frame) - 4, 2, 9, 9);
            _imgViewNum.image = [UIImage imageNamed:@"info-reddot-small"];
        }
        else
        {
            _lbNum.hidden = NO;
            _imgViewNum.frame = CGRectMake(CGRectGetMaxX(_notifyImageView.frame) - 8, 2, 16, 16);
            _imgViewNum.image = [UIImage imageNamed:@"info-reddot"];
        }
        
        _lbNum.frame = _imgViewNum.frame;
    }
    else
    {
        _imgViewNum.hidden = YES;
        _lbNum.hidden = YES;
    }
}

-(void)setSystemNotifyItem:(SystemNotifyItem *)systemNotifyItem {
    _systemNotifyItem = systemNotifyItem;
    [self generateNormalCell:systemNotifyItem];
    [self generateDelView:systemNotifyItem];
    
    if (_bEditMode) {
        _viewDel.hidden = NO;
        _viewSystem.hidden = YES;
    }
    else
    {
        _viewDel.hidden = YES;
        _viewSystem.hidden = NO;
    }
}

+(CGFloat)heightOfCell{
    return 52;
}

@end
