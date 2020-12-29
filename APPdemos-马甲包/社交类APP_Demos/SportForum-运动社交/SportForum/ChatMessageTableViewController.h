//
//  ChatMessageTableViewController.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-27.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewController.h"

@interface ChatMessageTableViewController : XHMessageTableViewController

@property(nonatomic, strong) NSString* userId;
@property(nonatomic, strong) NSString* useProImage;
@property(nonatomic, strong) NSString* useNickName;
@property(nonatomic, strong) NSString* strDefaultText;

@property(nonatomic, assign) BOOL bTutorChat;
@property(nonatomic, assign) BOOL bNoSendAction;
@property(nonatomic, strong) NSString* strArticleId;

@end
