//
//  KTViewController.m
//  ZJUIKit
//
//  Created by keenteam on 2018/4/2.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "KTViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "KTMeasonyAutoLayoutCell.h"
#import "KTCommit.h"

#define kMasonryCell @"kMasonryCell"
@interface KTViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong) UITableView *mainTable;
@property(nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation KTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpAllView];
    [self getCommitsData];
}

#pragma mark - 获取数据
- (void)getCommitsData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MasonryCellData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *commitsList = [rootDict objectForKey:@"comments_list"];
    NSMutableArray *arrM = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dictDict in commitsList) {
            KTCommit *commit = [KTCommit commitWithDict:dictDict];
            [arrM addObject:commit];
        }
        self.dataArray = arrM;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTable reloadData];
        });
    });
    
}

-(void)setUpAllView{
    
    self.title = @"Masonry朋友圈";
    
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.tableFooterView = [[UIView alloc]init];
    _mainTable.estimatedRowHeight = 200;
    // 必须先注册cell，否则会报错
    [_mainTable registerClass:[KTMeasonyAutoLayoutCell class] forCellReuseIdentifier:kMasonryCell];
    [self.view addSubview:self.mainTable];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KTMeasonyAutoLayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kMasonryCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.weakSelf = self;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",indexPath.row);
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 计算缓存cell的高度
    return [self.mainTable fd_heightForCellWithIdentifier:kMasonryCell cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
}

#pragma mark - 给cell赋值
- (void)configureCell:(KTMeasonyAutoLayoutCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.model = self.dataArray[indexPath.row];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
