//
//  RecommendCircleTableViewCell.m
//  SportForum
//
//  Created by liyuan on 3/5/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "RecommendCircleTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "STTweetLabel.h"

#define LINE_HEIGHT 18

@interface RecommendCircleTableViewCell ()

@end

@implementation RecommendCircleTableViewCell
{
    UIImageView *thubmersImgView[5];
    UIImageView *articleImgView[6];
    CSButton *btnArticleImg[6];
    UIView *coverView;
    CSButton *coverBtn;
    CSButton *_btnProfile;
    BOOL bShowMore;
    
    UIView *_viewBoard;
    // For Sport Article Control
    UILabel *_lbSportDistance;
    UILabel *_lbSportDuration;
    UILabel *_lbSportDate;
    UILabel *_lbSportSpeedSet;
    UILabel *_lbSportSpeed;
    UILabel *_lbSportCal;
    UILabel *_lbSportHeatRate;
    UILabel *_lbSportSource;
    UILabel *_lbSportAuth;
    UILabel *_lbSportLock;
    UILabel *_lbSep3;
    
    UIImageView *_imgViewDate;
    UIImageView *_imgViewSpeedSet;
    UIImageView *_imgViewSpeed;
    UIImageView *_imgViewCal;
    UIImageView *_imgViewHeatRate;
    UIImageView *_imgViewAuth;
    UIImageView *_imgViewLock;
    
    UIImageView *_imgViewTutor;
    UIImageView *_imgViewDelete;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier WithContent:(NSString*)strContent
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _viewBoard = [[UIView alloc]init];
        _viewBoard.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_viewBoard];
        
        bShowMore = NO;
        _userImageView = [[UIImageView alloc]init];
        _userImageView.layer.cornerRadius = 5.0;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_viewBoard addSubview:_userImageView];
        
        _sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _sexTypeImageView.backgroundColor = [UIColor clearColor];
        [_viewBoard addSubview:_sexTypeImageView];
        
        _imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgViePhone.backgroundColor = [UIColor clearColor];
        [_viewBoard addSubview:_imgViePhone];
        
        _imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgVieCoach.backgroundColor = [UIColor clearColor];
        [_viewBoard addSubview:_imgVieCoach];
        
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.layer.cornerRadius = 5.0;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_viewBoard addSubview:_coverImageView];
        
        coverView = [[UIView alloc]init];
        coverView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
        [_viewBoard addSubview:coverView];
        
        coverBtn = [CSButton buttonWithType:UIButtonTypeCustom];
        coverBtn.backgroundColor = [UIColor clearColor];
        coverBtn.actionBlock = _contentViewClickBlock;
        [_viewBoard addSubview:coverBtn];
        
        _locImageView = [[UIImageView alloc]init];
        [_viewBoard addSubview:_locImageView];
        
        _thumbMoreImaView = [[UIImageView alloc]init];
        [_viewBoard addSubview:_thumbMoreImaView];
        
        _thumbImageView = [[UIImageView alloc]init];
        [_viewBoard addSubview:_thumbImageView];
        
        _replyImageView = [[UIImageView alloc]init];
        [_viewBoard addSubview:_replyImageView];
        
        _rewardImageView = [[UIImageView alloc]init];
        [_viewBoard addSubview:_rewardImageView];
        
        _shareImageView = [[UIImageView alloc]init];
        [_viewBoard addSubview:_shareImageView];
        
        _imgViewTutor = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewTutor];
        
        _imgViewDelete = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewDelete];
        
        for (NSUInteger i = 0; i < 6; i++) {
            articleImgView[i] = [[UIImageView alloc]init];
            [_viewBoard addSubview:articleImgView[i]];
            
            btnArticleImg[i] = [CSButton buttonWithType:UIButtonTypeCustom];
            [_viewBoard addSubview:btnArticleImg[i]];
        }
        
        for (NSUInteger i = 0; i < 5; i++) {
            thubmersImgView[i] = [[UIImageView alloc]init];
            [_viewBoard addSubview:thubmersImgView[i]];
        }
        
        _lbUserName = [[UILabel alloc]init];
        _lbUserName.backgroundColor = [UIColor clearColor];
        _lbUserName.textColor = [UIColor blackColor];
        _lbUserName.font = [UIFont boldSystemFontOfSize:14];
        _lbUserName.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbUserName];
        
        NSRange range = [strContent rangeOfString:@"@"];//判断字符串是否包含
        
        if (range.length >0)//包含
        {
            _lbContent = [[STTweetLabel alloc]init];
            
            __weak __typeof(self) weakSelf = self;
            
            ((STTweetLabel*)_lbContent).detectionBlock = ^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
                
                __typeof(self) strongSelf = weakSelf;
                
                if ([string hasPrefix:@"@"] && strongSelf->_contentAtClickBlock != nil) {
                    string = [string substringFromIndex:1];
                    strongSelf->_contentAtClickBlock(string);
                }
                
                //            NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
                //            _displayLabel.text = [NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""];
            };
        }
        else
        {
            _lbContent = [[UILabel alloc]init];
        }

        _lbContent.backgroundColor = [UIColor clearColor];
        _lbContent.textColor = [UIColor darkGrayColor];
        //_lbContent.colorHashtag = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0];
        //_lbContent.colorLink = [UIColor darkGrayColor];
        _lbContent.font = [UIFont boldSystemFontOfSize:12];
        _lbContent.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbContent];
        
        _lbPublishTime = [[UILabel alloc]init];
        _lbPublishTime.backgroundColor = [UIColor clearColor];
        _lbPublishTime.textColor = [UIColor lightGrayColor];
        _lbPublishTime.font = [UIFont boldSystemFontOfSize:12];
        _lbPublishTime.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbPublishTime];
        
        _lbLocation = [[UILabel alloc]init];
        _lbLocation.backgroundColor = [UIColor clearColor];
        _lbLocation.textColor = [UIColor lightGrayColor];
        _lbLocation.font = [UIFont boldSystemFontOfSize:12];
        _lbLocation.textAlignment = NSTextAlignmentRight;
        [_viewBoard addSubview:_lbLocation];
        
        _lbSep0 = [[UILabel alloc]init];
        _lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        [_viewBoard addSubview:_lbSep0];
        
        _lbSep1 = [[UILabel alloc]init];
        _lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        [_viewBoard addSubview:_lbSep1];
        
        _lbSep2 = [[UILabel alloc]init];
        _lbSep2.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        [_viewBoard addSubview:_lbSep2];
        
        _lbThumbTitle = [[UILabel alloc]init];
        _lbThumbTitle.backgroundColor = [UIColor clearColor];
        _lbThumbTitle.textColor = [UIColor lightGrayColor];
        _lbThumbTitle.font = [UIFont boldSystemFontOfSize:12];
        _lbThumbTitle.textAlignment = NSTextAlignmentRight;
        [_viewBoard addSubview:_lbThumbTitle];
        
        _lbThumbCount = [[UILabel alloc]init];
        _lbThumbCount.backgroundColor = [UIColor clearColor];
        _lbThumbCount.textColor = [UIColor lightGrayColor];
        _lbThumbCount.font = [UIFont boldSystemFontOfSize:14];
        _lbThumbCount.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbThumbCount];
        
        _lbReplyCount = [[UILabel alloc]init];
        _lbReplyCount.backgroundColor = [UIColor clearColor];
        _lbReplyCount.textColor = [UIColor lightGrayColor];
        _lbReplyCount.font = [UIFont boldSystemFontOfSize:14];
        _lbReplyCount.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbReplyCount];
        
        _lbRewardCount = [[UILabel alloc]init];
        _lbRewardCount.backgroundColor = [UIColor clearColor];
        _lbRewardCount.textColor = [UIColor lightGrayColor];
        _lbRewardCount.font = [UIFont boldSystemFontOfSize:14];
        _lbRewardCount.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbRewardCount];
        
        _lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbAge.backgroundColor = [UIColor clearColor];
        _lbAge.textColor = [UIColor whiteColor];
        _lbAge.font = [UIFont systemFontOfSize:10];
        _lbAge.textAlignment = NSTextAlignmentRight;
        [_viewBoard addSubview:_lbAge];
        
        _btnTutor = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnTutor.backgroundColor = [UIColor clearColor];
        _btnTutor.actionBlock = _tutorBlock;
        [_viewBoard addSubview:_btnTutor];
        
        _btnDelete = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnDelete.backgroundColor = [UIColor clearColor];
        _btnDelete.actionBlock = _deleteBlock;
        [_viewBoard addSubview:_btnDelete];
        
        _btnShowMore = [CSButton buttonWithType:UIButtonTypeCustom];
        [_btnShowMore.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _btnShowMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_btnShowMore setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _btnShowMore.backgroundColor = [UIColor clearColor];
        _btnShowMore.actionBlock = _showMoreBlock;
        [_viewBoard addSubview:_btnShowMore];
        
        _btnThumbsMore = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnThumbsMore.backgroundColor = [UIColor clearColor];
        _btnThumbsMore.actionBlock = _thumbMoreBlock;
        [_viewBoard addSubview:_btnThumbsMore];
        
        _btnThumb = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnThumb.backgroundColor = [UIColor clearColor];
        _btnThumb.actionBlock = _thumbClickBlock;
        [_viewBoard addSubview:_btnThumb];
        
        _btnReply = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnReply.backgroundColor = [UIColor clearColor];
        _btnReply.actionBlock = _replyClickBlock;
        [_viewBoard addSubview:_btnReply];
        
        _btnReward = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnReward.backgroundColor = [UIColor clearColor];
        _btnReward.actionBlock = _rewardClickBlock;
        [_viewBoard addSubview:_btnReward];
        
        _btnShare = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnShare.backgroundColor = [UIColor clearColor];
        _btnShare.actionBlock = _contentViewClickBlock;
        [_viewBoard addSubview:_btnShare];
        
        _btnProfile = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnProfile.backgroundColor = [UIColor clearColor];
        _btnProfile.actionBlock = _profileBlock;
        [_viewBoard addSubview:_btnProfile];
        
        [_viewBoard bringSubviewToFront:_coverImageView];
        [_viewBoard bringSubviewToFront:_lbContent];
        [_viewBoard bringSubviewToFront:coverBtn];
        [_viewBoard bringSubviewToFront:_btnProfile];
        
        // For Sport Article Control
        _lbSportDistance = [[UILabel alloc]init];
        _lbSportDistance.backgroundColor = [UIColor clearColor];
        _lbSportDistance.textColor = [UIColor blackColor];
        _lbSportDistance.font = [UIFont boldSystemFontOfSize:12];
        _lbSportDistance.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportDistance];
        
        _lbSportDuration = [[UILabel alloc]init];
        _lbSportDuration.backgroundColor = [UIColor clearColor];
        _lbSportDuration.textColor = [UIColor blackColor];
        _lbSportDuration.font = [UIFont boldSystemFontOfSize:12];
        _lbSportDuration.textAlignment = NSTextAlignmentRight;
        [_viewBoard addSubview:_lbSportDuration];
        
        _lbSportDate = [[UILabel alloc]init];
        _lbSportDate.backgroundColor = [UIColor clearColor];
        _lbSportDate.textColor = [UIColor darkGrayColor];
        _lbSportDate.font = [UIFont boldSystemFontOfSize:12];
        _lbSportDate.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportDate];
        
        _lbSportSpeedSet = [[UILabel alloc]init];
        _lbSportSpeedSet.backgroundColor = [UIColor clearColor];
        _lbSportSpeedSet.textColor = [UIColor darkGrayColor];
        _lbSportSpeedSet.font = [UIFont boldSystemFontOfSize:12];
        _lbSportSpeedSet.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportSpeedSet];
        
        _lbSportSpeed = [[UILabel alloc]init];
        _lbSportSpeed.backgroundColor = [UIColor clearColor];
        _lbSportSpeed.textColor = [UIColor darkGrayColor];
        _lbSportSpeed.font = [UIFont boldSystemFontOfSize:12];
        _lbSportSpeed.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportSpeed];
        
        _lbSportCal = [[UILabel alloc]init];
        _lbSportCal.backgroundColor = [UIColor clearColor];
        _lbSportCal.textColor = [UIColor darkGrayColor];
        _lbSportCal.font = [UIFont boldSystemFontOfSize:12];
        _lbSportCal.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportCal];
        
        _lbSportSource = [[UILabel alloc]init];
        _lbSportSource.backgroundColor = [UIColor clearColor];
        _lbSportSource.textColor = [UIColor darkGrayColor];
        _lbSportSource.font = [UIFont boldSystemFontOfSize:12];
        _lbSportSource.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportSource];
        
        _lbSportAuth = [[UILabel alloc]init];
        _lbSportAuth.backgroundColor = [UIColor clearColor];
        _lbSportAuth.textColor = [UIColor darkGrayColor];
        _lbSportAuth.font = [UIFont boldSystemFontOfSize:12];
        _lbSportAuth.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportAuth];
        
        _lbSportLock = [[UILabel alloc]init];
        _lbSportLock.backgroundColor = [UIColor clearColor];
        _lbSportLock.textColor = [UIColor darkGrayColor];
        _lbSportLock.font = [UIFont boldSystemFontOfSize:12];
        _lbSportLock.textAlignment = NSTextAlignmentRight;
        [_viewBoard addSubview:_lbSportLock];
        
        _lbSportHeatRate = [[UILabel alloc]init];
        _lbSportHeatRate.backgroundColor = [UIColor clearColor];
        _lbSportHeatRate.textColor = [UIColor darkGrayColor];
        _lbSportHeatRate.font = [UIFont boldSystemFontOfSize:12];
        _lbSportHeatRate.textAlignment = NSTextAlignmentLeft;
        [_viewBoard addSubview:_lbSportHeatRate];
        
        _lbSep3 = [[UILabel alloc]init];
        _lbSep3.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        [_viewBoard addSubview:_lbSep3];
        
        _imgViewDate = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewDate];
        
        _imgViewSpeedSet = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewSpeedSet];
        
        _imgViewSpeed = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewSpeed];
        
        _imgViewCal = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewCal];
        
        _imgViewHeatRate = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewHeatRate];
        
        _imgViewAuth = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewAuth];
        
        _imgViewLock = [[UIImageView alloc]init];
        [_viewBoard addSubview:_imgViewLock];
    }
    
    return self;
}

