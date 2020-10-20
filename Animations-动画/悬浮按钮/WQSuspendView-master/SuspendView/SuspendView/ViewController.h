//
//  ViewController.h
//  SuspendView
//
//  Created by 李文强 on 2019/6/6.
//  Copyright © 2019年 WenqiangLI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/** 第一进来为NO 跳转过的都为YES */
@property (nonatomic, assign) BOOL type;

/** 是否隐藏 */
@property (nonatomic, assign) BOOL viewHidden;

@end

