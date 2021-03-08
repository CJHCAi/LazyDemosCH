//
//  AnswerScrollView.m
//  DriverAssistant
//
//  Created by C on 16/3/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import "AnswerScrollView.h"
#import "AnswerCell.h"
#import "AnswerModel.h"
#import "Tools.h"
#import "QuestionCollectManager.h"
#define SIZE self.frame.size

@interface AnswerScrollView ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
}

@end

@implementation AnswerScrollView
{
    UITableView *_leftTableView;
    UITableView *_centerTableView;
    UITableView *_rightTableView;
    
}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 0;
        _dataArray = [NSArray arrayWithArray:array];
        _hadAnswerArray = [NSMutableArray array];
        _tempAnswerArray = [NSMutableArray array];

        for (int i = 0; i<array.count; i++) {
            [_hadAnswerArray addObject:@"0"];
            [_tempAnswerArray addObject:@"0"];
        }
        [self creatScrollViewWithFrame:frame];
        [self creatTableViewWithFrame:frame];
        [self creatView];
    }
    return self;
}

-  (void)creatScrollViewWithFrame:(CGRect)frame
{
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    if (_dataArray.count>1) {
        _scrollView.contentSize = CGSizeMake(SIZE.width*2, 0);
    }
}

-  (void)creatTableViewWithFrame:(CGRect)frame
{
    _leftTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _centerTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _rightTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _leftTableView.frame = CGRectMake(0, 0, SIZE.width, SIZE.height);
    _centerTableView.frame = CGRectMake(SIZE.width, 0, SIZE.width, SIZE.height);
    _rightTableView.frame = CGRectMake(SIZE.width*2, 0, SIZE.width, SIZE.height);
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _centerTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.delegate = self;
    _centerTableView.delegate = self;
    _rightTableView.delegate = self;
    _leftTableView.dataSource = self;
    _centerTableView.dataSource = self;
    _rightTableView.dataSource = self;
}

- (void) creatView
{
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_centerTableView];
    [_scrollView addSubview:_rightTableView];
    [self addSubview:_scrollView];
    
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AnswerModel *model;
    model = [self getTheFitModel:tableView];
    if ([model.mtype intValue] == 1) {
        return 4;
    }else if ([model.mtype intValue] == 2){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AnswerCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil]firstObject];
        cell.numberLabel.layer.cornerRadius = 10;
        cell.numberLabel.layer.masksToBounds = YES;
        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
        }
    }
    cell.numberLabel.text = [NSString stringWithFormat:@"%c", (char)('A'+indexPath.row)];
    AnswerModel *model;
    model = [self getTheFitModel:tableView];
    if ([model.mtype intValue] == 1){
        cell.answerLabel.text = [[Tools getAnswerWithString:model.mquestion]objectAtIndex:indexPath.row+1];
    }else if ([model.mtype intValue] == 2){
        if (indexPath.row == 0) {
            cell.answerLabel.text = @"对";
        }else if (indexPath.row == 1){
            cell.answerLabel.text =@"错";
        }
    }
    
    //判断是否已答题
    int page = [self getQuestionNumber:tableView andCurrentPage:_currentPage];
    if ([_tempAnswerArray[page-1] intValue] == 0){//答题模式
        
        if ([_hadAnswerArray[page-1] intValue]!=0) {
            
            if ([model.mtype intValue] == 1){//选择题
                if ([model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]) {
                    cell.numberImage.image=nil;
                    cell.numberImage.hidden=NO;
                    cell.numberImage.image=[UIImage imageNamed:@"19.png"];
                }else if (![model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+[_hadAnswerArray[page-1] intValue]-1]]&&indexPath.row==[_hadAnswerArray[page-1] intValue]-1) {
                    cell.numberImage.image=nil;
                    cell.numberImage.hidden=NO;
                    cell.numberImage.image=[UIImage imageNamed:@"20.png"];
                }else{
                    cell.numberImage.hidden=YES;
                }
            }else if ([model.mtype intValue] == 2){//判断题
                if ([model.manswer isEqualToString:cell.answerLabel.text]) {
                    cell.numberImage.image=nil;
                    cell.numberImage.hidden=NO;
                    cell.numberImage.image=[UIImage imageNamed:@"19.png"];
                }else if (![model.manswer isEqualToString:cell.answerLabel.text]&&indexPath.row==[_hadAnswerArray[page-1] intValue]-1) {
                    cell.numberImage.image=nil;
                    cell.numberImage.hidden=NO;
                    cell.numberImage.image=[UIImage imageNamed:@"20.png"];
                }else{
                    cell.numberImage.hidden=YES;
                }
            }
        }else{
            cell.numberImage.hidden=YES;
        }
    }else{//背题模式
        if ([model.mtype intValue] == 1){//选择题
            if ([model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]) {
                cell.numberImage.image=nil;
                cell.numberImage.hidden=NO;
                cell.numberImage.image=[UIImage imageNamed:@"19.png"];
            }else if (![model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+[_hadAnswerArray[page-1] intValue]-1]]&&indexPath.row==[_hadAnswerArray[page-1] intValue]-1) {
                cell.numberImage.image=nil;
                cell.numberImage.hidden=NO;
                cell.numberImage.image=[UIImage imageNamed:@"20.png"];
            }else{
                cell.numberImage.hidden=YES;
            }
        }else if ([model.mtype intValue] == 2){//判断题
            if ([model.manswer isEqualToString:cell.answerLabel.text]) {
                cell.numberImage.image=nil;
                cell.numberImage.hidden=NO;
                cell.numberImage.image=[UIImage imageNamed:@"19.png"];
            }else if (![model.manswer isEqualToString:cell.answerLabel.text]&&indexPath.row==[_hadAnswerArray[page-1] intValue]-1) {
                cell.numberImage.image=nil;
                cell.numberImage.hidden=NO;
                cell.numberImage.image=[UIImage imageNamed:@"20.png"];
            }else{
                cell.numberImage.hidden=YES;
            }
        }

    }
    
    
    return cell;
}



