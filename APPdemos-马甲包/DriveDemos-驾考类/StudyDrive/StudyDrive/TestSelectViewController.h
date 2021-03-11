//
//  TestSelectViewController.h
//  StudyDrive
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSelectViewController : UIViewController
@property(nonatomic,copy)NSString * myTitle;
@property(nonatomic,copy)NSArray * dataArray;
//type=1 章节  type=2 专项
@property(nonatomic,assign)int type;
@end
