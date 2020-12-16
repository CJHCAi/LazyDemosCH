//
//  BHExampleViewController.m
//  BHDemo
//
//  Created by QiaoBaHui on 2018/9/18.
//  Copyright © 2018年 QiaoBaHui. All rights reserved.
//

#import "BHExampleViewController.h"
#import "NSString+BHURLHelper.h"

@interface BHExampleViewController ()

@property (nonatomic, copy) NSString *originalUrlString;

@end

static NSString *const DEMO_VIEWS_STORYBOARD_NAME = @"DemoViews";


@implementation BHExampleViewController

+ (instancetype)create {
	UIStoryboard *demoViewsStoryboard = [UIStoryboard storyboardWithName:DEMO_VIEWS_STORYBOARD_NAME bundle:nil];
	return [demoViewsStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([BHExampleViewController class])];
}

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.originalUrlString = @"https://github.com?name=qiaobahui&age=23";
    
	[self addParameterTest];
	[self deleteParameterTest];
	[self modifyParameterTest];
	[self parseAllParametersTest];
}

#pragma mark - Private Methods

- (void)addParameterTest {
	// 添加参数
	NSString *addResult = [self.originalUrlString addParameters:@{@"sex" : @"man"}];
	NSLog(@"addResult: %@", addResult); // 输出结果: https://github.com?name=qiaobahui&age=23&sex=man
}

- (void)deleteParameterTest {
	// 删除"age"对应的参数对;
	NSString *deleteResult = [self.originalUrlString deleteParameterOfKey:@"age"];
	NSLog(@"deleteResult: %@", deleteResult); // 输出结果: https://github.com?name=qiaobahui
}

- (void)modifyParameterTest {
	// 修改"age"的值 = 100, 原值为23;
	NSString *modifyResult = [self.originalUrlString modifyParameterOfKey:@"age" toValue:@"100"];
	NSLog(@"modifyResult: %@", modifyResult); // 输出结果: https://github.com?name=qiaobahui&age=100
}

- (void)parseAllParametersTest {
	// 获取链接中的参数和值
	NSDictionary *parametersResult = [self.originalUrlString parseURLParameters];
	NSLog(@"parameterResult: %@", parametersResult); // 输出结果: parameterResult: {age = 23; name = qiaobahui;}
}

@end
