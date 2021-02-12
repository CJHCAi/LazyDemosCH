//
//  NativeTableViewController.h
//  DemoNativeAd
//
//  Created by lishan04 on 15-5-11.
//  Copyright (c) 2015年 lishan04. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ADID_NORMAL @"2058621"//信息流
#define ADID_VIDEO  @"2362914"//信息流-视频
#define ADID_WINDOW @"2403625"//信息流-模板-橱窗样式
#define ADID_ROLL   @"2403627"//信息流-模板-轮播图样式

@interface NativeTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString*toBeChangedApid;
@property(nonatomic,copy)NSString*toBeChangedPublisherId;
@end
