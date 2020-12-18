//
//  Address.h
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, copy)NSString *NAME;
@property (nonatomic, copy)NSArray *USERS;

@property (nonatomic, assign)CGFloat cellHeight;

@end

