//
//  HMQuestionModel.h
//  猜图游戏
//
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMQuestionModel : NSObject

@property (copy, nonatomic) NSString *answer;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *options;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionWithDict:(NSDictionary *)dict;

@end
