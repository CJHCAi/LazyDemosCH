//
//  DFLineCommentItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


@interface DFLineCommentItem : NSObject

@property (nonatomic, assign) long long commentId;

@property (nonatomic, assign) NSUInteger userId;

@property (nonatomic, strong) NSString *userNick;

@property (nonatomic, assign) NSUInteger replyUserId;

@property (nonatomic, strong) NSString *replyUserNick;

@property (nonatomic, strong) NSString *text;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com