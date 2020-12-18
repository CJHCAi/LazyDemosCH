//
//  TaskViewController.h
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReceiveSubmitTaskDelegate<NSObject>

- (void)receiveSubmitTask:(NSDictionary *)taskArrayDic;

@end


@interface TaskViewController : UIViewController

@property (nonatomic, copy)void(^taskBlock)(NSArray *taskArray);

@end
