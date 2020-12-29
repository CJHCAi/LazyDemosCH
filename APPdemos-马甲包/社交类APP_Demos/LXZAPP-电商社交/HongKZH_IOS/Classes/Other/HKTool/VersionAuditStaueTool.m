//
//  VersionAuditStaueTool.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "VersionAuditStaueTool.h"
#import "HKWHUrl.h"
@implementation VersionAuditStaueTool
SISingletonM(VersionAuditStaueTool)
-(BOOL)isAuditAdopt{
    BOOL isAuditAdopt = NO;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:VersionAuditStaue] isEqualToString:@"1"]) {
        isAuditAdopt = YES;
    }
    return YES;
}
@end
