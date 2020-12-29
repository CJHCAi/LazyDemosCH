//
//  ArticlesInfo.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "BaseArray.h"
#import "UserInfo.h"
#import "SportRecordInfo.h"

@interface ArticlesInfo : BaseObject

@property(strong, nonatomic) NSString *page_frist_id;
@property(strong, nonatomic) NSString *page_last_id;
@property(assign, nonatomic) NSUInteger exp_effect;

//id type ArticlesObject
@property(strong, nonatomic) BaseArray *articles_without_content;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface ArticlesObject : BaseObject

@property(strong, nonatomic) NSString *parent_article_id;
@property(strong, nonatomic) NSString *article_id;
@property(strong, nonatomic) NSString *cover_image;
@property(strong, nonatomic) NSString *cover_text;
@property(strong, nonatomic) NSString *relation;
@property(strong, nonatomic) NSString *author;
@property(strong, nonatomic) NSString *refer;
@property(strong, nonatomic) NSString *refer_article;

//文章类型post(普通文章,default)/record(运动记录分享)
@property(strong, nonatomic) NSString *type;

//id type UserInfo
@property(strong, nonatomic) UserInfo *authorInfo;

//id type SportRecordInfo
@property(strong, nonatomic) SportRecordInfo *record;

//id type ArticleSegmentObject
@property(strong, nonatomic) BaseArray *article_segments;

@property(strong, nonatomic) BaseArray *thumb_users;

@property(strong, nonatomic) NSString *content;

@property(assign, nonatomic) long long time;
@property(assign, nonatomic) float longitude;
@property(assign, nonatomic) float latitude;
@property(assign, nonatomic) BOOL bExpand;
@property(assign, nonatomic) BOOL isThumbed;
@property(assign, nonatomic) BOOL isPublic;
@property(assign, nonatomic) NSUInteger thumb_count;
@property(assign, nonatomic) NSUInteger sub_article_count;
@property(assign, nonatomic) NSUInteger coach_review_count;
@property(assign, nonatomic) long long reward_total;
@property(assign, nonatomic) NSUInteger new_thumb_count;
@property(assign, nonatomic) NSUInteger new_sub_article_count;

-(id)init;

@end

@interface ArticleSegmentObject : BaseObject
//TEXT/IMAGE/VIDEO
@property(strong, nonatomic) NSString *seg_type;
@property(strong, nonatomic) NSString *seg_content;
@end