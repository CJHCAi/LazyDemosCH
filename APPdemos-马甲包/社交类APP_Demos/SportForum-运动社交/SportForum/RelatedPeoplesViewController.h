//
//  RelatedPeoplesViewController.h
//  SportForum
//
//  Created by liyuan on 14-9-15.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    e_related_people_nearby,
    e_related_people_friend,
    e_related_people_attention,
    e_related_people_fans,
    e_related_people_defriend,
    e_related_people_weibo,
    e_related_people_thumb,
    e_related_people_reward,
}e_related_people_type;

@interface RelatedPeoplesViewController : BaseViewController

@property (assign, nonatomic) e_related_people_type eRelatedType;
@property (strong, nonatomic) NSString* strUserId;
@property (strong, nonatomic) NSString* strArticleId;

@end
