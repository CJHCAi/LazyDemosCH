//
//  DownloadViewController.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/10.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadCell.h"
#import "CompleteCell.h"
#import "VideoModel.h"
#import "DownloadTool.h"
#import "MyDownloadTask.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomIOSAlertView.h"

@interface DownloadViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *_tf;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCtl;

@property (nonatomic,strong) NSMutableArray *finishArr;  //下载完成的任务

@property (nonatomic,strong) UITableView *tableView1;

@property (nonatomic,strong) MPMoviePlayerController *player;

@end

@implementation DownloadViewController
//
-(NSMutableArray *)finishArr{

    if (!_finishArr) {
        
        _finishArr = [NSMutableArray new];
    }
    return _finishArr;
}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _segmentCtl.selectedSegmentIndex = _index;
    
    //读取归档数据。
    _finishArr = [NSKeyedUnarchiver unarchiveObjectWithFile:VIDEO];
    
    if (_finishArr.count > 0) {
        [_segmentCtl setTitle:[NSString stringWithFormat:@"已下载（%ld）",_finishArr.count] forSegmentAtIndex:0];
    }
    
    DownloadTool *tool = [DownloadTool sharedInstance];
    if (tool.taskArr.count > 0) {
        [_segmentCtl setTitle:[NSString stringWithFormat:@"下载中（%ld）",tool.taskArr.count] forSegmentAtIndex:1];
    }
    
    [self customNaviItem];
    
    [self createUI];
    
    [self reachability];
}
//定制navigationItem
-(void)customNaviItem{
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 160, 44)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"我的下载";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    self.navigationItem.titleView = titleLab;
    
    //自定义返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftBtn.frame = CGRectMake(0, 0, 50, 44);
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"p_top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
}
//
-(void)createUI{
    
    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, SCREENWIDTH, SCREENHEIGHT - 64 - 66) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.rowHeight = 102;
    _tableView1.showsVerticalScrollIndicator = NO;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, SCREENWIDTH, SCREENHEIGHT - 64 - 66) style:UITableViewStylePlain];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.rowHeight = 85;
    _tableView2.showsVerticalScrollIndicator = NO;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView2];
    
    if (_segmentCtl.selectedSegmentIndex == 0) {
        _tableView2.hidden = YES;
        _tableView1.hidden = NO;
    }else{
        _tableView2.hidden = NO;
        _tableView1.hidden = YES;
    }
    
    DownloadTool *tool = [DownloadTool sharedInstance];
    NSMutableArray *arr = tool.taskArr;
    tool.proBlock = ^(MyDownloadTask *task){
        //回调刷新下载进度条
        NSInteger index = [arr indexOfObject:task];
        [self reloadProgressIn:index];
    };
    tool.finishBlock = ^{
        //结束一个任务回调刷新下载tableview
        [self.tableView2 reloadData];
        //切换到已下载界面
        _segmentCtl.selectedSegmentIndex = 0;
        [self changeIndex:_segmentCtl];
        
        DownloadTool *tool = [DownloadTool sharedInstance];
        if (tool.taskArr.count > 0) {
            [_segmentCtl setTitle:[NSString stringWithFormat:@"下载中（%ld）",tool.taskArr.count] forSegmentAtIndex:1];
        }else{
            [_segmentCtl setTitle:@"下载中" forSegmentAtIndex:1];
        }
    };
    tool.modBlock = ^(VideoModel *model){
        //结束一个任务回调刷新视频tableview
        [self.finishArr addObject:model];
        [self.tableView1 reloadData];
        
        if (_finishArr.count > 0) {
            [_segmentCtl setTitle:[NSString stringWithFormat:@"已下载（%ld）",_finishArr.count] forSegmentAtIndex:0];
        }else{
            [_segmentCtl setTitle:@"已下载" forSegmentAtIndex:0];
        }
    };
    tool.failedBlock = ^(MyDownloadTask *task){
        //下载失败回调改变进度条颜色等
        NSInteger index = [arr indexOfObject:task];
        [self changeIn:index];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        [self controlAction:btn];
        
        DownloadTool *tool = [DownloadTool sharedInstance];
        if (tool.taskArr.count > 0) {
            [_segmentCtl setTitle:[NSString stringWithFormat:@"下载中（%ld）",tool.taskArr.count] forSegmentAtIndex:1];
        }else{
            [_segmentCtl setTitle:@"下载中" forSegmentAtIndex:1];
        }
    };
}
//检测网络状态
- (void)reachability{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变了, 就会调用这个block
        if (status == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络似乎出了点错误，请检查网络..." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            //断网的时候任务状态全部为失败
            DownloadTool *tool = [DownloadTool sharedInstance];
            for (MyDownloadTask *task in tool.taskArr) {
                task.status = DownloadTaskStatusFailed;
            }
            
            [_tableView2 reloadData];
        }
    }];
    //开始监控
    [mgr startMonitoring];
}


