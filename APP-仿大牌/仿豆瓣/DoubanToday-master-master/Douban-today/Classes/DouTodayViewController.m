//
//  DouTodayViewController.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import "DouTodayViewController.h"
#import "DouFilmInfoViewController.h"
#import "DouTodayFilmCell.h"
#import "TodayTransition.h"
#import "MovieModel.h"

@interface DouTodayViewController ()
<
UINavigationControllerDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *movieData;


@property (nonatomic, strong) UIView *headerView;// 头像
@property (nonatomic, strong) UILabel *timeLabel;// 时间
@property (nonatomic, strong) UILabel *titleLabel;// Today
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) UITableViewCell *selectedCell;
@end

@implementation DouTodayViewController{
    NSIndexPath *selectIndexPath;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.delegate = self;
    [self prefersStatusBarHidden];
    
    __weak typeof(self) weakself = self;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [weakself getDataFromDOUBAN];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self buildHeaderView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIView animateWithDuration:0.1 animations:^{
        self.selectedCell.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark - UI

- (UIView *)buildHeaderView {
    
    
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 115);
    
    self.timeLabel.frame  = CGRectMake(SCREEN_RATIO(22), 30, SCREEN_WIDTH/2, 14);
    self.timeLabel.text = [self getWeekDay];
    
    self.titleLabel.frame = CGRectMake(SCREEN_RATIO(22),55 , (SCREEN_WIDTH/3)*2, 30);
    
    self.userButton.frame = CGRectMake(SCREEN_WIDTH-84-SCREEN_RATIO(22), 18, 84, 84);
    self.userButton.layer.masksToBounds = YES;
    self.userButton.layer.cornerRadius = 22;
    [self.userButton addTarget:self action:@selector(userButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.userButton setImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
    [self.headerView addSubview:self.timeLabel];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.userButton];
    
    return self.headerView;
}


#pragma mark - response
- (void)userButtonClick {
    
}

#pragma mark - 获取当前时间，日期

- (NSString*)getWeekDay {
    
    NSDate*date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:date];
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    NSString *weekTime = [weekdays objectAtIndex:theComponents.weekday];
    return [NSString stringWithFormat:@"%@  %@",dateTime,weekTime];
}

#pragma mark - 截取view
- (UIImage *)imageFromView {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


#pragma mark - data
- (void)getDataFromDOUBAN{
    //豆瓣电影数据
    NSString *requestUrl;
    NSDictionary *params;
    if (!IsStrEmpty([DzwSingleton sharedInstance].currentCity)) {
        requestUrl = @"https://api.douban.com/v2/movie/in_theaters?";
        params = @{@"city":[DzwSingleton sharedInstance].currentCity};
    }else{
        requestUrl = @"https://api.douban.com/v2/movie/in_theaters";
    }
    [DzwBaseNetWork baseRequest:requestUrl httpMethod:BaseNetWorkStyleGet parameters:params success:^(id responseObject) {
        [self reSortDataWithData:responseObject];
        [self.tableView reloadData];
//        NSLog(@"%@",responseObject);
    } failString:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)reSortDataWithData:(NSDictionary *)dict{
    NSDictionary *data = dict;
    NSArray *movieList = data[@"subjects"];

    [movieList enumerateObjectsUsingBlock:^(NSDictionary *movieObj, NSUInteger idx, BOOL * _Nonnull stop) {

        MovieModel *model = [MovieModel new];
        model.title = [NSString stringWithFormat:@"%@",movieObj[@"title"]];
        model.original_title = movieObj[@"original_title"];
        model.average = movieObj[@"rating"][@"average"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",movieObj[@"images"][@"large"]]]]];
        model.postersPath = image;
        model.movieID = movieObj[@"id"];
        
        [self.movieData addObject:model];

    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_WIDTH-40)*1.3+25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DouTodayFilmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doucellID"];
    if (cell == nil) {
        cell = [[DouTodayFilmCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"doucellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shouldGroupAccessibilityChildren = YES;
    }
    
    __block MovieModel * model =self.movieData[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.original_title;
    
    [cell.bgimageView setImage:model.postersPath];
        

    cell.transform = CGAffineTransformMakeScale(1, 1);
    
    return cell;
    
}
#pragma mark -- 高亮状态
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath  {
    selectIndexPath = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%u",cell.selected);
    
    if ([selectIndexPath isEqual:indexPath]) {
        [UIView animateWithDuration:0.2 animations:^{
            cell.transform = CGAffineTransformMakeScale(1, 1);
            return;
        }];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    MovieModel *model = self.movieData[indexPath.row];
    
    DouTodayFilmCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    DouFilmInfoViewController *detail = [[DouFilmInfoViewController alloc]init];
    detail.selectIndexPath = indexPath;
    detail.bgImage = [self imageFromView];

    MovieInfoModel *infomodel = [MovieInfoModel new];
    infomodel.title = model.title;
    infomodel.original_title = model.original_title;
    infomodel.movieId = model.movieID;
    infomodel.posters = model.postersPath;
    infomodel.average = model.average;
    detail.model = infomodel;

    [self.navigationController pushViewController:detail animated:YES];
}



#pragma mark - UIViewControllerAnimatedTransitioning
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (fromVC == self && [toVC isMemberOfClass:[DouFilmInfoViewController class]]){
        TodayTransition *transAnimate = [[TodayTransition alloc]initWithTransitionWithTransitionType:TodayTransitionTypePush];
        return transAnimate;
    }
    return nil;
}


#pragma mark - lazy load
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor clearColor];
        
    }
    return _headerView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textColor = [Utils colorWithHexString:@"666666"];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:30.f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [Utils colorWithHexString:@"333333"];
        _titleLabel.text = @"Today";
    }
    return _titleLabel;
}

- (UIButton *)userButton {
    if (_userButton == nil) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userButton.backgroundColor = [UIColor whiteColor];
    }
    return _userButton;
}


-(NSMutableArray *)movieData{
    if (!_movieData) {
        _movieData = [NSMutableArray array];
    }
    return _movieData;
}

@end