#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat hight;
    NSString *str;
    AnswerModel *model = [self getTheFitModel:tableView];
    if ([model.mtype intValue]==1){
        str = [[Tools getAnswerWithString:model.mquestion] objectAtIndex:0];
    }else{
        str = model.mquestion;
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    hight = [Tools getSizeWithString:str withFont:font withSize:CGSizeMake(tableView.frame.size.width - 20, 400)].height + 20;
    if (hight<=80) {
        return 80;
    }
    else{
        return hight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    AnswerModel *model = [self getTheFitModel:tableView];
    NSString *str = [NSString stringWithFormat:@"答案解析：%@",model.mdesc];
    UIFont *font = [UIFont systemFontOfSize:16];
    return [Tools getSizeWithString:str withFont:font withSize:CGSizeMake(tableView.frame.size.width - 20, 400)].height + 20;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat hight;
    NSString *str;
    AnswerModel *model = [self getTheFitModel:tableView];
    if ([model.mtype intValue]==1){
        str = [[Tools getAnswerWithString:model.mquestion] objectAtIndex:0];
    }else{
        str = model.mquestion;
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    hight = [Tools getSizeWithString:str withFont:font withSize:CGSizeMake(tableView.frame.size.width - 20, 400)].height + 20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE.width, hight)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width - 20, hight - 20)];
    label.text = [NSString stringWithFormat:@"%d.%@",[self getQuestionNumber:tableView andCurrentPage:_currentPage],str];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    [view addSubview:label];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    AnswerModel *model = [self getTheFitModel:tableView];
    NSString *str = [NSString stringWithFormat:@"答案解析：%@",model.mdesc];
    UIFont *font = [UIFont systemFontOfSize:16];
    CGFloat hight = [Tools getSizeWithString:str withFont:font withSize:CGSizeMake(tableView.frame.size.width - 20, 400)].height + 20;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE.width, hight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width - 20, hight - 20)];
    label.text = [NSString stringWithFormat:@"%d.%@",[self getQuestionNumber:tableView andCurrentPage:_currentPage],str];
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.textColor = [UIColor greenColor];
    [view addSubview:label];
    
    int page = [self getQuestionNumber:tableView andCurrentPage:_currentPage];
    if ([_hadAnswerArray[page-1] intValue] != 0||[_tempAnswerArray[page-1] intValue] != 0) {
        return view;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int page = [self getQuestionNumber:tableView andCurrentPage:_currentPage];
    if ([_tempAnswerArray[page-1] intValue] == 1) {//背题模式
        return;
    }
    if ([_hadAnswerArray[page-1] intValue] != 0) {
        return;
    }else{
        [_hadAnswerArray replaceObjectAtIndex:page-1 withObject:[NSString stringWithFormat:@"%ld", indexPath.row+1]];
    }
    //错题存档
    AnswerModel *model = [self getTheFitModel:tableView];
    if (![model.manswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]) {
        //如果已经存在则不存档
#warning 如果已经存在则不存档 待完善
        [QuestionCollectManager addWrongQuestion:[model.mid intValue]];
    }
    [self reloadData];
    [_delegate answerQuestion:_hadAnswerArray];
    
}



