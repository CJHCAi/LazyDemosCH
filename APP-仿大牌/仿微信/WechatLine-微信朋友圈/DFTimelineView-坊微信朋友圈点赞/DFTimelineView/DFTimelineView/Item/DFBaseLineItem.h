//
//  DFBaseLineItem.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//


typedef NS_ENUM(NSUInteger, LineItemType){
    LineItemTypeTextImage,
    LineItemTypeShare,
};


@interface DFBaseLineItem : NSObject

//时间轴itemID 需要全局唯一 一般服务器下发
@property (nonatomic, assign) long long itemId;

@property (nonatomic, assign) LineItemType itemType;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *userAvatar;

@property (nonatomic, strong) NSString *title;


@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign) long long ts;


@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *comments;


@property (nonatomic, strong) NSMutableAttributedString *likesStr;

@property (nonatomic, strong) NSMutableArray *commentStrArray;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com