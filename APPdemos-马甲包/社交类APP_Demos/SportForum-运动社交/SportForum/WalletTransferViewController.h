//
//  WalletTransferViewController.h
//  SportForum
//
//  Created by zyshi on 14-9-17.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WalletTransferViewController : BaseViewController

-(void)setSelfAddress:(NSString *)strAddress;
-(void)setWalletBalanceItem:(WalletBalanceItem*)item;
-(void)settargetAddress:(NSString *)strAddress withArticleID:(NSString *)strID;

@end
