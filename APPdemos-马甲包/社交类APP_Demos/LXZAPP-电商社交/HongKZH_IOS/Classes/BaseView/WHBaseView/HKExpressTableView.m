//
//  HKExpressTableView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKExpressTableView.h"
#import "HKExpressableTViewCell.h"
@interface HKExpressTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *shadeView;
@end

@implementation HKExpressTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
        [self addSubview:self.shadeView];
        [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_offset(0);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.shadeView.mas_bottom);
        }];
    }
    return self;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKExpressableTViewCell*cell = [HKExpressableTViewCell expressableTViewCellWithTableView:tableView];
    cell.model = self.questionArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.expressDelegate respondsToSelector:@selector(expressTableView:didSelectRowAtIndexPath:)]) {
        [self.expressDelegate expressTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@synthesize questionArray = _questionArray;
-(void)setQuestionArray:(NSMutableArray *)questionArray{
    _questionArray = questionArray;
    [self.tableView reloadData];
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
-(UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc]init];
        _shadeView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    }
    return _shadeView;
}
@end
