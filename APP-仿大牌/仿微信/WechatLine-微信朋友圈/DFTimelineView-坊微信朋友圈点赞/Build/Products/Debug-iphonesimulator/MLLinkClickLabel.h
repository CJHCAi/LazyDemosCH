//
//  MLLinkClickLabel.h
//  DFCommon
//
//  Created by Allen Zhong on 15/10/10.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <MLLinkLabel.h>

@protocol MLLinkClickLabelDelegate <NSObject>

@optional

-(void) onClickOutsideLink:(long long) uniqueId;
-(void) onLongPress;

@end

@interface MLLinkClickLabel : MLLinkLabel

@property (nonatomic, assign) id<MLLinkClickLabelDelegate> clickDelegate;

@property (nonatomic, assign) long long uniqueId;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com