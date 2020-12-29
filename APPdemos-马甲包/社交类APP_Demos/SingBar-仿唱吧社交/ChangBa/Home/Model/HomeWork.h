//
//  HomeWork.h
//
//  Created by   on 16/9/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeVideo.h"
#import "HomeUser.h"
#import "HomeSong.h"
#import "HomeDuet.h"

@interface HomeWork : NSObject

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) double isprivate;
@property (nonatomic, assign) double egg_num;
@property (nonatomic, assign) double listen_num;
@property (nonatomic, assign) double forward_num;
@property (nonatomic, strong) NSString *workpath;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) HomeVideo *video;
@property (nonatomic, strong) NSString *duetid;
@property (nonatomic, assign) double comment_num;
@property (nonatomic, strong) HomeUser *user;
@property (nonatomic, strong) HomeSong *song;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL iscurusercollect;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double flower_num;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) HomeDuet *duet;
@property (nonatomic, strong) NSString *workid;
@property (nonatomic, assign) double collection_num;


@end