-(NSString*)convertToTaskStatus:(e_task_status) eTaskStatus
{
    NSString *strStatus = @"";
    
    switch (eTaskStatus) {
        case e_task_normal:
            strStatus = @"尚未执行";
            break;
        case e_task_finish:
            strStatus = @"审核已通过";
            break;
        case e_task_unfinish:
            strStatus = @"审核未通过";
            break;
        case e_task_authentication:
            strStatus = @"审核中";
            break;
        default:
            break;
    }
    
    return strStatus;
}

-(void)setArticlesObject:(ArticlesObject *)articlesObject {
    _articlesObject = articlesObject;

    coverBtn.actionBlock = _contentViewClickBlock;
    _btnTutor.actionBlock = _tutorBlock;
    _btnDelete.actionBlock = _deleteBlock;
    _btnShowMore.actionBlock = _showMoreBlock;
    _btnThumbsMore.actionBlock = _thumbMoreBlock;
    _btnThumb.actionBlock = _thumbClickBlock;
    _btnReply.actionBlock = _replyClickBlock;
    _btnReward.actionBlock = _rewardClickBlock;
    _btnShare.actionBlock = _contentViewClickBlock;
    _btnProfile.actionBlock = _profileBlock;
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:articlesObject.authorInfo.profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _userImageView.frame = CGRectMake(5, 10, 45, 45);
    
    _btnProfile.frame = CGRectMake(5, 10, 90, 45);
    
    _lbUserName.text = articlesObject.authorInfo.nikename;
    _lbUserName.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10, CGRectGetMinY(_userImageView.frame), 230, 20);

    _sexTypeImageView.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(_userImageView.frame) - 18, 40, 18);
    [_sexTypeImageView setImage:[UIImage imageNamed:[articlesObject.authorInfo.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
    
    _lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:articlesObject.authorInfo.birthday];
    _lbAge.frame = CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) - 25, CGRectGetMinY(_sexTypeImageView.frame) + 2, 20, 10);
    
    CGFloat fStartPoint = CGRectGetMaxX(_sexTypeImageView.frame) + 4;
    
    _imgViePhone.frame = CGRectMake(fStartPoint, CGRectGetMinY(_sexTypeImageView.frame) + 2, 8, 14);
    [_imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
    _imgViePhone.hidden = articlesObject.authorInfo.phone_number.length > 0 ? NO : YES;
    
    if (!_imgViePhone.hidden) {
        fStartPoint = CGRectGetMaxX(_imgViePhone.frame) + 2;
    }
    
    [_imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    _imgVieCoach.hidden = ([articlesObject.authorInfo.actor isEqualToString:@"coach"]) ? NO : YES;
    _imgVieCoach.frame = CGRectMake(fStartPoint, CGRectGetMinY(_sexTypeImageView.frame) - 1, 20, 20);
    
    if (articlesObject.coach_review_count > 0) {
        _imgViewTutor.hidden = NO;
        [_imgViewTutor setImage:[UIImage imageNamed:@"blog-tutor"]];
        
        _btnTutor.hidden = NO;
    }
    else
    {
        _imgViewTutor.hidden = YES;
        _btnTutor.hidden = YES;
    }
    
    if ([articlesObject.authorInfo.userid isEqualToString:[[ApplicationContext sharedInstance] accountInfo].userid]) {
        _imgViewDelete.hidden = NO;
        [_imgViewDelete setImage:[UIImage imageNamed:@"blog-delete"]];
        _imgViewDelete.frame = CGRectMake(310 - 30, CGRectGetMaxY(_userImageView.frame) - 18, 20, 20);
        
        _btnDelete.hidden = NO;
        _btnDelete.frame = CGRectMake(310 - 30, CGRectGetMaxY(_userImageView.frame) - 20, 30, 25);
        
        _imgViewTutor.frame = CGRectMake(CGRectGetMinX(_btnDelete.frame) - 32, CGRectGetMaxY(_userImageView.frame) - 18, 27, 17);
        _btnTutor.frame = CGRectMake(CGRectGetMinX(_btnDelete.frame) - 35, CGRectGetMaxY(_userImageView.frame) - 20, 35, 25);
    }
    else
    {
        _imgViewDelete.hidden = YES;
        _btnDelete.hidden = YES;
        
        _imgViewTutor.frame = CGRectMake(310 - 37, CGRectGetMaxY(_userImageView.frame) - 18, 27, 17);
        _btnTutor.frame = CGRectMake(310 - 37, CGRectGetMaxY(_userImageView.frame) - 20, 35, 25);
    }
    
    for(NSUInteger i = 0; i < 6; i++)
    {
        articleImgView[i].hidden = YES;
        btnArticleImg[i].hidden = YES;
    }
    
    CGRect rectPublish = _sexTypeImageView.frame;

    if (articlesObject.content.length > 0 || [articlesObject.type isEqualToString:@"repost"]) {
        coverView.hidden = NO;
        coverBtn.hidden = NO;
        _coverImageView.hidden = NO;
        _btnShowMore.hidden = YES;
        
        coverView.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10, CGRectGetMaxY(_userImageView.frame) + 10, 310 - (CGRectGetMaxX(_userImageView.frame) + 10) - 10, 55);
        coverBtn.frame = coverView.frame;
        
        _coverImageView.frame = CGRectMake(CGRectGetMinX(coverView.frame) + 5, CGRectGetMinY(coverView.frame) + 5, 45, 45);
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:articlesObject.cover_image]
                           placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        
        _lbContent.text = articlesObject.cover_text;
        _lbContent.numberOfLines = 3;
        _lbContent.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        _lbContent.frame = CGRectMake(CGRectGetMaxX(_coverImageView.frame) + 10, CGRectGetMinY(_coverImageView.frame), CGRectGetWidth(coverView.frame) - CGRectGetWidth(_coverImageView.frame) - 10 - 10, 45);
        rectPublish = coverView.frame;
        
        _lbSportDistance.hidden = YES;
        _lbSportDuration.hidden = YES;
        _imgViewDate.hidden = YES;
        _lbSportDate.hidden = YES;
        _imgViewSpeed.hidden = YES;
        _lbSportSpeed.hidden = YES;
        _imgViewCal.hidden = YES;
        _lbSportCal.hidden = YES;
        _lbSportSource.hidden = YES;
        _imgViewHeatRate.hidden = YES;
        _lbSportHeatRate.hidden = YES;
    }
    else
    {
        coverView.hidden = YES;
        coverBtn.hidden = YES;
        _coverImageView.hidden = YES;
        _btnShowMore.hidden = YES;
        
        BOOL bIsVideo = NO;
        NSMutableArray *arrImgs = [[NSMutableArray alloc]init];
        
        if ([articlesObject.type isEqualToString:@"record"]) {
            _lbContent.text = articlesObject.record.mood;
            [arrImgs addObjectsFromArray:articlesObject.record.sport_pics.data];
        }
        else
        {
            for (int index = 0; index < articlesObject.article_segments.data.count; index++) {
                
                ArticleSegmentObject* segobj = articlesObject.article_segments.data[index];
                
                if ([segobj.seg_type isEqualToString:@"IMAGE"] && segobj.seg_content.length > 0) {
                    [arrImgs addObject:segobj.seg_content];
                }
                else if([segobj.seg_type isEqualToString:@"TEXT"] && segobj.seg_content.length > 0) {
                    _lbContent.text = segobj.seg_content;
                }
                else if([segobj.seg_type isEqualToString:@"VIDEO"] && segobj.seg_content.length > 0) {
                    bIsVideo = YES;
                    NSArray *list = [segobj.seg_content componentsSeparatedByString:@"###"];
                    [arrImgs addObject:list.firstObject];
                }
            }
        }
        
        if (_lbContent.text.length > 0) {
            _lbContent.hidden = NO;
            
            //CGSize lbSize = [_lbContent.text sizeWithFont:_lbContent.font
            //                            constrainedToSize:CGSizeMake(310 - (CGRectGetMaxX(_userImageView.frame) + 10) - 10, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            
            /*NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:_lbContent.text];
            
            NSArray *matchArray = [_lbContent.text componentsMatchedByRegex:@"@[^\\s]+\\s?"];
            
            for (NSString *str in matchArray) {
                NSRange start;
                NSUInteger nAddLocation = 0;
                NSString *strTemp = _lbContent.text;
                
                while (1)
                {
                    start = [strTemp rangeOfString:str];

                    if(start.location == NSNotFound)
                    {
                        break;
                    }
                    
                    [attributedStr addAttribute:NSForegroundColorAttributeName
                                          value:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]
                                          range:NSMakeRange(start.location + nAddLocation, start.length)];
                    strTemp = [strTemp substringWithRange:NSMakeRange(start.location+start.length, strTemp.length - start.location - start.length)];
                    nAddLocation += start.location+start.length;
                }
            }

            _lbContent.attributedText = attributedStr;*/
            
            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGSize lbSize = [_lbContent.text boundingRectWithSize:CGSizeMake(310 - (CGRectGetMaxX(_userImageView.frame) + 10) - 10, FLT_MAX)
                                                               options:options
                                                            attributes:@{NSFontAttributeName:_lbContent.font} context:nil].size;

            if (lbSize.height > 45) {
                _btnShowMore.hidden = NO;
                
                if (articlesObject.bExpand) {
                    _lbContent.numberOfLines = 0;
                    _lbContent.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10, CGRectGetMaxY(_userImageView.frame) + 10, 310 - (CGRectGetMaxX(_userImageView.frame) + 10) - 10, lbSize.height);
                    [_btnShowMore setTitle:@"收起全文" forState:UIControlStateNormal];
                }
                else
                {
                    _lbContent.numberOfLines = 3;
                    _lbContent.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
                    _lbContent.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10, CGRectGetMaxY(_userImageView.frame) + 10, 310 - (CGRectGetMaxX(_userImageView.frame) + 10) - 10, 44);
                    [_btnShowMore setTitle:@"展开全文" forState:UIControlStateNormal];
                }
                
                _btnShowMore.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10, CGRectGetMaxY(_lbContent.frame) + 5, 123, 20);
                rectPublish = _btnShowMore.frame;
            }
            else
            {
                _btnShowMore.hidden = YES;
                
                _lbContent.numberOfLines = 3;
                _lbContent.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
                _lbContent.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10, CGRectGetMaxY(_userImageView.frame) + 10, 310 - (CGRectGetMaxX(_userImageView.frame) + 10) - 10, lbSize.height + 5);
                [_btnShowMore setTitle:@"展开全文" forState:UIControlStateNormal];
                
                rectPublish = _lbContent.frame;
            }
        }
        else
        {
            _lbContent.hidden = YES;
        }
        
        if ([articlesObject.type isEqualToString:@"record"]) {
            _lbSportDistance.hidden = NO;
            _lbSportDistance.text = [NSString stringWithFormat:@"距离：%.2f km", articlesObject.record.distance / 1000.00];
            _lbSportDistance.frame = CGRectMake(CGRectGetMinX(rectPublish), CGRectGetMaxY(rectPublish) + 10, 100, 20);
            
            _lbSportDuration.hidden = NO;
            _lbSportDuration.text = [NSString stringWithFormat:@"持续时间：%ld分钟", articlesObject.record.duration / 60];
            _lbSportDuration.frame = CGRectMake(CGRectGetMaxX(_lbSportDistance.frame), CGRectGetMinY(_lbSportDistance.frame), 310 - 10 - CGRectGetMaxX(_lbSportDistance.frame), 20);
            
            _imgViewDate.hidden = NO;
            [_imgViewDate setImage:[UIImage imageNamed:@"data-record-startTime"]];
            _imgViewDate.frame = CGRectMake(CGRectGetMinX(_lbSportDistance.frame), CGRectGetMaxY(_lbSportDistance.frame) + 5, 20, 20);
            
            NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:articlesObject.record.begin_time];
            NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];

            _lbSportDate.hidden = NO;
            _lbSportDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
            _lbSportDate.frame = CGRectMake(CGRectGetMaxX(_imgViewDate.frame) + 5, CGRectGetMinY(_imgViewDate.frame), 115, 20);
            
            _imgViewSpeedSet.hidden = NO;
            [_imgViewSpeedSet setImage:[UIImage imageNamed:@"data-record-pace"]];
            _imgViewSpeedSet.frame = CGRectMake(CGRectGetMaxX(_lbSportDate.frame) + 5, CGRectGetMinY(_imgViewDate.frame), 20, 20);
            
            _lbSportSpeedSet.hidden = NO;
            _lbSportSpeedSet.frame = CGRectMake(CGRectGetMaxX(_imgViewSpeedSet.frame) + 5, CGRectGetMinY(_imgViewSpeedSet.frame), 310 - 10 - CGRectGetMaxX(_imgViewSpeedSet.frame), 20);
            
            NSInteger nSpeedSet = articlesObject.record.duration / (articlesObject.record.distance / 1000.00);
            _lbSportSpeedSet.text = [NSString stringWithFormat:@"%ld' %ld'' km", nSpeedSet / 60,   nSpeedSet % 60];

            _imgViewSpeed.hidden = NO;
            [_imgViewSpeed setImage:[UIImage imageNamed:@"data-record-speed"]];
            _imgViewSpeed.frame = CGRectMake(CGRectGetMinX(_lbSportDistance.frame), CGRectGetMaxY(_imgViewDate.frame) + 5, 20, 20);

            _lbSportSpeed.hidden = NO;
            _lbSportSpeed.text = [NSString stringWithFormat:@"%.2f km/h", (articlesObject.record.distance / 1000.00) / (articlesObject.record.duration / 3600.00)];
            _lbSportSpeed.frame = CGRectMake(CGRectGetMaxX(_imgViewSpeed.frame) + 5, CGRectGetMinY(_imgViewSpeed.frame), 115, 20);
            
            _imgViewCal.hidden = NO;
            [_imgViewCal setImage:[UIImage imageNamed:@"data-record-cal"]];
            _imgViewCal.frame = CGRectMake(CGRectGetMaxX(_lbSportSpeed.frame) + 5, CGRectGetMaxY(_imgViewDate.frame) + 5, 20, 20);
            
            _lbSportCal.hidden = NO;
            _lbSportCal.text = [NSString stringWithFormat:@"%.0f cal", articlesObject.record.weight * articlesObject.record.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)
            _lbSportCal.frame = CGRectMake(CGRectGetMaxX(_imgViewCal.frame) + 5, CGRectGetMinY(_imgViewCal.frame), 310 - 10 - CGRectGetMaxX(_imgViewCal.frame), 20);
            
            rectPublish = _imgViewSpeed.frame;
            
            if(articlesObject.record.heart_rate > 0)
            {
                _imgViewHeatRate.hidden = NO;
                [_imgViewHeatRate setImage:[UIImage imageNamed:@"data-record-heartRate"]];
                _imgViewHeatRate.frame = CGRectMake(CGRectGetMinX(_lbSportDistance.frame), CGRectGetMaxY(_imgViewSpeed.frame) + 5, 20, 20);
                
                _lbSportHeatRate.hidden = NO;
                _lbSportHeatRate.text = [NSString stringWithFormat:@"%ld 次/分", articlesObject.record.heart_rate];
                _lbSportHeatRate.frame = CGRectMake(CGRectGetMaxX(_imgViewHeatRate.frame) + 5, CGRectGetMinY(_imgViewHeatRate.frame), 310 - 10 - CGRectGetMaxX(_imgViewHeatRate.frame) - 5, 20);

                rectPublish = _imgViewHeatRate.frame;
            }
            else
            {
                _imgViewHeatRate.hidden = YES;
                _lbSportHeatRate.hidden = YES;
            }
            
            if (articlesObject.record.source.length > 0) {
                _lbSportSource.hidden = NO;
                _lbSportSource.text = [NSString stringWithFormat:@"数据来源：%@", articlesObject.record.source];
                _lbSportSource.frame = CGRectMake(CGRectGetMinX(_imgViewSpeed.frame), CGRectGetMaxY(rectPublish) + 5, 310 - 10 - CGRectGetMinX(_imgViewSpeed.frame), 20);
                rectPublish = _lbSportSource.frame;
            }
            else
            {
                _lbSportSource.hidden = YES;
            }
        }
        else
        {
            _lbSportDistance.hidden = YES;
            _lbSportDuration.hidden = YES;
            _imgViewDate.hidden = YES;
            _lbSportDate.hidden = YES;
            _imgViewSpeedSet.hidden = YES;
            _lbSportSpeedSet.hidden = YES;
            _imgViewSpeed.hidden = YES;
            _lbSportSpeed.hidden = YES;
            _imgViewCal.hidden = YES;
            _lbSportCal.hidden = YES;
            _imgViewHeatRate.hidden = YES;
            _lbSportHeatRate.hidden = YES;
            _lbSportSource.hidden = YES;
        }
        
        NSUInteger nImageCount = arrImgs.count;
        
        if(nImageCount > 6)
        {
            nImageCount = 6;
        }
        
        for(NSUInteger i = 0; i < nImageCount; i++)
        {
            articleImgView[i].hidden = NO;
            [articleImgView[i] sd_setImageWithURL:[NSURL URLWithString:arrImgs[i]]
                                 placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
            btnArticleImg[i].hidden = NO;
            
            __weak __typeof(self) weakSelf = self;
            btnArticleImg[i].actionBlock = ^void()
            {
                __typeof(self) strongSelf = weakSelf;
                
                if (strongSelf->_previewPhotoBlock != nil) {
                    strongSelf->_previewPhotoBlock(arrImgs, i, bIsVideo);
                }
            };
        }
        
        for(NSUInteger i = nImageCount; i < 6; i++)
        {
            articleImgView[i].hidden = YES;
            btnArticleImg[i].hidden = YES;
        }

        if (nImageCount == 1) {
            articleImgView[0].frame = CGRectMake(CGRectGetMinX(rectPublish), CGRectGetMaxY(rectPublish) + 10, 180, 180);
            btnArticleImg[0].frame = articleImgView[0].frame;
            rectPublish = articleImgView[0].frame;
            articleImgView[0].contentMode = UIViewContentModeScaleAspectFit;
            articleImgView[0].layer.masksToBounds = YES;
            
            if (bIsVideo) {
                [btnArticleImg[0] setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
            }
            else
            {
                [btnArticleImg[0] setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
        }
        else if(nImageCount > 1)
        {
            CGRect rect = CGRectMake(CGRectGetMinX(rectPublish), CGRectGetMaxY(rectPublish) + 10, 70, 70);
            
            for (int i = 0; i < nImageCount; i++) {
                if ((i - 1) % 3 == 2 && (i - 1) > 0) {
                    rect.origin = CGPointMake(CGRectGetMinX(rectPublish), CGRectGetMaxY(rect) + 10);
                }
                else
                {
                    rect.origin = CGPointMake(CGRectGetMinX(rectPublish) + 80 * (i % 3), CGRectGetMinY(rect));
                }
                
                btnArticleImg[i].frame = rect;
                articleImgView[i].frame = rect;
                articleImgView[i].contentMode = UIViewContentModeScaleAspectFill;
                articleImgView[i].layer.masksToBounds = YES;
            }
            
            rectPublish = rect;
        }
    }
    
    NSString *strTime = [[CommonUtility sharedInstance]compareCurrentTime:[NSDate dateWithTimeIntervalSince1970:articlesObject.time]];
    _lbPublishTime.text = [NSString stringWithFormat:[articlesObject.type isEqualToString:@"repost"] ? @"%@转发" : @"%@发布", strTime];
    _lbPublishTime.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(rectPublish) + 10, 150, 20);
    
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dArticleLon =  articlesObject.longitude;
    float dArticleLat = articlesObject.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dArticleLon OtherLat:dArticleLat];
    
    if (dDistance >= 0) {
        _locImageView.hidden = NO;
        _lbLocation.hidden = NO;
        _lbLocation.frame = CGRectMake(310 - 110, CGRectGetMaxY(rectPublish) + 10, 100, 20);
        
        if (dDistance < 1000) {
            _lbLocation.text = [NSString stringWithFormat:@"距离%.2f米", dDistance];
        }
        else
        {
            _lbLocation.text = [NSString stringWithFormat:@"距离%.2f公里", dDistance / 1000];
        }
        
        //CGSize lbSize = [_lbLocation.text sizeWithFont:_lbLocation.font
         //                           constrainedToSize:CGSizeMake(FLT_MAX, 20) lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize lbSize = [_lbLocation.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:_lbLocation.font} context:nil].size;
        
        _lbLocation.frame = CGRectMake(310 - lbSize.width - 10, CGRectGetMaxY(rectPublish) + 10, lbSize.width, 20);
        
        _locImageView.image = [UIImage imageNamed:@"status-location"];
        _locImageView.frame = CGRectMake(CGRectGetMinX(_lbLocation.frame) - 22, CGRectGetMaxY(rectPublish) + 13, 17, 17);
    }
    else
    {
        _locImageView.hidden = YES;
        _lbLocation.hidden = YES;
    }
    
    _lbSep0.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(_lbPublishTime.frame) + 5, 310 - CGRectGetMinX(_lbUserName.frame), 1);
    CGRect rectSep = _lbSep0.frame;
    
    if ([articlesObject.authorInfo.userid isEqualToString:[[ApplicationContext sharedInstance] accountInfo].userid] && [articlesObject.type isEqualToString:@"record"]) {
        NSString *strStatus;
        UIImage *img = nil;
        _imgViewAuth.hidden = NO;
        
        switch ([CommonFunction ConvertStringToTaskStatusType:articlesObject.record.status]) {
            case e_task_finish:
                strStatus = @"审核已通过";
                img = [UIImage imageNamed:@"task-finished"];
                break;
            case e_task_unfinish:
                strStatus = @"审核未通过";
                img = [UIImage imageNamed:@"task-fail"];
                break;
            case e_task_authentication:
                strStatus = @"审核中";
                img = [UIImage imageNamed:@"task-pendding"];
                break;
            default:
                break;
        }
        
        [_imgViewAuth setImage:img];
        _imgViewAuth.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(rectSep) + 5, img.size.width, img.size.height);
        
        _lbSportAuth.hidden = NO;
        _lbSportAuth.text = strStatus;
        _lbSportAuth.frame = CGRectMake(CGRectGetMaxX(_imgViewAuth.frame) + 5, CGRectGetMinY(_imgViewAuth.frame), 80, 20);
        
        _lbSportLock.hidden = NO;
        _lbSportLock.text = articlesObject.isPublic ? @"所有人可见" : @"仅自己可见";
        _lbSportLock.frame = CGRectMake(310 - 70, CGRectGetMinY(_imgViewAuth.frame), 60, 20);
        
        _imgViewLock.hidden = NO;
        [_imgViewLock setImage:[UIImage imageNamed:articlesObject.isPublic ? @"blog-public" : @"blog-private"]];
        _imgViewLock.frame = CGRectMake(310 - 70 - 23, CGRectGetMinY(_imgViewAuth.frame) + 2, 17, 17);
        
        _lbSep3.hidden = NO;
        _lbSep3.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(_imgViewAuth.frame) + 5, 310 - CGRectGetMinX(_lbUserName.frame), 1);
        rectSep = _lbSep3.frame;
    }
    else
    {
        _lbSportAuth.hidden = YES;
        _lbSportLock.hidden = YES;
        _lbSep3.hidden = YES;
        
        _imgViewAuth.hidden = YES;
        _imgViewLock.hidden = YES;
    }
    
    NSUInteger nCount = articlesObject.thumb_users.data.count;
    
    if (nCount > 0) {
        _lbThumbTitle.hidden = NO;
        _lbSep1.hidden = NO;
        _btnThumbsMore.hidden = NO;
        
        _btnThumbsMore.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(rectSep) + 5, MIN(4, nCount) * 50, 35);
        
        NSUInteger nPosition = CGRectGetMinX(_lbUserName.frame);
        
        for (NSUInteger i = 0; i < MIN(5, nCount); i++) {
            thubmersImgView[i].frame = CGRectMake(nPosition + i * 35, CGRectGetMaxY(rectSep) + 5, 25, 25);
            thubmersImgView[i].layer.masksToBounds = YES;
            thubmersImgView[i].layer.cornerRadius = 12.5;
            thubmersImgView[i].hidden = NO;
            [thubmersImgView[i] sd_setImageWithURL:[NSURL URLWithString:articlesObject.thumb_users.data[i]]
                                  placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        }
        
        for(NSUInteger i = MIN(5, nCount); i < 5; i++)
        {
            thubmersImgView[i].hidden = YES;
        }

        _thumbMoreImaView.hidden = (nCount > 5 ? NO : YES);
        _thumbMoreImaView.frame = CGRectMake(310 - 18, CGRectGetMidY(thubmersImgView[0].frame), 8, 16);
        _thumbMoreImaView.image = [UIImage imageNamed:@"arrow-1"];
        
        _lbThumbTitle.text = [NSString stringWithFormat:@"%lu人赞过", nCount];
        _lbThumbTitle.frame = CGRectMake(CGRectGetMinX(_thumbMoreImaView.frame) - 55, CGRectGetMidY(thubmersImgView[0].frame) - 10, 50, 20);
        
        _lbSep1.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(thubmersImgView[0].frame) + 5, 310 - CGRectGetMinX(_lbUserName.frame), 1);
        rectSep = _lbSep1.frame;

        