#pragma mark - tableView代理方法
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _tableView1) {
        
        if (_finishArr.count == 0) {
            UILabel *lab = [UILabel new];
            lab.text = @"没有视频";
            lab.textColor = COLOR(180, 180, 180, 1);
            [tableView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(tableView);
            }];
        }else{
            for (UIView *sub in tableView.subviews) {
                
                if ([sub isKindOfClass:[UILabel class]]) {
                    [sub removeFromSuperview];
                }
            }
        }
        return _finishArr.count;
    }
    
    if ([DownloadTool sharedInstance].taskArr.count == 0) {
        
        UILabel *lab = [UILabel new];
        lab.text = @"没有下载任务";
        lab.textColor = COLOR(180, 180, 180, 1);
        [tableView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(tableView);
        }];
    }else{
        for (UIView *sub in tableView.subviews) {
            
            if ([sub isKindOfClass:[UILabel class]]) {
                [sub removeFromSuperview];
            }
        }
    }
    return [DownloadTool sharedInstance].taskArr.count;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView1) {
        
        CompleteCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CompleteCell" owner:nil options:nil][0];
        
//        NSInteger index = _finishArr.count - indexPath.row - 1;
        
        if (_finishArr.count > 0) {
            
            VideoModel *model = _finishArr[indexPath.row];
//            VideoModel *model = _finishArr[index];
            
            cell.imgView.image = [UIImage imageWithData:model.poster];
            cell.titleLab.text = model.title;
            cell.msgLab.text = [NSString stringWithFormat:@"%@  %@",model.duration,model.memorySize];
        }
        
        cell.playBtn.tag = indexPath.row;
        [cell.playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.renameBtn.tag = indexPath.row;
        [cell.renameBtn addTarget:self action:@selector(renameVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.tag = indexPath.row;
        [cell.shareBtn addTarget:self action:@selector(shareVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    DownloadCell *cell = [[DownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownloadCell"];
    
    DownloadTool *tool = [DownloadTool sharedInstance];
    MyDownloadTask *task = tool.taskArr[indexPath.row];
    
    if (task.status == DownloadTaskStatusRunning) {
        
        cell.progressView.tintColor = COLOR(255, 158, 87, 1);
        [cell.controlBtn setImage:[UIImage imageNamed:@"wdxz_start"] forState:UIControlStateNormal];

    }else if (task.status == DownloadTaskStatusSuspended){
        
        cell.progressView.tintColor = COLOR(164, 164, 164, 1);
        [cell.controlBtn setImage:[UIImage imageNamed:@"wdxz_suspended"] forState:UIControlStateNormal];
    
    }else if (task.status == DownloadTaskStatusFailed){
    
        cell.progressView.tintColor = COLOR(255, 109, 109, 1);
        [cell.controlBtn setImage:[UIImage imageNamed:@"wdxz_retry"] forState:UIControlStateNormal];
    }
    
    if (task.progress.totalUnitCount == 0) {
        cell.progressView.progress = 0;
    }else{
        cell.progressView.progress = 1.0 * task.progress.completedUnitCount / task.progress.totalUnitCount;
    }
    cell.progressLab.text = [NSString stringWithFormat:@"%.0f%%",cell.progressView.progress * 100];
    cell.titleLab.text = task.title;
    
    [cell.controlBtn addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.controlBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteTask:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _tableView1) {
        
        VideoModel *model = _finishArr[indexPath.row];
        
        NSString *path = model.path;
        
        CompleteCell *cell = [_tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];//本地的
            
            _player.view.frame = cell.imgView.frame;
            _player.view.backgroundColor = [UIColor clearColor];
            
            [cell addSubview:_player.view];
            
            _player.movieSourceType = MPMovieSourceTypeFile;
            _player.controlStyle = MPMovieControlStyleFullscreen;
            _player.shouldAutoplay = YES;
            _player.fullscreen = YES;
            _player.scalingMode = MPMovieScalingModeAspectFit;
            
            [_player play];
            
            //监听播放状态
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChange)name:MPMoviePlayerPlaybackStateDidChangeNotification object:_player];
            //监听播放完成
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedPlay:)name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
            //退出全屏通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:)name:MPMoviePlayerDidExitFullscreenNotification object:_player];
        }else{
            
            HUDTEXT(@"播放失败！", self.view);
        }
    }
}


#pragma mark - 各种事件
#pragma mark -
//
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//
- (IBAction)changeIndex:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _tableView2.hidden = YES;
            _tableView1.hidden = NO;
            break;
        case 1:
            _tableView1.hidden = YES;
            _tableView2.hidden = NO;
            break;
        default:
            break;
    }
}
//
-(void)reloadProgressIn:(NSInteger)index{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        DownloadTool *tool = [DownloadTool sharedInstance];
        
        MyDownloadTask *task = tool.taskArr[index];
        
        DownloadCell *cell = [_tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        cell.progressView.progress = 1.0 * task.progress.completedUnitCount / task.progress.totalUnitCount;
        
        cell.progressLab.text = [NSString stringWithFormat:@"%.0f%%",cell.progressView.progress * 100];
        
        //
        if (CGColorEqualToColor(cell.progressView.tintColor.CGColor, COLOR(255, 109, 109, 1).CGColor)) {
            cell.progressView.tintColor = COLOR(255, 158, 87, 1);
            [cell.controlBtn setImage:[UIImage imageNamed:@"wdxz_start"] forState:UIControlStateNormal];
        }
    });
}
//
-(void)changeIn:(NSInteger)index{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        DownloadCell *cell = [_tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        cell.progressView.tintColor = COLOR(255, 109, 109, 1);
        
        [cell.controlBtn setImage:[UIImage imageNamed:@"wdxz_retry"] forState:UIControlStateNormal];
    });
}
//
-(void)controlAction:(UIButton *)btn{
    
    DownloadTool *tool = [DownloadTool sharedInstance];
    
    if (tool.taskArr.count > 0) {
        
        MyDownloadTask *task = tool.taskArr[btn.tag];
        
        if (task.status == DownloadTaskStatusRunning) {
            
            [btn setImage:[UIImage imageNamed:@"wdxz_suspended"] forState:UIControlStateNormal];
            
            DownloadCell *cell = [_tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
            cell.progressView.tintColor = COLOR(164, 164, 164, 1);
            
            [tool suspendTask:btn.tag];
            
        }else if (task.status == DownloadTaskStatusSuspended){
            
            [btn setImage:[UIImage imageNamed:@"wdxz_start"] forState:UIControlStateNormal];
            
            DownloadCell *cell = [_tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
            cell.progressView.tintColor = COLOR(255, 158, 87, 1);
            
            [tool beginTask:btn.tag];
            
        }else if (task.status == DownloadTaskStatusFailed){
            
            //为防止下载失败之后用户点击多次创建多个下载任务，先禁用btn交互
            btn.userInteractionEnabled = NO;
            //1秒之后重新打开交互
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                btn.userInteractionEnabled = YES;
            });
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_group_t downloadGroup = dispatch_group_create();
                dispatch_group_enter(downloadGroup);
                dispatch_group_wait(downloadGroup, dispatch_time(DISPATCH_TIME_NOW, 1000000000)); // Wait 1 seconds before trying again.
                dispatch_group_leave(downloadGroup);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
                    
                    if ([mgr isReachableViaWiFi]) {
                        //WIFI下直接下载
                        [btn setImage:[UIImage imageNamed:@"wdxz_start"] forState:UIControlStateNormal];
                        
                        DownloadCell *cell = [_tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
                        cell.progressView.tintColor = COLOR(255, 158, 87, 1);
                        
                        [task resumeTaskWith:task.url and:task.title to:self];
                        
                    }else if ([mgr isReachableViaWWAN]){
                        //非WIFI情况下提醒用户
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前网络不是WIFI，确定要继续下载？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [btn setImage:[UIImage imageNamed:@"wdxz_start"] forState:UIControlStateNormal];
                            
                            DownloadCell *cell = [_tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
                            cell.progressView.tintColor = COLOR(255, 158, 87, 1);
                            
                            [task resumeTaskWith:task.url and:task.title to:self];
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else if (![mgr isReachable]){
                        //没网提醒用户
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络似乎出了点错误，请检查网络..." preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
            });
        }
    }
}
//
-(void)deleteTask:(UIButton *)btn{
    
    DownloadTool *tool = [DownloadTool sharedInstance];
    
    if (tool.taskArr.count > 0) {
        
        //取消下载任务并从任务数组删除
        [tool cancelTask:btn.tag];
        [tool.taskArr removeObjectAtIndex:btn.tag];
        
        if (tool.taskArr.count > 0) {
            
            [_tableView2 deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        //延迟0.2秒刷新tableview
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            DownloadTool *tool = [DownloadTool sharedInstance];
            if (tool.taskArr.count > 0) {
                [_segmentCtl setTitle:[NSString stringWithFormat:@"下载中（%ld）",tool.taskArr.count] forSegmentAtIndex:1];
            }else{
                [_segmentCtl setTitle:@"下载中" forSegmentAtIndex:1];
            }
            
            [_tableView2 reloadData];
        });
    }
}
//
- (void)playVideo:(UIButton *)btn{
    
    VideoModel *model = _finishArr[btn.tag];
    
    NSString *path = model.path;
    
    CompleteCell *cell = [_tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];//本地的
        
        _player.view.frame = cell.imgView.frame;
        _player.view.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:_player.view];
        
        _player.movieSourceType = MPMovieSourceTypeFile;
        _player.controlStyle = MPMovieControlStyleFullscreen;
        _player.shouldAutoplay = YES;
        _player.fullscreen = YES;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        
        [_player play];
        
        //监听播放状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChange)name:MPMoviePlayerPlaybackStateDidChangeNotification object:_player];
        //监听播放完成
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedPlay:)name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
        //退出全屏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:)name:MPMoviePlayerDidExitFullscreenNotification object:_player];
    }else{
        
        HUDTEXT(@"播放失败！", self.view);
    }
}
//删除视频
-(void)deleteVideo:(UIButton *)btn{
    
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createViewWith:@"1"]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        
        if (buttonIndex == 1) {
            
            //解档取出原有的模型数组
            NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:VIDEO];
            VideoModel *model = arr[btn.tag];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:model.path]) {
                
                if ([[NSFileManager defaultManager] removeItemAtPath:model.path error:nil]) {
                    
                    NSLog(@"删除成功");
                }else {
                    
                    NSLog(@"删除失败");
                    return ;
                }
                
            }else {
                
                NSLog(@"文件不存在");
                return ;
            }
            
            [arr removeObject:model];
            
            [_finishArr removeObjectAtIndex:btn.tag];
            if (_finishArr.count > 0) {
                
                [_tableView1 deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            }
            
            //归档
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            if ([data writeToFile:VIDEO atomically:YES]){
                
                NSLog(@"写入成功");
            }else{
                
                NSLog(@"写入失败");
            }
            
            //延迟0.2秒刷新tableview
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_finishArr.count > 0) {
                    [_segmentCtl setTitle:[NSString stringWithFormat:@"已下载（%ld）",_finishArr.count] forSegmentAtIndex:0];
                }else{
                    [_segmentCtl setTitle:@"已下载" forSegmentAtIndex:0];
                }
                
                [_tableView1 reloadData];
            });
        }
        
        [alertView close];
    }];
    
    alertView.useMotionEffects = YES;
