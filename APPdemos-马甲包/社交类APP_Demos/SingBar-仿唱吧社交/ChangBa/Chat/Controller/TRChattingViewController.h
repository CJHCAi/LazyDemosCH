//
//  ChattingTableViewController.h
//  环信测试
//
//  Created by tarena on 16/9/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>

@interface TRChattingViewController : UIViewController
@property (nonatomic, strong)BmobUser *toUser;
@property (nonatomic, copy)NSString *toUsername;
@end
