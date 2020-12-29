//
//  JFUserModel.h
//  StepUp
//
//  Created by syfll on 15/4/29.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFUserModel : NSObject

///用户的昵称
@property (nonatomic, copy) NSString *userName;
///用户在系统内的ID
@property (nonatomic, copy) NSString *userID;
///用户头像的url
@property (nonatomic, copy) NSString *userPortrait;
///好友列表
@property (nonatomic, strong) NSArray *friends;
///所属的群组
@property (nonatomic, strong) NSArray *groups;
@end