#pragma mark - scrollView delegate
//滚动结束时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffset = scrollView.contentOffset;
    int page = (int)currentOffset.x/SIZE.width;
    [_delegate scrollViewDidEndDecelerating:page+1];
    if (page < _dataArray.count - 1 && page > 0) {
        _scrollView.contentSize = CGSizeMake(currentOffset.x +SIZE.width*2, 0);
        _leftTableView.frame = CGRectMake(currentOffset.x - SIZE.width, 0, SIZE.width, SIZE.height);
        _centerTableView.frame = CGRectMake(currentOffset.x, 0, SIZE.width, SIZE.height);
        _rightTableView.frame = CGRectMake(currentOffset.x + SIZE.width, 0, SIZE.width, SIZE.height);
        _currentPage = page;
        [self reloadData];
    }
}

#pragma mark - myMethod
/**
 获取当前模型类型
 */
- (AnswerModel *)getTheFitModel:(UITableView *)tableView
{
    AnswerModel *model;
    if (tableView == _leftTableView && _currentPage == 0) {
        model = _dataArray[_currentPage];
    }else if(tableView == _leftTableView && _currentPage > 0){
        model = _dataArray[_currentPage-1];
    }else if (tableView == _centerTableView && _currentPage == 0){
        model = _dataArray[_currentPage+1];
    }else if (tableView == _centerTableView&&_currentPage>0&&_currentPage<_dataArray.count-1){
        model = _dataArray[_currentPage];
    }else if (tableView==_centerTableView&&_currentPage==_dataArray.count-1){
        model = _dataArray[_currentPage-1];
    }else if (tableView==_rightTableView&&_currentPage==_dataArray.count-1){
        model = _dataArray[_currentPage];
    }else if (tableView==_rightTableView&&_currentPage<_dataArray.count-1){
        model = _dataArray[_currentPage+1];
    }
    return model;
}

/**
 获取当前题目编号
 */
- (int)getQuestionNumber:(UITableView *)tableView andCurrentPage:(int)page
{
    if (tableView==_leftTableView&&page==0) {
        return 1;
    }else if(tableView==_leftTableView&&page>0){
        return page;
    }else if (tableView==_centerTableView&&page>0&&page<_dataArray.count-1){
        return page+1;
    }else if(tableView==_centerTableView&&page==0){
        return 2;
    }else if(tableView==_centerTableView&&page==_dataArray.count-1){
        return page;
    }else if(tableView==_rightTableView&&page<_dataArray.count-1){
        return page+2;
    }else if(tableView==_rightTableView&&page==_dataArray.count-1){
        return page+1;
    }
    return 0;
}

/**
 刷新tableView数据
 */
- (void)reloadData
{
    [_leftTableView reloadData];
    [_centerTableView reloadData];
    [_rightTableView reloadData];
}
@end
