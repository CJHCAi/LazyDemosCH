//
//  AnswerViewController.h
//  75AG驾校助手
//
//  Created by again on 16/3/31.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController
@property (assign,nonatomic) int number;
@property (copy,nonatomic) NSString *subStrNumber;
// type =1 章节 type =2 顺序 type =3 随机 type =4 专项 type =5 模拟 type =6 未考先答 type =7 我的错题 type =8 我的收藏
@property (assign,nonatomic) int type;
@end
