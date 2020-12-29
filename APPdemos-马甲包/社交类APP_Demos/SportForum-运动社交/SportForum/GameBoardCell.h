//
//  GameBoardCell.h
//  SportForum
//
//  Created by liyuan on 2/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportForum.h"

@interface GameBoardCell : UITableViewCell

@property(nonatomic, strong) UILabel *lbBoardRank;
@property(nonatomic, strong) UIImageView *boardImageView;
@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UIImageView *sexTypeImageView;
@property(nonatomic, strong) UILabel *lbNickName;
@property(nonatomic, strong) UILabel *lbScore;
@property(nonatomic, strong) UILabel *lbAge;
@property(nonatomic, strong) UILabel *lbTime;
@property(nonatomic, strong) UIImageView *viewBoard;
@property(nonatomic, strong) UIImageView * imgViePhone;
@property(nonatomic, strong) UIImageView * imgVieCoach;
@property(nonatomic, strong) LeaderBoardItem *leaderBoardItem;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
