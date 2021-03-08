//
//  PractiseViewController.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/6.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "PractiseViewController.h"
#import "PractiseTableViewCell.h"
#import "LeafLevel.h"
#import "Tools.h"
#import "StatisticsView.h"


#define kScreenX [UIScreen      mainScreen].bounds.size.width //屏幕宽度
#define kScreenY [UIScreen      mainScreen].bounds.size.height//屏幕高度

@interface PractiseViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *practiseArray;
@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, assign,readonly) int currentPage;
@end

@implementation PractiseViewController
{
    UITableView *_leftTableView;
    UITableView *_centreTableView;
    UITableView *_rightTableView;
    UIScrollView *_scrollView;
    int headHeigt;
    Tools *tools;
    NSMutableArray *_answerArr;
    UIToolbar *_footToolBar;
    StatisticsView *_sheetView;
    UIButton *toolsBtn;
    UILabel *toolsLabel;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithSub];
    _leftTableView.delegate     = self;
    _leftTableView.dataSource   = self;
    _centreTableView.delegate   = self;
    _centreTableView.dataSource = self;
    _rightTableView.delegate    = self;
    _rightTableView.dataSource  = self;
    
    _scrollView.delegate = self;
    
    self.navigationItem.title = self.courseTitle;
    
    _answerArr = [[NSMutableArray alloc]init ];
    for(int i=0;i<_practiseArray.count;i++){
        [_answerArr addObject:@"0"];
    }
    
    _currentPage = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



-(void)initWithSub
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenX, kScreenY-60)];
    // _scrollView.frame = CGRectMake(0, 0, kScreenX, kScreenY);
    
    tools = [[Tools alloc]init];
    
    if (self.practiseArray.count >1) {
        _scrollView.contentSize = CGSizeMake(kScreenX*2, 0);
    }
    
    //_scrollView.contentSize=CGSizeMake(kScreenX*3,0);
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenX, kScreenY) style:UITableViewStyleGrouped];
    _centreTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenX, 0, kScreenX, kScreenY) style:UITableViewStyleGrouped];
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenX*2, 0, kScreenX, kScreenY) style:UITableViewStyleGrouped];
    //背景颜色  测试用
    //    _leftTableView.backgroundColor = [UIColor blueColor];
    //    _centreTableView.backgroundColor = [UIColor greenColor];
    //    _rightTableView.backgroundColor = [UIColor redColor];
    
    //不允许表格移动
    [_leftTableView setScrollEnabled:NO];
    [_centreTableView setScrollEnabled:NO];
    [_rightTableView setScrollEnabled:NO];
    
    //设置自动分页
    _scrollView.pagingEnabled = YES;
    //取消弹动效果
    _scrollView.bounces = NO;
    //隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    
    //设置当前点
    // _scrollView.contentOffset = CGPointMake(0, 0);
    //_scrollView.delaysContentTouches=NO;
   
    
    [_scrollView addSubview:_leftTableView];
    [_scrollView addSubview:_centreTableView];
    [_scrollView addSubview:_rightTableView];
    [self.view addSubview:_scrollView];
    

    [self createToolBar];
    [self createSheetView];
}


#pragma 创建底部工具栏
-(void)createToolBar
{
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenY-60, kScreenX, 60)];
    barView.backgroundColor = [UIColor lightGrayColor];
    NSArray *arr = @[[NSString stringWithFormat:@"1/%lu",(unsigned long)self.practiseArray.count],@"查看答案",@"收藏本题"];
    for(int i= 0; i<arr.count;i++){
        toolsBtn = [[UIButton alloc]initWithFrame:CGRectMake(((kScreenX-kScreenX/3)/4)*(i+1)+40*i, 0, 40, 40)];
        [toolsBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",16+i]] forState:UIControlStateNormal];
        [toolsBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-2",16+i]] forState:UIControlStateHighlighted];
        [toolsBtn setTag:100+i];
        [toolsBtn addTarget:self action:@selector(selectorBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        toolsLabel = [[UILabel alloc]initWithFrame:CGRectMake(((kScreenX-kScreenX/3)/4)*(i+1)+40*i-10,40, 60, 20)];
        toolsLabel.text=  arr[i];
        toolsLabel.textAlignment = NSTextAlignmentCenter;
        toolsLabel.font = [UIFont systemFontOfSize:14];
        [barView addSubview:toolsBtn];
        [barView addSubview:toolsLabel];
    
    }
    [self.view addSubview:barView];
}

-(void)createSheetView
{
    _sheetView = [[StatisticsView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-150) withSuperView:self.view];
    [self.view addSubview:_sheetView];
}

-(void)selectorBtn:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    //UIView *view;
    switch (tag) {
        case 100:
        {
            [UIView animateWithDuration:0.4 animations:^{
                _sheetView.frame = CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height-150);
                
                
            }];
        }
           //[[StatisticsView alloc]initWithFrame:self.view.frame withSuperView:self.view];
            //[self.view addSubview:view];
            break;
        default:
            break;
    }

}



// 减速停止了时执行，
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffSet = _scrollView.contentOffset;
    int page = (int)currentOffSet.x/kScreenX;
    //NSLog(@"%d",page);
    if (page<self.practiseArray.count-1 && page >0) {
        _scrollView.contentSize = CGSizeMake(currentOffSet.x+kScreenX*2, 0);
        _centreTableView.frame = CGRectMake(currentOffSet.x, 0, kScreenX, kScreenY);
        _leftTableView.frame = CGRectMake(currentOffSet.x-kScreenX, 0, kScreenX, kScreenY);
        _rightTableView.frame = CGRectMake(currentOffSet.x+kScreenX, 0, kScreenX, kScreenY);
    }
    
    _currentPage = page;
    
    
    
    [self reloadData];
}

