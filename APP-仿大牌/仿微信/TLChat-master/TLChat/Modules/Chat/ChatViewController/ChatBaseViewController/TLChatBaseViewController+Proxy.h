//
//  TLChatBaseViewController+Proxy.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/17.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLChatBaseViewController.h"

@interface TLChatBaseViewController (Proxy) <TLMessageManagerChatVCDelegate>

/**
 *  发送消息
 */
- (void)sendMessage:(TLMessage *)message;

@end
