//
//  ButtonManager.m
//  housefinder
//
//  Created by zyshi on 13-7-24.
//  Copyright (c) 2013年 zhengying. All rights reserved.
//

#import "ButtonManager.h"
#import "AppNotification.h"
#import "ApplicationContext.h"

@implementation ButtonManager
{
    UIButton * _button;
    UILabel * _labelNumber;
    UIImageView * _imgNumber;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _button = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateButton) name:NOTIFY_MESSAGE_MSG_LIST_UPDATE object:nil];
    }
    return self;
}

- (void)registerButton:(UIButton *)button
{
    _button = button;
    
    _imgNumber = [[UIImageView alloc] initWithFrame:CGRectMake(20, -6, 13, 13)];
    _imgNumber.userInteractionEnabled = NO;
    _imgNumber.image = [UIImage imageNamed:@"number-red-dot"];
    _imgNumber.hidden = YES;
    [_button addSubview:_imgNumber];

    _labelNumber = [[UILabel alloc] initWithFrame:_imgNumber.frame];
    _labelNumber.userInteractionEnabled = NO;
    _labelNumber.backgroundColor = [UIColor clearColor];
    _labelNumber.textColor = [UIColor whiteColor];
    _labelNumber.font = [UIFont systemFontOfSize:9];
    _labelNumber.textAlignment = NSTextAlignmentCenter;
    _labelNumber.hidden = YES;
    [_button addSubview:_labelNumber];
}

- (void)showRegisterButton:(BOOL)bShow
{
    if (_button != nil) {
        
        _button.hidden = !bShow;
        
        if(bShow)
        {
            [self handleUpdateButton];
        }
    }
}

- (void)handleUpdateButton
{
    if(!_button)
    {
        return;
    }
    
    EventNewsInfo *eventNewsInfo = [[ApplicationContext sharedInstance]eventNewsInfo];
    
    if (eventNewsInfo != nil) {
        NSUInteger nEventCount = eventNewsInfo.new_chat_count + eventNewsInfo.new_comment_count + eventNewsInfo.new_thumb_count;
        
        if(nEventCount > 0)
        {
            [_button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
            _labelNumber.hidden = NO;
            _imgNumber.hidden = NO;
            
            if(nEventCount > 9)
            {
                _labelNumber.text = @"N";
            }
            else
            {
                _labelNumber.text = [NSString stringWithFormat:@"%ld", nEventCount];
            }
        }
        else
        {
            [_button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
            _labelNumber.hidden = YES;
            _imgNumber.hidden = YES;
        }
    }
}

@end