//    alertView.closeOnTouchUpOutside = YES;
    
    [alertView show];
}
//重命名（其实就是将文件移动到同文件夹下，然后删除之前的文件）
-(void)renameVideo:(UIButton *)btn{
    
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createViewWith:@"2"]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        
        if (buttonIndex == 1) {
            
            //解档取出原有的模型数组
            NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:VIDEO];
            VideoModel *model = arr[btn.tag];
            
            //Cache目录
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",_tf.text]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:model.path]) {
                
                if([[NSFileManager defaultManager] moveItemAtPath:model.path toPath:filePath error:nil]){
                    
                    NSLog(@"重命名成功");
                }else{
                    
                    NSLog(@"重命名失败");
                    return ;
                }
                
            }else {
                
                NSLog(@"文件不存在");
                return ;
            }
            
            //修改模型
            model.title = _tf.text;
            model.path = filePath;
            //替换模型
            [arr replaceObjectAtIndex:btn.tag withObject:model];
            [_finishArr replaceObjectAtIndex:btn.tag withObject:model];
            //归档
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            if ([data writeToFile:VIDEO atomically:YES]){
                
                NSLog(@"写入成功");
            }else{
                
                NSLog(@"写入失败");
            }
            
            //延迟0.2秒刷新tableview
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_tableView1 reloadData];
            });
        }
        
        [alertView close];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:_tf];
    }];
    
    alertView.useMotionEffects = YES;
