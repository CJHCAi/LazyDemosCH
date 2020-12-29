//
//  JFGroup.h
//  StepUp
//
//  Created by syfll on 15/4/29.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFUserModel.h"
@interface JFGroup : NSObject

@property (nonatomic , copy) NSString* groupName;
@property (nonatomic , copy) NSString* groupID;
@property (nonatomic , strong) NSArray *groupMember;
@property (nonatomic , strong) JFUserModel *owner;
@end
