//
//  ViewController.m
//  ShrinkageTB
//
//  Created by xxlc on 2019/6/25.
//  Copyright © 2019 yunfu. All rights reserved.
//

#import "ViewController.h"
#import "HomeFooterCell.h"
#import "HomeNewDetailsCell.h"




@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat wkHeight;
@property (nonatomic, assign) NSInteger moreTag;
@property (nonatomic, assign) NSInteger moreScrollTag;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    _wkHeight = 0.0f;
    _moreTag = 0;
    _moreScrollTag = 0;
    
}

#pragma mark -tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = 0;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 10;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {//wkwebview
        static NSString * identifer = @"cell";
        HomeNewDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[HomeNewDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        if (_wkHeight > 1.0f) {
            
        }else{
            cell.urlStr = @"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_10051606031226844833%22%7D&n_type=0&p_from=1";
            Weakify(weakSelf);
            cell.gotoNextBtnBlock = ^(CGFloat wkHeight) {
                [weakSelf wkHeight:wkHeight];
            };
        }
        
        return cell;
    }else{//下面的列表
        
        if (indexPath.row == 0) {//更多
            static NSString * identifer = @"fircell";
            HomeFooterCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (!cell) {
                cell = [[HomeFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            
            if (_moreScrollTag) {
                cell.backView.hidden = YES;
            }
            
            Weakify(weakSelf);
            cell.gotoMoreBtnBlock = ^(NSInteger typeTag) {
                [weakSelf moreBtn:typeTag];
            };
            
            return cell;
        }else{
            static NSString * identifer = @"cellIdentifier";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
            
            return cell;
        }
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_moreTag == 1) {
            return _wkHeight;
        }
        return kScreenHeight;
    }else{
        if (indexPath.row) {
            return 100*m6Scale;
        }else{
            if (_moreScrollTag) {
                return 300*m6Scale;
            }
            return 400*m6Scale;
        }
    }
}
#pragma mark -查看更多
- (void)moreBtn:(NSInteger)type{
    if (type == 10) {//查看更多
        _moreScrollTag = 1;
        _moreTag = 1;
        [_tableView reloadData];
    }else{
        
    }
}
#pragma mark -动态高度
- (void)wkHeight:(CGFloat)wkheight{
    _wkHeight = wkheight;
    [_tableView reloadData];
}






@end
