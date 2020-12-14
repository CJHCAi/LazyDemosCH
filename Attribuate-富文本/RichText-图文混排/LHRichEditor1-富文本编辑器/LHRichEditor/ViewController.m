//
//  ViewController.m
//  LHRichEditor
//
//  Created by 刘昊 on 2018/5/9.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "ViewController.h"
#import "LHListCell.h"
#import "XSIndexModel.h"
#import "LHEditViewController.h"
#import "SqliteUtil.h"
#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_mainTableView;
    NSMutableArray *_dataArr;

    SqliteUtil *_indexdb;
    NSInteger _yearindex;
    NSInteger _monthIndex;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"resh" object:nil];
}

- (void)refresh:(NSNotification *)info{
    //刷新数据吧
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld",_yearindex,_monthIndex];
    NSDate * date = [formatter dateFromString:dateStr];
    NSCalendar * calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar1 rangeOfUnit:NSCalendarUnitDay
                                    inUnit: NSCalendarUnitMonth
                                   forDate:date];
    
    [_dataArr removeAllObjects];
    
    for (int i = 0; i<range.length; i++) {
       
        NSDictionary *dic = @{
                              @"day":[NSString stringWithFormat:@"%ld",range.length -i],
                              @"type":@"0",
                              @"content":@"没内容喔",
                              @"year":[NSString stringWithFormat:@"%ld",_yearindex],
                              @"moth":[NSString stringWithFormat:@"%ld",_monthIndex],
                              @"index":[NSString stringWithFormat:@"%d",i],
                              };
        XSIndexModel *model = [[XSIndexModel alloc]initWithDic:dic];
        [_dataArr addObject:model];
    }

    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_index WHERE workId like '%%%@%%'",[NSString stringWithFormat:@"%ld%ld",_yearindex,_monthIndex]];
    NSArray *workIdArr = [_indexdb teacherAnwser:sql];
    if (workIdArr.count) {
        for (NSDictionary *indesDic in workIdArr) {
            XSIndexModel *indexModel = [[XSIndexModel alloc]initWithDic:indesDic];
           [_dataArr replaceObjectAtIndex:indexModel.index withObject:indexModel];
        }
    }
    [_mainTableView reloadData];
    
}

- (void)initData{
    
    _dataArr = [NSMutableArray array];
    

    //索引表
    _indexdb = [SqliteUtil sharedSqliteUtil];
    [_indexdb creatTable:@"CREATE TABLE IF NOT EXISTS t_index (id integer PRIMARY KEY AUTOINCREMENT, contexText text  NOT NULL, workId text NOT NULL);"];
    
    //日记本项目所以使用calender加载数据，可替换索引和数据源
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *calendarArr =  [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld",calendarArr.year,calendarArr.month];
    NSDate * date = [formatter dateFromString:dateStr];
    NSCalendar * calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar1 rangeOfUnit:NSCalendarUnitDay
                                    inUnit: NSCalendarUnitMonth
                                   forDate:date];
    
    _yearindex = calendarArr.year;
    _monthIndex = calendarArr.month;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_index WHERE workId like '%%%@%%'",[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%ld",calendarArr.year], [NSString stringWithFormat:@"%ld",calendarArr.month]]];
    NSArray *workIdArr = [_indexdb teacherAnwser:sql];
    for (int i = 0; i<range.length; i++) {
        //检查索引 如果存在
        NSDictionary *dic = @{
                              @"day":[NSString stringWithFormat:@"%ld",range.length -i],
                              @"type":@"0",
                              @"content":@"没内容喔",
                              @"year":[NSString stringWithFormat:@"%ld",calendarArr.year],
                              @"moth":[NSString stringWithFormat:@"%ld",calendarArr.month],
                              @"index":[NSString stringWithFormat:@"%d",i],
                              };
        XSIndexModel *model = [[XSIndexModel alloc]initWithDic:dic];
        [_dataArr addObject:model];
        
       
    }
    
    if (workIdArr.count) {
        for (NSDictionary *indesDic in workIdArr) {
            XSIndexModel *indexModel = [[XSIndexModel alloc]initWithDic:indesDic];
            [_dataArr replaceObjectAtIndex:indexModel.index withObject:indexModel];
        }
    }
    
}

- (void)setUI{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kAppFrameWidth,kAppFrameHeight - 64) style:UITableViewStylePlain];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        XSIndexModel *model = _dataArr[indexPath.row];
        static NSString *ID = @"XDShowBookCell";
        LHListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
             cell = [[LHListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //  cell.titleLab.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.model = model;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     XSIndexModel *model = _dataArr[indexPath.row];
    LHEditViewController *vc = [[LHEditViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}





@end
