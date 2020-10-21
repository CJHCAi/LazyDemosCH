//
//  CDOneVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDOneVC.h"
#import "CDOneCell.h"
#import "MyObject.h"
@interface CDOneVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation CDOneVC

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WW, HH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[CDOneCell class] forCellReuseIdentifier:@"CDOneCell"];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _contentArray = [[NSArray alloc]initWithObjects:@"哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈",
                     @"哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈",
                     @"哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈",
                     @"哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈哦is联发科女阿卡就是当年 阿拉山口都发你啦阿里斯顿房间爱丽 阿萨德浪费即可芝士蛋糕老翁你啊，收到南方拉收到南方是劳动妇女阿金的反馈",nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self InitView];
    [_tableView reloadData];

    
}
- (void)InitView
{
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CDOneCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.CD_Image.image= [UIImage imageNamed:@"nodata"];
    cell.CD_Label.text = _contentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CDOneCell cellHeightWithLabel:_contentArray[indexPath.row]];
}
@end
