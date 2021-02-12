//
//  LSTWeakScriptMessageDelegate.h
//  DSOCConnectWithJS
//
//  Created by LoSenTrad on 16/3/29.
//  Copyright © 2016年 LoSenTrad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface LSTWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
