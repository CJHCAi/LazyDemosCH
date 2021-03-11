//
//  AnswerScrollView.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/11.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import "AnswerScrollView.h"
#define SIZE self.frame.size
#import "AnswerTableViewCell.h"


@interface AnswerScrollView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end
@implementation AnswerScrollView
{
    UIScrollView *_scrollView;
    UITableView *_leftTableView;
    UITableView *_mainTableView;
    UITableView *_rightTableView;
    NSArray *_dataArray;
}
-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [[NSArray alloc]initWithArray:array];
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.delegate =self;
        _leftTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _mainTableView =[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _rightTableView =[[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _leftTableView.dataSource =self;
        _mainTableView.dataSource=self;
        _rightTableView.dataSource =self;
        
        _rightTableView.delegate =self;
        _mainTableView.delegate=self;
        _leftTableView.delegate =self;
        
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled =YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
     
        //判断是否可以滑动
        
        if (_dataArray.count >1) {
            _scrollView.contentSize = CGSizeMake(SIZE.width*2, 0);
        }
        [self creatView];
    }
    return self;
}
-(void)creatView{
    _leftTableView.frame =CGRectMake(0, 0, SIZE.width, SIZE.height);
    _mainTableView.frame =CGRectMake(SIZE.width, 0, SIZE.width, SIZE.height);
    _rightTableView.frame =CGRectMake(SIZE.width*2, 0, SIZE.width, SIZE.height);
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_mainTableView];
    [_scrollView addSubview:_rightTableView];
    [self addSubview:_scrollView];
}


#pragma mark -tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, 100)];
    view.backgroundColor =[UIColor redColor];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"AnswerTableViewCell";
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AnswerTableViewCell" owner:self options:nil]lastObject];
        cell.numberLabel.layer.masksToBounds =YES;
        cell.numberLabel.layer.cornerRadius = 10;
        
    }
    cell.numberLabel.text =[NSString stringWithFormat:@"%c",(char)('A' +indexPath.row)];
    return cell;
}
//滑动结束代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;//偏移量
    
    int page = (int ) currentOffset.x/SIZE.width;
    if (page<_dataArray.count-1) {
        _scrollView.contentSize =CGSizeMake(currentOffset.x+SIZE.width*2, 0);
        _mainTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
        _leftTableView.frame = CGRectMake(currentOffset.x-SIZE.width, 0, SIZE.width,  SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x+SIZE.width, 0, SIZE.width, SIZE.height);
    }
    
}


@end
