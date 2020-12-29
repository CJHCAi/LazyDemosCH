//
//  HomeDuet.h
//
//  Created by   on 16/9/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeSong.h"
#import "HomeUser.h"

@interface HomeDuet : NSObject 

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
@property (nonatomic, strong) HomeSong *song;
@property (nonatomic, strong) NSString *workscount;
@property (nonatomic, strong) NSString *duetlinks;
@property (nonatomic, assign) double forward_num;
@property (nonatomic, strong) NSString *responsecount;
@property (nonatomic, strong) HomeUser *user;



@end
