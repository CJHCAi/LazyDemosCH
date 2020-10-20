//
//  DFTimeLineViewController.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseLineItem.h"

#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"

#import "DFBaseTimeLineViewController.h"

@interface DFTimeLineViewController : DFBaseTimeLineViewController

-(void) addItem:(DFBaseLineItem *) item;

-(void) addLikeItem:(DFLineLikeItem *) likeItem itemId:(long long) itemId;

-(void) addCommentItem:(DFLineCommentItem *) commentItem itemId:(long long) itemId replyCommentId:(long long) replyCommentId;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com