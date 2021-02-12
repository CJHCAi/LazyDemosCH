//
//  ViewController.m
//  mayisenlin
//
//  Created by iOS on 2020/9/10.
//  Copyright © 2020 jucdy. All rights reserved.
//

#import "ViewController.h"
#import "TreeView.h"

#import "Config.h"

#import "friendTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TreeViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, weak) TreeView *treeView;

@property (nonatomic,strong) NSMutableArray *listArray;

@end

@implementation ViewController


#pragma mark - TreeViewDelegate

- (void)selectTimeLimitedBtnAtIndex:(NSInteger)index
{
    [_treeView removeRandomIndex:index];
}

- (void)selectUnlimitedBtnAtIndex:(NSInteger)index
{
    [_treeView removeRandomIndex:index];
}

- (void)allCollected
{
    NSLog(@"全都点完了");
}

- (void)btnClick
{
    [_treeView removeAllRandomBtn];
    
    _treeView.timeLimitedArr = @[@"5",@"15",@"25",@"45",@"55",@"65",@"75"];
//    _treeView.unimitedArr = @[@"10",@"20",@"30"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    
}

-(void)setUI
{
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YLBScreenWidth, STATUSHEIGHT)];
//    topView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:topView];
    
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, STATUSHEIGHT,YLBScreenWidth , 20);
    [btn setTitle:@"点击刷新" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSHEIGHT + 20, YLBScreenWidth, YLBScreenHeight-STATUSHEIGHT-20) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    TreeView *treeView = [[TreeView alloc] initWithFrame:CGRectMake(0, 0, YLBScreenWidth, YLBScreenHeight *0.7)];
    treeView.timeLimitedArr = @[@"5",@"15",@"25",@"45",@"55",@"65",@"75"];
    treeView.unimitedArr = @[@"10",@"20",@"30"];
    treeView.backgroundColor = [UIColor whiteColor];
    treeView.delegate = self;
    _treeView = treeView;
    
    self.tableView.tableHeaderView = treeView;
    
    
    [self loadData];
}

-(void)loadData
{
    self.listArray = [[NSMutableArray alloc] initWithArray:@[@{@"ranking":@"1",@"icon":@"chengzi",@"name":@"六一",@"certificate":@"30",@"energy":@"400"},@{@"ranking":@"2",@"icon":@"pingguo",@"name":@"六二",@"certificate":@"29",@"energy":@"360"},@{@"ranking":@"3",@"icon":@"chengzi",@"name":@"六三",@"certificate":@"28",@"energy":@"360"},@{@"ranking":@"4",@"icon":@"pingguo",@"name":@"六四",@"certificate":@"27",@"energy":@"360"},@{@"ranking":@"5",@"icon":@"chengzi",@"name":@"六五",@"certificate":@"26",@"energy":@"360"},@{@"ranking":@"6",@"icon":@"pingguo",@"name":@"六六",@"certificate":@"25",@"energy":@"360"},@{@"ranking":@"7",@"icon":@"chengzi",@"name":@"六七",@"certificate":@"24",@"energy":@"360"},@{@"ranking":@"8",@"icon":@"pingguo",@"name":@"六八",@"certificate":@"23",@"energy":@"300"},@{@"ranking":@"9",@"icon":@"chengzi",@"name":@"六九",@"certificate":@"20",@"energy":@"250"},@{@"ranking":@"10",@"icon":@"pingguo",@"name":@"六十",@"certificate":@"20",@"energy":@"250"},@{@"ranking":@"11",@"icon":@"chengzi",@"name":@"六十一",@"certificate":@"20",@"energy":@"250"},@{@"ranking":@"12",@"icon":@"pingguo",@"name":@"六十二",@"certificate":@"20",@"energy":@"250"},@{@"ranking":@"13",@"icon":@"chengzi",@"name":@"六十三",@"certificate":@"19",@"energy":@"250"},@{@"ranking":@"14",@"icon":@"pingguo",@"name":@"六十四",@"certificate":@"19",@"energy":@"250"},@{@"ranking":@"15",@"icon":@"chengzi",@"name":@"六十五",@"certificate":@"15",@"energy":@"250"},@{@"ranking":@"16",@"icon":@"pingguo",@"name":@"六十六",@"certificate":@"15",@"energy":@"250"},@{@"ranking":@"17",@"icon":@"chengzi",@"name":@"六十七",@"certificate":@"15",@"energy":@"200"},@{@"ranking":@"18",@"icon":@"pingguo",@"name":@"六十八",@"certificate":@"15",@"energy":@"200"},@{@"ranking":@"19",@"icon":@"chengzi",@"name":@"六十九",@"certificate":@"15",@"energy":@"200"},@{@"ranking":@"20",@"icon":@"pingguo",@"name":@"六二十",@"certificate":@"15",@"energy":@"200"},@{@"ranking":@"21",@"icon":@"chengzi",@"name":@"六二十一",@"certificate":@"10",@"energy":@"100"}]];
    
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    friendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[friendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dict = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}


@end
