//
//  RunShareViewController.h
//  SportForum
//
//  Created by liyuan on 7/13/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RunShareViewController : BaseViewController

@property(nonatomic, copy)NSString *strSendId;
@property(nonatomic, copy)NSString *strRecordId;

@property(nonatomic, copy) NSString* strLatlng;//数据结构内容:(经度，纬度)
@property(nonatomic, copy) NSString* strLocAddr;
@property(nonatomic, copy) NSString* strImgAddr;

@property(nonatomic, assign) long long lRunBeginTime;

@end