//    alertView.closeOnTouchUpOutside = YES;
    
    [alertView show];
}
//
- (UIView *)createViewWith:(NSString *)type{
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 240, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    
    [demoView addSubview:titleLab];
    
    if ([type isEqualToString:@"1"]) {
        
        titleLab.text = @"温馨提示";

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 240, 80)];
        lab.numberOfLines = 2;
        lab.text = @"你确定要删除视频记录吗？该操作不可复原。";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16.0];
        
        [demoView addSubview:lab];
        
    }else{
    
        titleLab.text = @"为视频重命名";
        
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 75, 240, 40)];
        _tf.borderStyle = UITextBorderStyleRoundedRect;
        _tf.font = [UIFont systemFontOfSize:16.0];
        _tf.delegate = self;
        _tf.returnKeyType = UIReturnKeyDone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_tf];
        
        [demoView addSubview:_tf];
    }

    return demoView;
}
//分享
-(void)shareVideo:(UIButton *)btn{
    
    VideoModel *model = _finishArr[btn.tag];

    // 设置分享内容
    __unused NSString *text = model.title;
    __unused UIImage *image = [UIImage imageWithData:model.poster];
    NSURL *url = [NSURL fileURLWithPath:model.path];
    NSArray *activityItems = @[url];
    
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if (activityViewController) {
        [self presentViewController:activityViewController animated:TRUE completion:nil];
    }
}


#pragma mark - textfield
//
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [_tf resignFirstResponder];
    
    return YES;
}
//限定字符个数
-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    
    if (textField == _tf) {
        
        NSString *toBeString = textField.text;
        
        NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 50) {
                    textField.text = [toBeString substringToIndex:50];
                }
            }else{
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > 50) {
                textField.text = [toBeString substringToIndex:50];
            }
        }
    }
}


#pragma mark - 视频播放监听
//
- (void)stateChange {
    
    switch (self.player.playbackState) {
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            break;
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止");
            break;
        default:
            break;
    }
}
//
- (void)finishedPlay:(NSNotification *)notification {
    
    NSLog(@"播放完成");

    MPMoviePlayerController *player = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:player];

    // 播放结束移除视频对象（非arc记得release！！）
    [player.view removeFromSuperview];
}
//
- (void)exitFullScreen:(NSNotification *)notification {
    
    NSLog(@"退出全屏");
    
    MPMoviePlayerController *player = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:player];
    
    [player stop];
    // 播放结束移除视频对象（非arc记得release！！）
    [player.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
