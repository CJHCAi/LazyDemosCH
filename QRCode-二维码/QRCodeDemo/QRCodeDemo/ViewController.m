//
//  ViewController.m
//  QRCodeDemo
//
//  Created by King on 2017/8/15.
//  Copyright © 2017年 King. All rights reserved.
//

#import "ViewController.h"

#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController5.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"二维码生成器";
    
    [self createDataSource];
    [self createTableView];
}

- (void)createDataSource{
    
    _dataArray = [[NSMutableArray alloc]init];
    
    NSArray * array = @[@"圆形图案不同颜色",@"圆形图案相同颜色",@"方形图案不同颜色",@"圆形图案相同颜色",@"带图片的二维码"];
    [_dataArray addObjectsFromArray:array];
    
}

- (void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        ViewController1 * vc1 = [[ViewController1 alloc]init];
        [self.navigationController pushViewController:vc1 animated:YES];
        
    }else if (indexPath.row == 1){
        
        ViewController2 * vc2 = [[ViewController2 alloc]init];
        [self.navigationController pushViewController:vc2 animated:YES];
        
    }else if (indexPath.row == 2){
        
        ViewController3 * vc3 = [[ViewController3 alloc]init];
        [self.navigationController pushViewController:vc3 animated:YES];
        
    }else if (indexPath.row == 3){
        
        ViewController4 * vc4 = [[ViewController4 alloc]init];
        [self.navigationController pushViewController:vc4 animated:YES];
        
    }else{
        
        ViewController5 * vc5 = [[ViewController5 alloc]init];
        [self.navigationController pushViewController:vc5 animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
