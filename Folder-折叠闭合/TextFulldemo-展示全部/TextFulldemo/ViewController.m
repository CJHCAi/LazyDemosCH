//
//  ViewController.m
//  TextFulldemo
//
//  Created by 刘昊 on 17/10/16.
//  Copyright © 2017年 刘昊. All rights reserved.
//

#import "ViewController.h"
#import "UITextCell.h"
#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
    UITableView *_mineTableView;
    NSInteger _tag;
    NSMutableArray *_haveArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relade:) name:@"tag" object:nil];
}

- (void)relade:(NSNotification *)info{
    NSDictionary *dic = info.object;
    NSInteger tag = [dic[@"tag"] integerValue];
    _tag = tag;
    
    if ([_haveArr containsObject:[NSString stringWithFormat:@"%ld",tag]]) {
        
    }else{
        [_haveArr addObject:[NSString stringWithFormat:@"%ld",tag]];
    }
    
    [_mineTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)initData{
    _dataArr = @[@"今天凌晨，苹果再一次为我们带来了iOS 11.1 Beta 3。不过在iOS 11.1 beta 3中，苹果并没有增加新功能，而是修复了很多bug和安全问题。当然，正如我们之前所提到的，iOS 11.1看起来也为即将到来的iPhone X准备了很多的新功能，所以在iPhone X推出之前，我们应该很有可能会看到正式版的iOS 11.1到来。",@"首先、3D Touch操作变得更流畅，修复了延迟。这对于很多喜欢和习惯使用3D Touch的朋友来说，绝对是一个好消息。",@"第二、修复严重的WiFi WPA2安全漏洞。根据国外研究人员披露，最新的WiFi WPA2加密协议漏洞加密协议漏洞影响到了数百万的路由器设备、智能加密协议漏洞影响到了数百万的路由器设备、智能影响到了数百万的路由器设备、智能手机、个人电脑以及其他的设备，包含苹果Mac、iPhone以及iPad。不过幸好在最新的测试版系统当中，苹果已经修复了这个严重的漏洞",@"第二、修复严重的WiFi WPA2安全漏洞。根据国外研究人员披露，最新的WiFi WPA2加密协议漏洞加密协议漏洞影响到了数百万的路由器设备、智能加密协议漏洞影响到了数百万的路由器设备、智能影响到了数百万的路由器设备、智能手机、个人电脑以及其他的设备，包含苹果Mac、iPhone以及iPad。不过幸好在最新的测试版系统当中，苹果已经修复了这个严重的漏洞",@"第二、修复严重的WiFi W"];
    
    _tag  = -1;
    _haveArr = @[].mutableCopy;
    
}



- (void)layoutView{
    _mineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kAppFrameWidth, kAppFrameHeight -64) style:UITableViewStylePlain];
    _mineTableView.dataSource = self;
    _mineTableView.delegate = self;
    _mineTableView.backgroundColor = UIColorFromRGB(0xededed);
    _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mineTableView];
}


#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"CELL";
    UITextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.tag = indexPath.row;
    if (_tag == indexPath.row && [_haveArr containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
        cell.isFill = YES;
    }
     [cell reloadData:_dataArr[indexPath.row]];
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = [self heightWithFont:15 limitWidth:kAppFrameWidth -30 string:_dataArr[indexPath.row]];
    if (_tag != indexPath.row && ![_haveArr containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
        if (height >54) {
            height =54;
        }
    }
    return height +30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

- (float)heightWithFont:(float)font limitWidth:(float)width string:(NSString *)str{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attribute
                                     context:nil].size;
    return size.height;
}


@end
