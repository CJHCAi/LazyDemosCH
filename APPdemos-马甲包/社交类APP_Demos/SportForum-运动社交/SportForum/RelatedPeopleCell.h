//
//  RelatedPeopleCell.h
//  SportForum
//
//  Created by liyuan on 14-9-15.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelatedPeopleCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UIImageView *sexTypeImageView;
@property(nonatomic, strong) UIImageView *imgViePhone;
@property(nonatomic, strong) UIImageView *imgVieCoach;
@property(nonatomic, strong) UILabel *lbNickName;
@property(nonatomic, strong) UILabel *lbScore;
@property(nonatomic, strong) UILabel *lbAge;
@property(nonatomic, strong) UILabel *lbLevel;
//@property(nonatomic, strong) UIImageView *imgLevelBK;
@property(nonatomic, strong) UILabel *lbDistance;
@property(nonatomic, strong) UILabel *lbLoginTime;
@property(nonatomic, strong) UIImageView *viewRelated;
@property(nonatomic, assign) BOOL bRewardList;
@property(nonatomic, strong) LeaderBoardItem *leaderBoardItem;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
