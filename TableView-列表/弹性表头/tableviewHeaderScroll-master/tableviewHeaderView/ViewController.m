//
//  ViewController.m
//  tableviewHederView
//
//  Created by dd luo on 2019/11/27.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import "ViewController.h"
#define headerViewHeight 200
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)   UITableView * tableview ;
@property(nonatomic)     CGRect originalFrame;
@property(nonatomic,strong)  UIImageView * imageView ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTableview];
    [self creatHeaderView];
    
    
}


-(void)creatHeaderView{
    self.originalFrame = CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight);
    
    UIView * headerView = [[UIView alloc]initWithFrame: self.originalFrame];
    headerView.backgroundColor = [UIColor redColor];
    self.tableview.tableHeaderView= headerView;
    //  需要在创建一个imageView 放图片,g如果直接用imageView 作为headerView,tablview 容易错位变形
    UIImageView * imageView = [[UIImageView alloc]initWithFrame: self.originalFrame];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.image = [UIImage imageNamed:@"headerView"];
    self.imageView  = imageView;
    [self.view addSubview:imageView];

    
}
-(void)creatTableview{
    
    UITableView * tableview = [[UITableView alloc]init];
    tableview.frame = CGRectMake(0, 0, self.view.bounds.size.width,  self.view.bounds.size.height);
    tableview.delegate =self;
    tableview.dataSource = self;
    self.tableview  = tableview;
    tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 200;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"---------%ld------",indexPath.row];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        //  向上滑动
          CGRect frame = self.originalFrame ;
         frame.origin.y = frame.origin.y - yOffset;
         self.imageView.frame  = frame;
    }else{
        // 向下滑动,会放大
        CGRect frame =  self.originalFrame ;
        frame.size.height = frame.size.height - yOffset;
        frame.size.width = frame.size.height * (self.originalFrame.size.width / self.originalFrame.size.height);
        frame.origin.x = frame.origin.x - (frame.size.width - self.originalFrame.size.width) * 0.5;
        self.imageView.frame  = frame;
    }
}


@end

