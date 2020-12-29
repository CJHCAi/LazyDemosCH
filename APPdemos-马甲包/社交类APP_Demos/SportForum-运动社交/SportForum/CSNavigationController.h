//
//  CSNavigationController.h
//  SportForum
//
//  Created by liyuan on 14-8-14.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoManagerFooter <NSObject>
-(BOOL) bShowFooterViewController;
@end

@interface CSNavigationController : UINavigationController
@property(nonatomic, readonly) BOOL bShowFooterViewController;

-(void)autoLoginWhenStart;
-(void)connectWebSocket;
-(void)disconnectWebSocket;
-(void)setDeviceToken;
-(void)checkNewAttention;
-(long long)getLastLoginTime;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)updateTabBarItem;

@end
