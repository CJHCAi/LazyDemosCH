//
//  MHNetwrok.h
//  PersonalAssistant
//
//  Created by dabing on 15/10/23.
//  Copyright © 2015年 Mark. All rights reserved.
//

#ifndef MHNetwrok_h
#define MHNetwrok_h

//#ifdef DEBUG
//#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
//#else
//#   define NSLog(...)
//#endif

#ifdef DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define NSLog(FORMAT, ...) nil

#endif

#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];


#import "MHAsiNetworkDefine.h"
#import "MHAsiNetworkDelegate.h"
#import "MHAsiNetworkHandler.h"
#import "MHNetworkManager.h"
#import "MHAsiNetworkUrl.h"
#import "MHAsiNetworkItem.h"


#endif /* MHNetwrok_h */
