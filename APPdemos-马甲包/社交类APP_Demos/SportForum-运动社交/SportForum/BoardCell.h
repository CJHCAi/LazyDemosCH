//
//  BoardCell.h
//  SportForum
//
//  Created by liyuan on 14-8-20.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PKClickBlock)(void);

@interface BoardCell : UITableViewCell

@property(nonatomic, strong) UILabel *lbBoardRank;
@property(nonatomic, strong) UIImageView *boardImageView;
@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UIImageView *sexTypeImageView;
@property(nonatomic, strong) UILabel *lbNickName;
@property(nonatomic, strong) UILabel *lbScore;
@property(nonatomic, strong) UILabel *lbAge;
@property(nonatomic, strong) UILabel *lbLevel;
//@property(nonatomic, strong) UIImageView *imgLevelBK;
@property(nonatomic, strong) UIImageView *viewBoard;
@property(nonatomic, strong) UILabel * lbNum;
@property(nonatomic, strong) UIImageView * imgViewNum;
@property(nonatomic, strong) UIImageView * imgViePhone;
@property(nonatomic, strong) UIImageView * imgVieCoach;
@property(nonatomic, strong) CSButton *btnPk;
@property(nonatomic, strong) LeaderBoardItem *leaderBoardItem;
@property(nonatomic, strong) PKClickBlock pkClickBlock;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell;

@end
