//
//  GroupInfo.h
//  SportForum
//
//  Created by liyuan on 14-8-18.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface GroupInfo : BaseObject

@end

@interface NewGroupInfo : BaseObject

@property(strong, nonatomic) NSString *group_id;
@property(strong, nonatomic) NSString *group_name;
@property(strong, nonatomic) NSString *group_image;
@property(strong, nonatomic) NSString *group_description;
@property(strong, nonatomic) NSString *country;
@property(strong, nonatomic) NSString *province;
@property(strong, nonatomic) NSString *city;
@property(strong, nonatomic) NSString *area;
@property(strong, nonatomic) NSString *location_desc;

@end