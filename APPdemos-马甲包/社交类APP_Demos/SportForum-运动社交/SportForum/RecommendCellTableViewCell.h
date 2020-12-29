//
//  RecommendCellTableViewCell.h
//  SportForum
//
//  Created by liyuan on 12/17/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImgClickBlock)(void);
typedef void (^AttentionClickBlock)(void);

@interface RecommendCellTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UIImageView *sexTypeImageView;
@property(nonatomic, strong) UIImageView *locImageView;
@property(nonatomic, strong) UIImageView *imgViePhone;
@property(nonatomic, strong) UIImageView *imgVieCoach;
@property(nonatomic, strong) UILabel *lbNickName;
@property(nonatomic, strong) UILabel *lbScore;
@property(nonatomic, strong) UILabel *lbAge;
@property(nonatomic, strong) UILabel *lbLevel;
@property(nonatomic, strong) UIImageView *imgLevelBK;
@property(nonatomic, strong) UILabel *lbTotalDistance;
@property(nonatomic, strong) UILabel *lbContent;
@property(nonatomic, strong) UILabel *lbLocation;
@property(nonatomic, strong) UILabel *lbSep1;
@property(nonatomic, strong) UILabel *lbSep2;
@property(nonatomic, strong) UILabel *lbSep3;
@property(nonatomic, strong) UIView *viewCell;
@property(nonatomic, strong) CSButton *btnImg;
@property(nonatomic, strong) CSButton *btnAttention;
@property(nonatomic, strong) ImgClickBlock imgClickBlock;
@property(nonatomic, strong) AttentionClickBlock attentionClickBlock;
@property(nonatomic, strong) LeaderBoardItem *leaderBoardItem;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