//        _lbThumbTitle.hidden = NO;
//        _lbSep1.hidden = NO;
//        _btnThumbsMore.hidden = NO;
//        
//        _btnThumbsMore.backgroundColor = [UIColor clearColor];
//        _btnThumbsMore.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(rectSep) + 5, MIN(4, nCount) * 50, 70);
//        _btnThumbsMore.actionBlock = _thumbMoreBlock;
//        
//        _lbThumbTitle.backgroundColor = [UIColor clearColor];
//        _lbThumbTitle.text = [NSString stringWithFormat:@"%lu个人赞过", nCount];
//        _lbThumbTitle.textColor = [UIColor lightGrayColor];
//        _lbThumbTitle.font = [UIFont boldSystemFontOfSize:12];
//        _lbThumbTitle.textAlignment = NSTextAlignmentLeft;
//        _lbThumbTitle.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(rectSep) + 5, 150, 20);
//        
//        NSUInteger nPosition = CGRectGetMinX(_lbUserName.frame);
//        
//        for (NSUInteger i = 0; i < MIN(4, nCount); i++) {
//            thubmersImgView[i].frame = CGRectMake(nPosition + i * 55, CGRectGetMaxY(_lbThumbTitle.frame) + 5, 45, 45);
//            thubmersImgView[i].layer.cornerRadius = 5.0;
//            thubmersImgView[i].layer.masksToBounds = YES;
//            thubmersImgView[i].hidden = NO;
//            [thubmersImgView[i] sd_setImageWithURL:[NSURL URLWithString:articlesObject.thumb_users.data[i]]
//                                  placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
//        }
//        
//        for(NSUInteger i = MIN(4, nCount); i < 4; i++)
//        {
//            thubmersImgView[i].hidden = YES;
//        }
//        
//        _thumbMoreImaView.hidden = (nCount > 4 ? NO : YES);
//        _thumbMoreImaView.frame = CGRectMake(310 - 18, CGRectGetMidY(thubmersImgView[0].frame) - 8, 8, 16);
//        _thumbMoreImaView.image = [UIImage imageNamed:@"arrow-1"];
//        
//        _lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
//        _lbSep1.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(thubmersImgView[0].frame) + 10, 310 - CGRectGetMinX(_lbUserName.frame), 1);
//        rectSep = _lbSep1.frame;
    }
    else
    {
        _lbThumbTitle.hidden = YES;
        _lbSep1.hidden = YES;
        _thumbMoreImaView.hidden = YES;
        _btnThumbsMore.hidden = YES;
        
        for(NSUInteger i = 0; i < 4; i++)
        {
            thubmersImgView[i].hidden = YES;
        }
    }
    
    _thumbImageView.frame = CGRectMake(CGRectGetMinX(_lbUserName.frame), CGRectGetMaxY(rectSep) + 10, 20, 20);
    
    if (articlesObject.isThumbed) {
        _thumbImageView.image = [UIImage imageNamed:@"blog-heart-2"];
    }
    else
    {
        _thumbImageView.image = [UIImage imageNamed:@"blog-heart-1"];
    }
    
    _lbThumbCount.text = [NSString stringWithFormat:@"%lu", nCount];
    _lbThumbCount.frame = CGRectMake(CGRectGetMaxX(_thumbImageView.frame) + 5, CGRectGetMinY(_thumbImageView.frame), 50, 20);
    
    _btnThumb.frame = CGRectMake(CGRectGetMinX(_thumbImageView.frame), CGRectGetMinY(_thumbImageView.frame) - 10, 75, 30);
    
    _replyImageView.frame = CGRectMake(CGRectGetMaxX(_lbThumbCount.frame), CGRectGetMinY(_thumbImageView.frame), 20, 20);
    _replyImageView.image = [UIImage imageNamed:@"blog-reply"];
    
    _lbReplyCount.text = [NSString stringWithFormat:@"%lu", _articlesObject.sub_article_count];
    _lbReplyCount.frame = CGRectMake(CGRectGetMaxX(_replyImageView.frame) + 5, CGRectGetMinY(_replyImageView.frame), 50, 20);
    
    _btnReply.frame = CGRectMake(CGRectGetMinX(_replyImageView.frame), CGRectGetMinY(_replyImageView.frame) - 10, 75, 30);
    
    _rewardImageView.frame = CGRectMake(CGRectGetMaxX(_lbReplyCount.frame), CGRectGetMinY(_thumbImageView.frame), 20, 20);
    _rewardImageView.image = [UIImage imageNamed:@"blog-money"];
    
    _lbRewardCount.text = [NSString stringWithFormat:@"%lld",  _articlesObject.reward_total / 100000000];
    _lbRewardCount.frame = CGRectMake(CGRectGetMaxX(_rewardImageView.frame) + 5, CGRectGetMinY(_rewardImageView.frame), 50, 20);
    
    _btnReward.frame = CGRectMake(CGRectGetMinX(_rewardImageView.frame), CGRectGetMinY(_rewardImageView.frame) - 10, 75, 30);
    
    _shareImageView.frame = CGRectMake(CGRectGetMaxX(_lbRewardCount.frame), CGRectGetMinY(_thumbImageView.frame), 20, 20);
    _shareImageView.image = [UIImage imageNamed:@"blog-share"];
    
    _btnShare.frame = CGRectMake(CGRectGetMinX(_shareImageView.frame), CGRectGetMinY(_thumbImageView.frame) - 10, 30, 30);
    
    _lbSep2.frame = CGRectMake(0, CGRectGetMaxY(_thumbImageView.frame) + 10, 310, 1);
    
    _viewBoard.frame = CGRectMake(0, 0, 310, CGRectGetMaxY(_lbSep2.frame));
    [self setFrame:CGRectMake(0, 0, 310, CGRectGetMaxY(_lbSep2.frame) + 10)];
}

