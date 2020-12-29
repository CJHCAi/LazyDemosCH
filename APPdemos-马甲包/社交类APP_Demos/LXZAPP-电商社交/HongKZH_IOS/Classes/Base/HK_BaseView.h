//
//  HK_BaseView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilHKProtocol.h"
#import "UtilHKEnmu.h"

@interface HK_BaseView : UIViewController<HKNavigationBarDelegate>


- (void)setShowCustomerLeftItem:(BOOL)showCustomerLeftItem;

-(void)showSVProgressHUD;
@property (nonatomic,assign)BOOL is_request_new;


@property(nonatomic , strong) UIView* bottomV;
-(CGSize)calcSelfSize;

-(void)Show_Request_State:(NSInteger)statusCode;

- (void)backItemClick;
//弹出新人提出窗
- (void)cancelNewUser;
//增加通知监听
-(void)addNotification;



/**
 是否启用自定义返回按钮
 默认为NO
 */
@property (nonatomic,assign)BOOL showCustomerLeftItem;

@property(nonatomic, assign) BOOL isPre;
@end
