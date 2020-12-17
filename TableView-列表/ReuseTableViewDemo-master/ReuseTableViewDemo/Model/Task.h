//
//  Task.h
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, copy)NSString *TITLE;
@property (nonatomic, copy)NSString *CONTENT;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, assign)NSInteger indexPathRow;

@end
