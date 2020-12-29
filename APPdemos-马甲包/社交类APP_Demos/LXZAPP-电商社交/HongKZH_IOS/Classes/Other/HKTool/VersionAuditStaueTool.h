//
//  VersionAuditStaueTool.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionAuditStaueTool : NSObject
SISingletonH(VersionAuditStaueTool)
-(BOOL)isAuditAdopt;
@end
