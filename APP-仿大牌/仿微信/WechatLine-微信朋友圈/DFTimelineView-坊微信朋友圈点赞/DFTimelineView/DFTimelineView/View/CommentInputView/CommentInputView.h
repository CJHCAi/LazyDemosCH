//
//  CommentInputView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/10.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//



@protocol CommentInputViewDelegate <NSObject>

@required

-(void) onCommentCreate:(long long ) commentId text:(NSString *) text;


@end




@interface CommentInputView : UIView


@property (nonatomic, assign) id<CommentInputViewDelegate> delegate;

@property (nonatomic, assign) long long commentId;

-(void) addNotify;

-(void) removeNotify;

-(void) addObserver;

-(void) removeObserver;

-(void) show;

-(void) setPlaceHolder:(NSString *) text;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com