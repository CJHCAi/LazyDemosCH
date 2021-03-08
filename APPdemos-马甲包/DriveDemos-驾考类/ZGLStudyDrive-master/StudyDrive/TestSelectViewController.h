//
//  TestSelectViewController.h
//  StudyDrive
//
//  Created by zgl on 16/1/6.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSelectViewController : UIViewController

@property(nonatomic,copy)NSString * myTitle;
@property(nonatomic,copy)NSArray *dataArray;
//type=1 章节 type=2 专项
@property(nonatomic,assign)int type;

@end
