//
//  TestSelectViewController.h
//  75AG驾校助手
//
//  Created by again on 16/3/27.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSelectViewController : UIViewController
@property (copy,nonatomic) NSString *myTitle;
@property (copy,nonatomic) NSArray *dataArray;
//type1 章节  type2 专项
@property (assign,nonatomic) int type;
@end
