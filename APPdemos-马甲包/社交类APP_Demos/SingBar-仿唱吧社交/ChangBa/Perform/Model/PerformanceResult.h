//
//  PerformanceResult.h
//
//  Created by   on 16/9/23
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PerformanceVideo.h"
#import "PerformanceUser.h"
#import "PerformanceSong.h"
#import "PerformanceDuet.h"

@interface PerformanceResult : NSObject

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
@property (nonatomic, strong) NSString *competitiontitle;
@property (nonatomic, strong) PerformanceVideo *video;
@property (nonatomic, assign) double hotscore;
@property (nonatomic, strong) NSString *duetid;
@property (nonatomic, assign) double comment_num;
@property (nonatomic, strong) PerformanceUser *user;
@property (nonatomic, strong) PerformanceSong *song;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL iscurusercollect;
@property (nonatomic, assign) double distance;
@property (nonatomic, strong) NSString *competitionid;
@property (nonatomic, assign) double flower_num;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) PerformanceDuet *duet;
@property (nonatomic, strong) NSString *workid;
@property (nonatomic, assign) double collection_num;


@end
