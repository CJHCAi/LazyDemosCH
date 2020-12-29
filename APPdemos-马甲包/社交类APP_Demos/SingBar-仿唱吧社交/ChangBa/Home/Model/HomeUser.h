//
//  HomeUser.h
//
//  Created by   on 16/9/22
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeUserlevel.h"

@interface HomeUser : NSObject 

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) double vip;
@property (nonatomic, strong) NSString *valid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, assign) double duetcount;
@property (nonatomic, assign) double ismember;
@property (nonatomic, strong) NSString *headphoto;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *homeurl;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *viptitle;
@property (nonatomic, assign) double memberlevel;
@property (nonatomic, strong) NSString *astro;
@property (nonatomic, strong) NSString *memberid;
@property (nonatomic, strong) NSString *agetag;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) HomeUserlevel *userlevel;




@end