//刷新数据
-(void)reloadData
{
    [_leftTableView reloadData];
    [_centreTableView reloadData];
    [_rightTableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LeafLevel *leafLevel = _practiseArray[_currentPage];
    if(leafLevel.mType == 2){
        return 2;
    }else{
        return 4;
    }
    
}

//头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UILabel *label = [self getQuestion:tableView];
    
    
    return label.frame.size.height;
    
    
}

//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UILabel *label = [self getQuestion:tableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height)];
    
    view.backgroundColor = [UIColor colorWithWhite:0.947 alpha:1.000];
    
    [view addSubview:label];
    
    
    
    return view;
    
    
}


-(UILabel *)getQuestion:(UITableView *)tableView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    LeafLevel *leafLevel;
    //如果为第一页
    
    if(tableView == _leftTableView && _currentPage == 0){
        leafLevel = _practiseArray[_currentPage];
    }else if(tableView ==_leftTableView && _currentPage>0){
        leafLevel = _practiseArray[_currentPage-1];
    }else if(tableView == _centreTableView && _currentPage == 0 ){
        leafLevel = _practiseArray[_currentPage+1];
    }else if(tableView == _centreTableView && _currentPage>0 && _currentPage<_practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage];
    }else if(tableView == _centreTableView && _currentPage == _practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage-1];
    }else if(tableView == _rightTableView && _currentPage == _practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage];
    }else if(tableView == _rightTableView && _currentPage<_practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage+1];
    }
    int page = [self getPage:tableView andCurrentpage:_currentPage];
    
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentLeft;//居中显示
    CGSize size;
    if (leafLevel.mType == 1) {
        
        label.text = [NSString stringWithFormat:@"%d.%@",page,[[tools getAnsWerWithString:leafLevel.mQuestion]objectAtIndex:0]];
        
        size = [tools sizeWithString:[[tools getAnsWerWithString:leafLevel.mQuestion]objectAtIndex:0] font:label.font];
        
    }else if(leafLevel.mType == 2){
        label.text = [NSString stringWithFormat:@"%d.%@",page,leafLevel.mQuestion];
        size =[tools sizeWithString:leafLevel.mQuestion font:label.font];
        
    }
    
    
    label.frame = CGRectMake(10, 0,kScreenX,  size.height+50);  //+50 自动换行标题 标点符号不计入  原因未知 ###########
    
    NSLog(@"%d --- %f",page+1,size.height);
    return  label;
    
}


#pragma  得到当前页
-(int )getPage:(UITableView *)tableView andCurrentpage:(int) currentPage
{
    
    //如果为第一页
    int page = 0;
    if(tableView == _leftTableView && currentPage == 0){
        page = currentPage+1;
    }else if(tableView ==_leftTableView && currentPage>0){
        page = currentPage;
    }else if(tableView == _centreTableView && currentPage == 0 ){
        page = currentPage+2;
    }else if(tableView == _centreTableView && currentPage>0 && currentPage<_practiseArray.count-1){
        page = currentPage+1;
    }else if(tableView == _centreTableView && currentPage == _practiseArray.count-1){
        page = currentPage;
    }else if(tableView == _rightTableView && currentPage == _practiseArray.count-1){
        page = currentPage+1;
    }else if(tableView == _rightTableView && currentPage<_practiseArray.count-1){
        page = currentPage+2;
    }
    return page;
}

