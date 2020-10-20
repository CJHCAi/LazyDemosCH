//
//  DFBaseLineCell.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "DFBaseLineItem.h"

#import "Const.h"


#define Margin 15

#define Padding 10

#define UserAvatarSize 40

#define  BodyMaxWidth [UIScreen mainScreen].bounds.size.width - UserAvatarSize - 3*Margin




@protocol DFLineCellDelegate <NSObject>

@optional
-(void) onLike:(long long) itemId;
-(void) onComment:(long long) itemId;

-(void) onClickUser:(NSUInteger) userId;

-(void) onClickComment:(long long) commentId itemId:(long long) itemId;


@end

@interface DFBaseLineCell : UITableViewCell


@property (nonatomic, strong) UIView *bodyView;

@property (nonatomic, assign) id<DFLineCellDelegate> delegate;


-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getCellHeight:(DFBaseLineItem *) item;

-(void)updateBodyView:(CGFloat) height;

-(void) hideLikeCommentToolbar;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com