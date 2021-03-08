//
//  TestSelectViewController.h
//  DriverAssistant
//
//  Created by C on 16/3/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSelectViewController : UIViewController
@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, copy) NSArray *dataArr;
//type=1章节练习 type=2专项练习
@property (nonatomic, assign) int type;

@end
