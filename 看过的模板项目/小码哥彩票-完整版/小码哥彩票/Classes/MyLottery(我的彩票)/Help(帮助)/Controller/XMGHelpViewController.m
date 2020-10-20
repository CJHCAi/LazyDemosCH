//
//  XMGHelpViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGHelpViewController.h"

#import "XMGHtmlItem.h"


#import "XMGHtmlViewController.h"
#import "XMGNavigationController.h"

@interface XMGHelpViewController ()

@property (nonatomic, strong) NSMutableArray *htmls;


@end

@implementation XMGHelpViewController
- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)htmls
{
    if (_htmls == nil) {
        
        _htmls = [NSMutableArray array];
        
        NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"help.json" ofType:nil];
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        // 解析json
        NSArray *dictArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary *dict in dictArr) {
            XMGHtmlItem *item = [XMGHtmlItem itemWithDict:dict];
            [_htmls addObject:item];
        }
        
    }
    return _htmls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.htmls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
   UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 获取模型
    XMGHtmlItem *item =  self.htmls[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

// 点击cell的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取模型
    XMGHtmlItem *item =  self.htmls[indexPath.row];
    // 创建展示网页的控制器
    XMGHtmlViewController *htmlVc = [[XMGHtmlViewController alloc] init];
    htmlVc.title = item.title;
    htmlVc.htmlItem = item;
    XMGNavigationController *nav = [[XMGNavigationController alloc] initWithRootViewController:htmlVc];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
