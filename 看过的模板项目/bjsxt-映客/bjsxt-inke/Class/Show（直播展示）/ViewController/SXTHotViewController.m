//
//  SXTHotViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/1.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTHotViewController.h"
#import "SXTLiveHandler.h"
#import "SXTLiveCell.h"
#import "SXTPlayerViewController.h"

static NSString * identifier = @"SXTLiveCell";

@interface SXTHotViewController ()

@property (nonatomic, strong) NSMutableArray * datalist;

@end

@implementation SXTHotViewController

- (NSMutableArray *)datalist {
    
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SXTLiveCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64 + 49 + 50, 0);
}

- (void)loadData {
    
    [SXTLiveHandler executeGetHotLiveTaskWithSuccess:^(id obj) {
        
        [self.datalist addObjectsFromArray:obj];
        [self.tableView reloadData];
        
    } failed:^(id obj) {
        
        NSLog(@"%@",obj);
    }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SXTLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.live = self.datalist[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70 + SCREEN_WIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SXTLive * live = self.datalist[indexPath.row];
    
    SXTPlayerViewController * playerVC = [[SXTPlayerViewController alloc] init];
    playerVC.live = live;
    [self.navigationController pushViewController:playerVC animated:YES];
    
    
    /*系统自带的播放器播放不了直播内容
    
    MPMoviePlayerViewController * movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:live.streamAddr]];
    
    [self presentViewController:movieVC animated:YES completion:nil];
    */
}



@end
