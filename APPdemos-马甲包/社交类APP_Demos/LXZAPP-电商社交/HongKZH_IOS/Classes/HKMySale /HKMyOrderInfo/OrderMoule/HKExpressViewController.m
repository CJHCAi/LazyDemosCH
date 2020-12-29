//
//  HKExpressViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKExpressViewController.h"
#import "HKExpressTableView.h"
@interface HKExpressViewController ()<HKExpressTableViewDelegate>
@property (nonatomic, strong)HKExpressTableView *tableView;
@end

@implementation HKExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(194);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)expressTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(selectExpresModel:)]) {
        [self.delegate selectExpresModel:self.questionArray[indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@synthesize questionArray = _questionArray;
-(void)setQuestionArray:(NSMutableArray *)questionArray{
    _questionArray = questionArray;
    self.tableView.questionArray = questionArray;
}
-(HKExpressTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HKExpressTableView alloc]init];
        _tableView.expressDelegate = self;
    }
    return _tableView;
}



- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray   ;
}

@end
