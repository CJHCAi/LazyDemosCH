//
//  AnswerViewController.h
//  StudyDrive
//
//  Created by zgl on 16/1/7.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SheetView.h"

@interface AnswerViewController : UIViewController

@property(nonatomic,assign)int number;
@property(nonatomic,copy)NSString * subStrNumber;
//type=1 章节练习 type=2 顺序练习 type=3 随机练习 type=4 专项练习 type=5 全真模拟
@property(nonatomic,assign)int type;

@end
