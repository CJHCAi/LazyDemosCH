//
//  TMExpandViewController.m
//  TMSwipeCell
//
//  Created by cocomanber on 2018/9/10.
//  Copyright © 2018年 cocomanber. All rights reserved.
//  同一种cell expand不同状态的view 好处理？
//  同一种cell expand同状态的view 好处理
//  所有cell expand同状态的view 好处理

#import "TMExpandViewController.h"

#import "TMCellTypeOne.h"
#import "TMExpandCellTypeOne.h"
#import "TMExpandModel.h"

@interface TMExpandViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    NSArray *_datas;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL isExpand;
@property (nonatomic, strong)NSIndexPath *selectedIndexPath;

@end

@implementation TMExpandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.frame;
    
    _datas = [TMExpandModel getAllDatas];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TMExpandCellTypeOne" bundle:nil] forCellReuseIdentifier:@"TMExpandCellTypeOne"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TMCellTypeOne" bundle:nil] forCellReuseIdentifier:@"TMCellTypeOne"];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedIndexPath.row && self.selectedIndexPath != nil ) {// 判断是否是所点击的cell
        if (self.isExpand == YES) { // 判断这个已点击的cell是否展开
            return 141;
        }else{
            return 86;
        }
    }else{
        return 86;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isExpand && [self.selectedIndexPath isEqual:indexPath]) {//如果展开并且是当前选中的cell
        //创建扩展的cell
        static NSString *expandCellID = @"TMExpandCellTypeOne";
        TMExpandCellTypeOne *cell = [tableView dequeueReusableCellWithIdentifier:expandCellID];
        return cell;
        
    }else{
        //普通情况
        //创建普通cell
        static NSString *customCellID = @"TMCellTypeOne";
        TMCellTypeOne *cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.selectedIndexPath) {
        
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }else{
        
        if (self.isExpand) {
            if ([self.selectedIndexPath isEqual: indexPath]) {
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
                
            }else{
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.isExpand = YES;
                self.selectedIndexPath = indexPath;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
        }
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
