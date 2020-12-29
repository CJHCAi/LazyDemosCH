//
//  MessageCell.m
//  SportForum
//
//  Created by liyuan on 14-6-25.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "MessageCell.h"
#import "CSButton.h"
#import "CommonUtility.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define FONT_CHAT [UIFont fontWithName:@"Arial" size:10]
#define COLOR_GRAY [UIColor colorWithRed:205.0 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1]

#define COLOR_TIME_LABLE [UIColor colorWithRed:120.0 / 255.0 green:120.0 / 255.0 blue:120.0 / 255.0 alpha:1]

@implementation MessageItem

@end

@implementation MessageCell

const float cMsgTopSpace = 10.0;
const float cMsgLeftSpace = 10.0;
const float cMsgBootomSpace = 10.0;

const float cMsgTime2ContentSpace = 10.0;
const float cMsgWidthChatView = 200;

const float cMsgTimeLableWidth = 100;
const float cMsgTimeLableHeight = 20;
const float cMsgChatTextTopSpace = 5;
const float cMsgChatTextBottomSpace = 5;
const float cMsgChatTextLeftSpace = 5;
const float cMsgChatTextRightSpace =8;
const float cMsgImageViewHeight = 40;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _lbTime = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbTime];
        
        _btnMsgView = [CSButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_btnMsgView];
        
        _userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_userImageView];
    }
    
    return self;
}

-(void)setMessageItem:(MessageItem *)messageItem {
    _messageItem = messageItem;
    
    CGRect rectTime = CGRectZero;
    
    if (messageItem.time != nil) {
        _lbTime.hidden = NO;
        [_lbTime setFrame:CGRectMake(0, cMsgTopSpace, 80, cMsgTimeLableHeight)];
        // Time lable to center
        rectTime = _lbTime.frame;
        
        _lbTime.frame = CGRectMake(self.bounds.size.width/2 - rectTime.size.width/2,
                                    rectTime.origin.y, rectTime.size.width, rectTime.size.height);
        [_lbTime setBackgroundColor:[UIColor lightGrayColor]];
        _lbTime.layer.cornerRadius = 5;
        _lbTime.layer.masksToBounds = YES;
        [_lbTime setText:[[CommonUtility sharedInstance]compareCurrentTime:messageItem.time]];
        [_lbTime setFont:FONT_CHAT];
        _lbTime.textColor = [UIColor whiteColor];
        _lbTime.textAlignment = NSTextAlignmentCenter;
    } else {
        _lbTime.hidden = YES;
    }
    
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:messageItem.userImage]
                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _userImageView.layer.cornerRadius = 5.0;
    _userImageView.layer.masksToBounds = YES;
    
    UIImage* chatImage = nil;
    
    if (messageItem.isReceived) {
        _userImageView.frame = CGRectMake(cMsgLeftSpace, CGRectGetMaxY(rectTime) + cMsgTime2ContentSpace, cMsgImageViewHeight, cMsgImageViewHeight);
        _btnMsgView.contentEdgeInsets = UIEdgeInsetsMake(cMsgChatTextTopSpace, cMsgChatTextRightSpace+3, cMsgChatTextBottomSpace, cMsgChatTextLeftSpace);
        
        UIImage* origimage = [UIImage imageNamed:@"message-2"];
        chatImage = [origimage resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(origimage.size.height / 2) + 5 , floorf(origimage.size.width / 2) + 5, floorf(origimage.size.height / 2) + 5, floorf(origimage.size.width / 2) + 5)];
        _btnMsgView.frame = CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10,
                                        CGRectGetMinY(_userImageView.frame),
                                        cMsgWidthChatView,
                                        MAX(cMsgImageViewHeight, [[self class]heightOfMessage:messageItem.content] + cMsgChatTextBottomSpace +cMsgChatTextTopSpace));
        
    } else {
        _userImageView.frame = CGRectMake(self.bounds.size.width - cMsgLeftSpace - cMsgImageViewHeight, CGRectGetMaxY(rectTime) + cMsgTime2ContentSpace, cMsgImageViewHeight, cMsgImageViewHeight);
        _btnMsgView.contentEdgeInsets = UIEdgeInsetsMake(cMsgChatTextTopSpace, cMsgChatTextLeftSpace, cMsgChatTextBottomSpace, cMsgChatTextRightSpace);
        UIImage* origimage = [UIImage imageNamed:@"message-1"];
        chatImage = [origimage resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(origimage.size.height / 2) + 5 , floorf(origimage.size.width / 2) + 5, floorf(origimage.size.height / 2) + 5, floorf(origimage.size.width / 2) + 5)];
        _btnMsgView.frame = CGRectMake(cMsgLeftSpace * 2 + cMsgImageViewHeight,
                                       CGRectGetMinY(_userImageView.frame),
                                       cMsgWidthChatView,
                                       MAX(cMsgImageViewHeight, [[self class]heightOfMessage:messageItem.content] + cMsgChatTextBottomSpace +cMsgChatTextTopSpace));
    }
    
    _btnMsgView.backgroundColor = UIColor.clearColor;
    _btnMsgView.titleLabel.font = FONT_CHAT;
    _btnMsgView.titleLabel.numberOfLines = 0;
    [_btnMsgView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnMsgView setBackgroundImage:chatImage forState:UIControlStateNormal];
    [_btnMsgView setTitle:messageItem.content forState:UIControlStateNormal];
}

+(CGFloat)heightOfCell:(NSString*)commentText{
    return cMsgTopSpace + cMsgTimeLableHeight +
    MAX(cMsgImageViewHeight, [[self class]heightOfMessage:commentText] + cMsgChatTextBottomSpace +cMsgChatTextTopSpace) +
    cMsgBootomSpace+
    cMsgTime2ContentSpace;
}

+(CGFloat)heightOfMessage:(NSString*)text{
    CGSize constraint = CGSizeMake(cMsgWidthChatView - cMsgChatTextLeftSpace - cMsgChatTextRightSpace  , 20000.0f);
    CGSize size = [text sizeWithFont:FONT_CHAT constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
}

@end
