//
//  RecommendCircleTableViewCell.h
//  SportForum
//
//  Created by liyuan on 3/5/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSButton.h"

typedef void (^ProfileBlock)(void);
typedef void (^TutorBlock)(void);
typedef void (^DeleteBlock)(void);
typedef void (^ShowMoreBlock)(void);
typedef void (^ThumbMoreBlock)(void);
typedef void (^ThumbClickBlock)(void);
typedef void (^ReplyClickBlock)(void);
typedef void (^RewardClickBlock)(void);
typedef void (^ContentViewClickBlock)(void);
typedef void (^ContentAtClickBlock)(NSString* strAtName);
typedef void (^PreviewPhotoBlock)(NSMutableArray *imgUrlArray, NSUInteger nIndex, BOOL bVideo);

@interface RecommendCircleTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, strong) UIImageView *locImageView;
@property(nonatomic, strong) UIImageView *thumbMoreImaView;
@property(nonatomic, strong) UIImageView *thumbImageView;
@property(nonatomic, strong) UIImageView *replyImageView;
@property(nonatomic, strong) UIImageView *rewardImageView;
@property(nonatomic, strong) UIImageView *shareImageView;
@property(nonatomic, strong) UIImageView *sexTypeImageView;
@property(nonatomic, strong) UIImageView *imgViePhone;
@property(nonatomic, strong) UIImageView *imgVieCoach;

@property(nonatomic, strong) UILabel *lbUserName;
@property(nonatomic, strong) UILabel *lbContent;
@property(nonatomic, strong) UILabel *lbPublishTime;
@property(nonatomic, strong) UILabel *lbLocation;
@property(nonatomic, strong) UILabel *lbSep0;
@property(nonatomic, strong) UILabel *lbSep1;
@property(nonatomic, strong) UILabel *lbSep2;
@property(nonatomic, strong) UILabel *lbThumbTitle;
@property(nonatomic, strong) UILabel *lbThumbCount;
@property(nonatomic, strong) UILabel *lbReplyCount;
@property(nonatomic, strong) UILabel *lbRewardCount;
@property(nonatomic, strong) UILabel *lbAge;

@property(nonatomic, strong) CSButton *btnTutor;
@property(nonatomic, strong) CSButton *btnDelete;
@property(nonatomic, strong) CSButton *btnShowMore;
@property(nonatomic, strong) CSButton *btnThumbsMore;
@property(nonatomic, strong) CSButton *btnThumb;
@property(nonatomic, strong) CSButton *btnReply;
@property(nonatomic, strong) CSButton *btnReward;
@property(nonatomic, strong) CSButton *btnShare;

@property(nonatomic, strong) ArticlesObject* articlesObject;
@property(nonatomic, strong) ProfileBlock profileBlock;
@property(nonatomic, strong) TutorBlock tutorBlock;
@property(nonatomic, strong) DeleteBlock deleteBlock;
@property(nonatomic, strong) ShowMoreBlock showMoreBlock;
@property(nonatomic, strong) ThumbMoreBlock thumbMoreBlock;
@property(nonatomic, strong) ThumbClickBlock thumbClickBlock;
@property(nonatomic, strong) ReplyClickBlock replyClickBlock;
@property(nonatomic, strong) RewardClickBlock rewardClickBlock;
@property(nonatomic, strong) PreviewPhotoBlock previewPhotoBlock;
@property(nonatomic, strong) ContentViewClickBlock contentViewClickBlock;
@property(nonatomic, strong) ContentAtClickBlock contentAtClickBlock;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier WithContent:(NSString*)strContent;
+(CGFloat)heightOfCell:(ArticlesObject*)articlesObject;

@end