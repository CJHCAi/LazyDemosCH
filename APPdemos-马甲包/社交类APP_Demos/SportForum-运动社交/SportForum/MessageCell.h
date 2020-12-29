//
//  MessageCell.h
//  SportForum
//
//  Created by liyuan on 14-6-25.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSButton;

@interface MessageItem : NSObject

@property(nonatomic, assign) BOOL isReceived;
@property(nonatomic, assign) NSUInteger nMsgType;
@property(nonatomic, copy) NSString* msgId;
@property(nonatomic, copy) NSString* userImage;
@property(nonatomic, copy) NSString* content;
@property(nonatomic, strong) NSDate* time;

@end

@interface MessageCell : UITableViewCell

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UILabel *lbTime;
@property(nonatomic, strong) CSButton *btnMsgView;
@property(nonatomic, strong) MessageItem *messageItem;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
+(CGFloat)heightOfCell:(NSString*)content;

@end