//
//  ViewController.m
//  CQTopBar
//
//  Created by yto on 2018/1/9.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import "ViewController.h"
#import "CQTopBarViewController.h"
#import "Text1.h"
#import "Text2.h"
#import "Text3.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CQTopBarViewController *topBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction2:) name:NSStringFromClass([Text2 class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction3:) name:NSStringFromClass([Text3 class]) object:nil];
    
    self.topBar = [[CQTopBarViewController alloc] init];
    self.topBar.sectionTitles = @[@"Text1",@"Text2Text2",@"Text3"];
    self.topBar.pageViewClasses = @[[Text1 class],[Text2 class],[Text3 class]];
    self.topBar.segmentbackImage = [UIImage imageNamed:@"userorder_cancelbtn_highlight"];
    self.topBar.selectSegmentbackImage = [UIImage imageNamed:@"main_searchbutton_normal"];
    self.topBar.segmentlineColor = [UIColor orangeColor];
    self.topBar.segmentFrame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    [self addChildViewController:self.topBar];
    [self.view addSubview:self.topBar.view];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.topBar.footerView.bounds.size.height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.topBar.footerView addSubview:tableView];
}

- (void)InfoNotificationAction2:(NSNotification *)notification{
    [self.topBar topBarReplaceObjectsAtIndexes:1 withObjects:notification.userInfo[@"text"]];
}

- (void)InfoNotificationAction3:(NSNotification *)notification{
    self.topBar.hiddenView = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"TableViewCell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"TableViewCell";
    return cell;
}


@end
