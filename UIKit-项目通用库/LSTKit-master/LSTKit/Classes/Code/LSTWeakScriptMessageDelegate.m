//
//  LSTWeakScriptMessageDelegate.h
//  DSOCConnectWithJS
//
//  Created by LoSenTrad on 16/3/29.
//  Copyright © 2016年 LoSenTrad. All rights reserved.
//

#import "LSTWeakScriptMessageDelegate.h"

@implementation LSTWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
