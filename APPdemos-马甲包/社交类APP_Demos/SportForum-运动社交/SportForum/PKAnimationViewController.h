//
//  PKAnimationViewController.h
//  SportForum
//
//  Created by liyuan on 7/14/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PKCompletedBlock)(NSString *strResultUrl);

@interface PKAnimationViewController : UIViewController

@property(nonatomic, strong) UserInfo *senderInfo;
@property(nonatomic, strong) PKCompletedBlock pkCompletedBlock;

@end