- (void)twitterAccountClicked:(NSString *)link {
    if (_contentAtClickBlock != nil) {
        
        if ([link hasPrefix:@"@"]) {
            link = [link substringFromIndex:1];
        }
        
        _contentAtClickBlock(link);
    }
}

+(CGFloat)heightOfCell:(ArticlesObject*)articlesObject
{
    CGFloat fHeight = 0;
    
    if (articlesObject.bExpand) {
        NSString *text = @"楚天都市报讯 据《中国日报》报道 英国《每日邮报》6日称，大小约为地球3倍的格利泽581d行星是人类在太阳系之外发现的第一个位于宜居带中的行星，被称为超级地球。它距离地球22光年，在浩瀚的宇宙中算得上是“邻居”，而学者过去曾一度认为它根本不存在。格利泽581d围绕格利泽581公转，并且位于后者的宜居带中，是人类潜在的太空移民选择，人称超级地球。英国玛丽皇后大学的安格拉达-埃斯屈得教授说：格利泽581d存在与否事关重大，因为这是我们首次在另一个恒星的宜居带中发现类似地球的行星。";

        //CGSize lbSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:12]
        //                            constrainedToSize:CGSizeMake(310 - 50 - 10, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [text boundingRectWithSize:CGSizeMake(150, FLT_MAX)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
        fHeight += (45 + lbSize.height);
    }
    else
    {
        fHeight += 90;
    }
    
    fHeight += 25;
    
    NSMutableArray *arrImgs = [[NSMutableArray alloc]init];
    for (int index = 0; index < articlesObject.article_segments.data.count; index++) {
        
        ArticleSegmentObject* segobj = articlesObject.article_segments.data[index];
        
        if ([segobj.seg_type isEqualToString:@"IMAGE"]) {
            [arrImgs addObject:segobj.seg_content];
        }
    }

    if ([arrImgs count] > 0) {
        if ([arrImgs count] == 1 || [arrImgs count] > 3) {
            fHeight += 120;
        }
        else
        {
            fHeight += 60;
        }
    }
    
    fHeight += 36;
    
    if ([articlesObject.thumb_users.data count] > 0) {
        fHeight += 86;
    }
    
    fHeight += 41;
    
    NSLog(@"Current Cell Height is %f.", fHeight);
    return fHeight;
}

@end
