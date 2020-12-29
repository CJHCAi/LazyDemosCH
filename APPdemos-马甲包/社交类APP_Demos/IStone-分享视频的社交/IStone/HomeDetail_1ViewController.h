//
//  HomeDetail_1ViewController.h
//  IStone
//
//  Created by 胡传业 on 14-7-23.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDetail_1ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// 用这个属性来获取 表格视图头视图的指针
@property (nonatomic, strong)  UIView *headerView;

// 弃用
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIWebView *webView;

// 用户头像
@property (nonatomic, weak) UIImageView *iconView;

// 用户昵称
@property (nonatomic, weak) UILabel *nickName;

// 关注button
@property (nonatomic, weak) UIButton *followButton;

// 点赞按钮
@property (nonatomic, weak) UIButton *praiseButton;

// 点赞量
@property (nonatomic, weak) UILabel *praiseLabel;

// 转发
@property (nonatomic, weak) UIButton *shareButton;

// 评论列表
@property (nonatomic, strong) UITableView *tableView;

@end
