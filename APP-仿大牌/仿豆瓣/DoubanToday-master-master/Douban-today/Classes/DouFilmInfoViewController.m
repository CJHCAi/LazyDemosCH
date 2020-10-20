//
//  DouFilmInfoViewController.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//


#import "DouFilmInfoViewController.h"
#import "TodayTransition.h"

@interface DouFilmInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;     // 上个页面截图
@property (nonatomic, strong) UILabel *averagelabel;        // 豆瓣评分
@property (nonatomic, strong) UILabel *contentLabel;        // 简介
@property (nonatomic, strong) UIImageView *headerImageView; // 大图
@property (nonatomic, strong) UILabel *titleLabel;          // 主标题
@property (nonatomic, strong) UILabel *titleTwoLabel;       // 副标题

@end

@implementation DouFilmInfoViewController{
    CGFloat cellHeight;
    CGFloat startPointX;
    CGFloat startPointY;
    CGFloat scale;
    BOOL isHorizontal;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prefersStatusBarHidden];
    
   
    [self requestData];
   
}

- (void)requestData{
    __weak typeof(self) weakself = self;
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSString *requestUrl = [NSString stringWithFormat:@"https://api.douban.com/v2/movie/subject/%@",self.model.movieId];
        [DzwBaseNetWork baseRequest:requestUrl httpMethod:BaseNetWorkStyleGet parameters:nil success:^(id responseObject) {
            MovieInfoModel *model = self.model;
            model.summary = responseObject[@"summary"];
            weakself.model = model;
            weakself.content = self.model.summary;
        } failString:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildSubviews];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    scale = 1;
}



#pragma mark - UI
- (void)buildSubviews {
    // 背景图
    [self.view addSubview:self.bgImageView];
    self.bgImageView.image = self.bgImage;
    // 背景毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:effectView];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self tableViewHeaderView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.tableView addGestureRecognizer:pan];
    pan.delegate = self;
    
}

- (UIView *)tableViewHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*1.3)];
    
    self.headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*1.3);
    self.headerImageView.image = [UIImage imageNamed:self.imageName];
    [headerView addSubview:self.headerImageView];
    self.titleLabel.text =self.titles;
    self.titleTwoLabel.text = self.titleTwo;
    [headerView addSubview:self.titleLabel];
    [headerView addSubview:self.titleTwoLabel];
    return headerView;
}


#pragma mark - tableview delegate && ..

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [Utils withString:self.contentLabel.text font:self.contentLabel.font ViewWidth:SCREEN_WIDTH-36];
    return 62+size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infocellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    self.contentLabel.text = self.content;
    CGSize size = [Utils withString:self.contentLabel.text font:self.contentLabel.font ViewWidth:SCREEN_WIDTH-36];
    self.averagelabel.frame = CGRectMake(18, 6, SCREEN_WIDTH-36, 30);
    self.contentLabel.frame = CGRectMake(18,42, SCREEN_WIDTH-36, size.height);
    [cell.contentView addSubview:self.averagelabel];
    [cell.contentView addSubview:self.contentLabel];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        
        CGRect rectQ = self.headerImageView.frame;
        rectQ.origin.y = scrollView.contentOffset.y;
        self.headerImageView.frame = rectQ;
        
        CGRect rectT = _titleLabel.frame;
        rectT.origin.y = scrollView.contentOffset.y+30;
        _titleLabel.frame = rectT;
        
        CGRect rectC = _titleTwoLabel.frame;
        rectC.origin.y = scrollView.contentOffset.y +SCREEN_WIDTH*1.3-30;
        _titleTwoLabel.frame = rectC;
    }
}

#pragma mark - 下拉手势
- (void)pan:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint currentPoint =[pan locationInView:self.tableView];
            startPointY = currentPoint.y;
            startPointX = currentPoint.x;
            if (startPointX>30) {
                isHorizontal = NO;
            } else {
                isHorizontal = YES;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint =[pan locationInView:self.tableView];
            
            if (isHorizontal) {
                if ((currentPoint.x-startPointX)>(currentPoint.y-startPointY)) {
                    scale = (SCREEN_WIDTH-(currentPoint.x-startPointX))/SCREEN_WIDTH;
                } else {
                    scale = (SCREEN_HEIGHT-(currentPoint.y-startPointY))/SCREEN_HEIGHT;
                }
            } else {
                scale = (SCREEN_HEIGHT-(currentPoint.y-startPointY))/SCREEN_HEIGHT;
            }
            if (scale > 1.0f) {
                scale = 1.0f;
            } else if (scale <=0.8f) {
                scale = 0.8f;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }
            if (self.tableView.contentOffset.y<=0) {
                // 缩放
                self.tableView.transform = CGAffineTransformMakeScale(scale, scale);
                // 圆角
                self.tableView.layer.cornerRadius = 15 * (1-scale)*5*1.08;
            }
            
            if (scale < 0.99) {
                [self.tableView setScrollEnabled:NO];
            } else {
                [self.tableView setScrollEnabled:YES];
            }
        } break;
        case UIGestureRecognizerStateEnded:  {  
            scale = 1;
            self.tableView.scrollEnabled = YES;
            if (scale>0.8) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.tableView.layer.cornerRadius = 0;
                    self.tableView.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
            
        }  break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isMemberOfClass:[NSClassFromString(@"DouTodayViewController") class]]) {
        TodayTransition *animation =  [[TodayTransition alloc] initWithTransitionWithTransitionType:TodayTransitionTypePop];
        return animation;
    }else{
        return nil;
    }
}

#pragma mark - lazy load
-(void)setModel:(MovieInfoModel *)model{
    _model = model;
    self.titles = [NSString stringWithFormat:@"%@",model.title];
    self.titleTwo = model.original_title;
    self.headerImageView.image = model.posters;
    self.content = model.summary;
    self.averagelabel.text = [NSString stringWithFormat:@"豆瓣评分：%.1f",[model.average floatValue]];
    [self.tableView reloadData];

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 30, SCREEN_WIDTH-30, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:25.f];
    }
    return _titleLabel;
}

- (UILabel *)titleTwoLabel {
    if (!_titleTwoLabel) {
        _titleTwoLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, SCREEN_WIDTH*1.3-30, SCREEN_WIDTH*1.3-44, 15)];
        _titleTwoLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
        _titleTwoLabel.textColor = [UIColor whiteColor];
        _titleTwoLabel.alpha = 0.5;
        _titleTwoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleTwoLabel;
}

-(UILabel *)averagelabel{
    if (!_averagelabel) {
        _averagelabel = [[UILabel alloc]init];
        _averagelabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:25.f];
        _averagelabel.textColor = [Utils colorWithHexString:@"7f7f82"];
        _averagelabel.textAlignment = NSTextAlignmentLeft;
        _averagelabel.numberOfLines = 0;
    }
    return _averagelabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.f];        _contentLabel.textColor = [Utils colorWithHexString:@"7f7f82"];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    }
    return _bgImageView;
}

@end
