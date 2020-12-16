//
//  SecondViewController.m
//  SFTrainsitionDemo
//
//  Created by sfgod on 16/5/13.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "SFTrainsitionAnimate.h"
#import "UIViewController+SFTrainsitionExtension.h"

@interface SecondViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,   nonatomic) UIView *targetView;
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headView;

@end

@implementation SecondViewController



#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.tableView];
}

#pragma mark -- Data
- (void)initData{
    self.animate = [[SFTrainsitionAnimate alloc] initWithAnimateType:animate_pop andDuration:1.5];
    
}

#pragma mark -- UI
- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT/2-64)];
    back.contentMode = UIViewContentModeScaleToFill;
    back.backgroundColor = [UIColor lightGrayColor];
    back.image = [UIImage imageNamed:@"page.jpg"];
    
    
    UIView *image = [[UIView alloc] initWithFrame:CGRectMake(20, SCREEN_HIGHT/2-64-70, SCREEN_WIDTH/3-20, (SCREEN_WIDTH/3-20)*1.3)];
    image.backgroundColor = self.v_coler;
    self.sf_targetView = image;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-200)];
    _headView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:back];
    [_headView addSubview:image];

    
    self.tableView.tableHeaderView = _headView;

}

#pragma mark -- event response


- (void)buttonClick:(UIButton *)sender{
    
}

#pragma mark -- navigation delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return self.animate;
    }else{
        return nil;
    }
}


#pragma mark -- getters and setters

- (void)setV_coler:(UIColor *)v_coler{
    _v_coler = v_coler;
    _targetView.backgroundColor = _v_coler;
}

#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell"];
    
    cell.textLabel.text = @"哈哈哈哈哈哈";
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator   = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MeCell"];
    }
    return _tableView;
}




@end
