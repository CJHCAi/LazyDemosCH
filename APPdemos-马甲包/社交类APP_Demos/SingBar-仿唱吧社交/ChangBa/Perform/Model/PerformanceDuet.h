//
//  PerformanceDuet.h
//
//  Created by   on 16/9/23
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PerformanceSong.h"
#import "PerformanceUser.h"

@interface PerformanceDuet : NSObject

@property (nonatomic, strong) NSString *previousduetid;
@property (nonatomic, strong) NSString *duetpath;
@property (nonatomic, strong) NSString *duetid;
@property (nonatomic, assign) double isdeleted;
@property (nonatomic, assign) BOOL ispublic;
@property (nonatomic, strong) NSString *duettitle;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, assign) double isnew;
@property (nonatomic, assign) double listen_num;
@property (nonatomic, strong) NSString *audiosegments;
@property (nonatomic, strong) PerformanceSong *song;
@property (nonatomic, strong) NSString *workscount;
@property (nonatomic, strong) NSString *duetlinks;
@property (nonatomic, assign) double forward_num;
@property (nonatomic, strong) NSString *responsecount;
@property (nonatomic, strong) PerformanceUser *user;

@end
