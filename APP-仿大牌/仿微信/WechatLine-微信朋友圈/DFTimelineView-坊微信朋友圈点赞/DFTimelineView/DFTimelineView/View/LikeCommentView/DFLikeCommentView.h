//
//  DFLikeCommentView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/28.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

@protocol DFLikeCommentViewDelegate <NSObject>

@required
-(void) onClickUser:(NSUInteger) userId;
-(void) onClickComment:(long long) commentId;

@end



@interface DFLikeCommentView : UIView


@property (nonatomic, assign) id<DFLikeCommentViewDelegate> delegate;


-(void) updateWithItem:(DFBaseLineItem *) item;

+(CGFloat) getHeight:(DFBaseLineItem *) item maxWidth:(CGFloat)maxWidth;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com