#pragma 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PractiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"practiseCell"];
    if(cell == nil){
        //向数据源注册 cell
        [tableView registerNib:[UINib nibWithNibName:@"PractiseTableViewCell" bundle:nil] forCellReuseIdentifier:@"practiseCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"practiseCell"];
        
        
    }
    
    LeafLevel *leafLevel = [self getModel:tableView];
    
    
    cell.answerLabel.layer.masksToBounds = YES;
    cell.answerLabel.layer.cornerRadius = 20;
    
    cell.answerLabel.text = [NSString stringWithFormat:@"%c",(char)('A'+indexPath.row)];
    
    
    
    cell.IntroduceLabel.font = [UIFont systemFontOfSize:18];
    
    //判断题型
    if (leafLevel.mType ==1) {
        cell.IntroduceLabel.text = [[tools getAnsWerWithString:leafLevel.mQuestion]objectAtIndex:indexPath.row+1];
        //cell.in
        CGSize size = [tools sizeWithString:cell.IntroduceLabel.text font:cell.IntroduceLabel.font];
        cell.frame = CGRectMake(0, 0, kScreenX, size.height);
        
    }else if(leafLevel.mType == 2){
        if(indexPath.row == 0){
            cell.IntroduceLabel.text = @"对";
        }else if(indexPath.row == 1){
            cell.IntroduceLabel.text = @"错";
        }
        
    }
    
    //判断答案对错
    int page = [self getPage:tableView andCurrentpage:_currentPage];
    if ([_answerArr[page-1] intValue] != 0) {
        if([leafLevel.mAnswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+(int)indexPath.row]]){
            cell.answerLabel.hidden = YES;
            cell.image.hidden = NO;
            cell.image.image = [UIImage imageNamed:@"19"];
        }else if(![leafLevel.mAnswer isEqualToString:[NSString stringWithFormat:@"%c",'A'+[_answerArr[page-1]intValue]-1]]
                 &&indexPath.row == [_answerArr[page-1] intValue]-1){
            cell.answerLabel.hidden = YES;
            cell.image.hidden = NO;
            cell.image.image = [UIImage imageNamed:@"20"];
        }else{
            cell.answerLabel.hidden = NO;
            cell.image.hidden = YES;
        }
    }else{
        cell.answerLabel.hidden = NO;
        cell.image.hidden = YES;
        
    }
    
    
    
    
    // cell.image.image = [UIImage imageNamed:@"19"];
    //cell.answerLabel.hidden = YES;
    
    
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int page = [self getPage:tableView andCurrentpage:_currentPage];
    if ([_answerArr[page-1] intValue] != 0) {
        return;
    }else{
       
        [_answerArr replaceObjectAtIndex:page-1 withObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
        
    }
    
    
   [self reloadData];
    
    
    
}

#pragma 得到答案数据
-(LeafLevel *)getModel:(UITableView *)tableView
{
    
    LeafLevel *leafLevel;
    //如果为第一页
    if(tableView == _leftTableView && _currentPage == 0){
        leafLevel = _practiseArray[_currentPage];
    }else if(tableView ==_leftTableView && _currentPage>0){
        leafLevel = _practiseArray[_currentPage-1];
    }else if(tableView == _centreTableView && _currentPage == 0 ){
        leafLevel = _practiseArray[_currentPage+1];
    }else if(tableView == _centreTableView && _currentPage>0 && _currentPage<_practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage];
    }else if(tableView == _centreTableView && _currentPage == _practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage-1];
    }else if(tableView == _rightTableView && _currentPage == _practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage];
    }else if(tableView == _rightTableView && _currentPage<_practiseArray.count-1){
        leafLevel = _practiseArray[_currentPage+1];
        
    }
    
   
    return leafLevel;
}


#pragma 底部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithWhite:0.947 alpha:1.000];
    
    UILabel *label = [[UILabel alloc]init];
    
    LeafLevel *leafLevel = [self getModel:tableView];
    
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithRed:0.020 green:0.459 blue:0.000 alpha:1.000];
    
    label.text = [NSString stringWithFormat:@"%@",leafLevel.mDesc];
    CGSize size = [tools sizeWithString:label.text font:label.font];
    
    label.frame = CGRectMake(0, 10, kScreenX, size.height);
    [view addSubview:label];
    
    int page = [self getPage:tableView andCurrentpage:_currentPage];
    if ([_answerArr[page-1] isEqualToString:@"0"]) {
        return nil;
    }
    
    return view;
    
    
    
}

#pragma 底部视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]init];
    
    LeafLevel *leafLevel = [self getModel:tableView];
    
    
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithRed:0.020 green:0.459 blue:0.000 alpha:1.000];
    
    label.text = [NSString stringWithFormat:@"%@",leafLevel.mDesc];
    CGSize size = [tools sizeWithString:label.text font:label.font];
    
    
    
    return size.height+20;
}








@end
