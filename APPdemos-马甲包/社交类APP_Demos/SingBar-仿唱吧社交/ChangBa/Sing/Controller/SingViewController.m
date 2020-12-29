//
//  SingViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/20.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "SingViewController.h"
#import "SingHeaderView.h"
#import "Utils.h"
#import "SongsModel.h"
#import "SingTableViewCell.h"
#import "SecondSingTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SingSectionHeaderView.h"
#import "ThirdTableViewCell.h"
#import "RecordVoiceViewController.h"
#import <MBProgressHUD.h>
#import "HopeViewController.h"

@interface SingViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *dgtButton;
@property (nonatomic, strong) UIButton *ydgqButton;
@property (nonatomic, strong) UIButton *bdlyButton;
@property (nonatomic, strong) UIView *redLine;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UITableView *singTV;
//跳转页面时传值
@property (nonatomic, strong) NSMutableArray *musicPaths;
@property (nonatomic, strong) NSMutableArray *artworkImages;
@property (nonatomic, strong) NSMutableArray *musicTitles;

@property (nonatomic, strong) NSMutableArray *myRecordArray;
@property (nonatomic, strong) NSMutableArray *myRecordTitlesArray;
@property (nonatomic, strong) UITableView *recordTV;

@property (nonatomic, strong) UITableView *bmobRecordTV;
@property (nonatomic, strong) NSMutableArray *bmobRecordArray;
@property (nonatomic, strong) NSMutableArray *bmobRecordTitlesArray;

@end

@implementation SingViewController
#pragma mark - 生命周期 Life Cilcle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMySegment];
    //下方的视图ScrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavigationBarH + 40, kScreenW, kScreenH - kNavigationBarH - 40 - kTabBarH)];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(kScreenW * 3, kScreenH - kNavigationBarH - 40 - kTabBarH);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    //scrollView中的View
    CGSize size = self.scrollView.frame.size;
    //点歌台
    UITableView *singTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    singTV.tag = 1;
    singTV.delegate = self;
    singTV.dataSource = self;
    singTV.tableHeaderView = [SingHeaderView instanceSingHeaderView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [singTV.tableHeaderView addGestureRecognizer:tapGR];
    [self.scrollView addSubview:singTV];
    self.singTV = singTV;
    //注册cell
    [singTV registerNib:[UINib nibWithNibName:@"SingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SingTableViewCell"];
    
    //本地歌曲
    UITableView *recordTV = [[UITableView alloc]initWithFrame:CGRectMake(size.width * 2, 0, size.width, size.height)];
    recordTV.tag = 2;
    recordTV.delegate = self;
    recordTV.dataSource = self;
    self.recordTV = recordTV;
    [self.scrollView addSubview:recordTV];
    //注册cell
    [recordTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //本地歌曲路径
    self.myRecordArray = [NSMutableArray array];
    self.myRecordTitlesArray = [NSMutableArray array];
    NSString *mp3Name = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    [self findFileWithDirectoryPath:mp3Name];
    
    //云端歌曲
    UITableView *bmobRecordTV = [[UITableView alloc]initWithFrame:CGRectMake(size.width, 0, size.width, size.height)];
    bmobRecordTV.tag = 3;
    bmobRecordTV.delegate = self;
    bmobRecordTV.dataSource = self;
    self.bmobRecordTV = bmobRecordTV;
    [self.scrollView addSubview:bmobRecordTV];
    //注册cell
    [bmobRecordTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //解析数据
    [Utils requestSongsWithCallback:^(id obj) {
        self.songs = obj;
        [self.singTV reloadData];
        //跳转页面时传值
        //数组初始化
        self.musicPaths = [NSMutableArray array];
        self.artworkImages = [NSMutableArray array];
        self.musicTitles = [NSMutableArray array];
        for (SongsModel *song in self.songs) {
            [self.artworkImages addObject:song.icon];
            [self.musicTitles addObject:song.name];
            [self.musicPaths addObject:song.music];
        }
    }];
    [Utils requestTitlesWithCallback:^(id obj) {
        self.titles = obj;
        [self.singTV reloadData];
    }];
    [singTV registerNib:[UINib nibWithNibName:@"SecondSingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SecondSingTableViewCell"];

    [singTV registerNib:[UINib nibWithNibName:@"ThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"ThirdTableViewCell"];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.myRecordArray = [NSMutableArray array];
    self.myRecordTitlesArray = [NSMutableArray array];
    NSString *mp3Name = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    [self findFileWithDirectoryPath:mp3Name];
    [self.recordTV reloadData];

    self.bmobRecordArray = [NSMutableArray array];
    self.bmobRecordTitlesArray = [NSMutableArray array];
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Record"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *object in array) {
            //得到playerName和cheatMode
            NSString *myRecordPath = [object objectForKey:@"myRecordPath"];
            NSString *myRecordTitle = [object objectForKey:@"myRecordTitle"];
            [self.bmobRecordArray addObject:myRecordPath];
            [self.bmobRecordTitlesArray addObject:myRecordTitle];
        }
        [self.bmobRecordTV reloadData];
    }];
}
#pragma mark - 方法 Methods
- (void)findFileWithDirectoryPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    获得文件夹下面所有的文件名称
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *fileName in fileNames) {
        //        得到文件的完整路径
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        //        判断文件名是否等于要搜索的内容
        //        模糊查找
        if ([fileName containsString:@"huyifan"]) {
            [self.myRecordArray addObject:filePath];
            
            NSString *songName = fileName;
            NSString *huyifanMp3Name = songName.lastPathComponent;

            NSString *huyifanName = [huyifanMp3Name stringByReplacingOccurrencesOfString:@".caf" withString:@""];
//            NSString *name = [huyifanName stringByReplacingOccurrencesOfString:@"huyifan" withString:@""];
            [self.myRecordTitlesArray addObject:huyifanName];
        }
        //        如果发现有文件夹
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir]&&isDir) {
            //            如果是文件夹路径 则继续查找这个文件夹里面的内容
            [self findFileWithDirectoryPath:filePath];
        }
    }
}

//设置navigationBar
- (void)initNavigationBar{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(recordVoice) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setImage:[UIImage imageNamed:@"mini_paly_btn_normal"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"mini_play_btn_press"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(gotoPlayingViewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    
    //    searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = searchBar;
}
//跳转到录音界面
- (void)recordVoice{
    RecordVoiceViewController *recordVC = [[RecordVoiceViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
//跳转到播放界面
- (void)gotoPlayingViewAction{
    PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
    [self.navigationController pushViewController:playingVC animated:YES];
}
//设置自定义导航栏
- (void)initMySegment{
    UIButton *dgtButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [dgtButton setTitle:@"点歌台" forState:UIControlStateNormal];
    [dgtButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    dgtButton.frame = CGRectMake(0, 0, kScreenW / 3, 40);
    dgtButton.center = CGPointMake(kScreenW / 6, kNavigationBarH + 20);
    [dgtButton addTarget:self action:@selector(dgtAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dgtButton];
    self.dgtButton = dgtButton;
    
    UIButton *ydgqButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [ydgqButton setTitle:@"云端歌曲" forState:UIControlStateNormal];
    [ydgqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ydgqButton.frame = CGRectMake(0, 0, kScreenW / 3, 40);
    ydgqButton.center = CGPointMake(kScreenW / 2, kNavigationBarH + 20);
    [ydgqButton addTarget:self action:@selector(ydgqAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ydgqButton];
    self.ydgqButton = ydgqButton;
    
    UIButton *bdlyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [bdlyButton setTitle:@"本地录音" forState:UIControlStateNormal];
    [bdlyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bdlyButton.frame = CGRectMake(0, 0, kScreenW / 3, 40);
    bdlyButton.center = CGPointMake(kScreenW / 6 * 5, kNavigationBarH + 20);
    [bdlyButton addTarget:self action:@selector(bdlyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bdlyButton];
    self.bdlyButton = bdlyButton;
    //导航栏下面的线
    self.redLine = [[UIView alloc]initWithFrame:CGRectMake(self.dgtButton.center.x - 30, kNavigationBarH + 38, 60, 1)];
    self.redLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redLine];
}
//按钮的点击事件
- (void)dgtAction:(UIButton*)sender{
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.ydgqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bdlyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:.4 animations:^{
        self.redLine.frame = CGRectMake(sender.center.x - 30, kNavigationBarH + 38, 60, 1);
    }];
    [UIView animateWithDuration:.4 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
- (void)ydgqAction:(UIButton*)sender{
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.dgtButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bdlyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:.4 animations:^{
        self.redLine.frame = CGRectMake(sender.center.x - 30, kNavigationBarH + 38, 60, 1);
    }];
    [UIView animateWithDuration:.4 animations:^{
        self.scrollView.contentOffset = CGPointMake(kScreenW, 0);
    }];
}
- (void)bdlyAction:(UIButton*)sender{
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.dgtButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.ydgqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:.4 animations:^{
        self.redLine.frame = CGRectMake(sender.center.x - 30, kNavigationBarH + 38, 60, 1);
    }];
    [UIView animateWithDuration:.4 animations:^{
        self.scrollView.contentOffset = CGPointMake(kScreenW * 2, 0);
    }];
}
#pragma mark UIScrollView Delegate
//滚动联动自定义导航栏
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / kScreenW;
    switch (page) {
        case 0:
            [self dgtAction:self.dgtButton];
            break;
        case 1:
            [self ydgqAction:self.ydgqButton];
            break;
        case 2:
            [self bdlyAction:self.bdlyButton];
            break;
        
        default:
            break;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.navigationItem.titleView resignFirstResponder];
}
#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (tableView.tag) {
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:
            if (section == 0) {
                return self.songs.count;
            }
            break;
        case 2:
            return self.myRecordArray.count;
            break;
        case 3:
            return self.bmobRecordArray.count;
            break;
        default:
            break;
    }
   
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1:{
            if (indexPath.section == 1) {
                SecondSingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondSingTableViewCell" forIndexPath:indexPath];
                return cell;
            }
            if (indexPath.section == 2) {
                ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdTableViewCell" forIndexPath:indexPath];
                return cell;
            }
            SingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingTableViewCell" forIndexPath:indexPath];
            SongsModel *song = self.songs[indexPath.row];
            NSURL *iconUrl = [NSURL URLWithString:song.icon];
            [cell.iconImageView sd_setImageWithURL:iconUrl];
            cell.nameLabel.text = song.name;
            cell.sizeAndArtistLabel.text = [NSString stringWithFormat:@"%@M-%@",song.size,song.artist];
            return cell;
            break;
        }
        case 2:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NSString *songName = self.myRecordArray[indexPath.row];
            NSString *huyifanMp3Name = songName.lastPathComponent;
            NSString *mp3Name = [huyifanMp3Name stringByReplacingOccurrencesOfString:@"huyifan" withString:@""];
            NSString *name = [mp3Name stringByReplacingOccurrencesOfString:@".caf" withString:@""];
            cell.textLabel.text = name;
            
            [cell.textLabel setFont:[UIFont fontWithName:@"HannotateSC-W5" size:12]];
            [cell.imageView setImage:[UIImage imageNamed:@"cat"]];
            return cell;
            break;
        }
        case 3:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            NSString *songName = self.bmobRecordTitlesArray[indexPath.row];
            NSString *mp3Name = [songName stringByReplacingOccurrencesOfString:@"huyifan" withString:@""];
            cell.textLabel.text = mp3Name;
            [cell.textLabel setFont:[UIFont fontWithName:@"HannotateSC-W5" size:12]];
            [cell.imageView setImage:[UIImage imageNamed:@"cat"]];
            return cell;
        }
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1:
            if (indexPath.section == 0) {
                PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
                playingVC.musicPaths = self.musicPaths;
                playingVC.artworkImages = self.artworkImages;
                playingVC.titles = self.musicTitles;
                playingVC.currentIndex = indexPath.row;
                [self.navigationController pushViewController:playingVC animated:YES];
            }
            break;
        case 2:{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传至云端或试听" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //确定时做的事
                BmobObject *Record = [BmobObject objectWithClassName:@"Record"];
                NSData *myRecordData = [NSData dataWithContentsOfFile:self.myRecordArray[indexPath.row]];
                //上传音频 得到音频地址
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.recordTV animated:YES];
                [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
                hud.label.text = @"开始上传";
                
                [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"abc.caf",@"data":myRecordData}] progressBlock:^(int index, float progress) {
                    hud.progress = progress;
                    hud.label.text = @(progress).stringValue;
                    NSLog(@"进度：%d-%f",index,progress);
                } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //得到上传完成的音频地址
                        BmobFile *file = [array firstObject];
                        NSString *myRecordPath = file.url;
                        //把音频地址保存
                        [Record setObject:myRecordPath forKey:@"myRecordPath"];
                        [Record setObject:self.myRecordTitlesArray[indexPath.row] forKey:@"myRecordTitle"];
                        [Record saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                [hud hideAnimated:YES];
                                //                                [self dismissViewControllerAnimated:YES completion:nil];
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                    //已上传
                                    [self.bmobRecordTV reloadData];
                                }];
                                [alert addAction:confirm];
                                [self presentViewController:alert animated:YES completion:nil];
                            }else{
                                NSLog(@"%@",error);
                            }
                        }];
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }];
            
            
            UIAlertAction *listen = [UIAlertAction actionWithTitle:@"试听" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //确定时做的事
                PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
                playingVC.musicPaths = self.myRecordArray;
                playingVC.titles = self.myRecordTitlesArray;
                playingVC.currentIndex = indexPath.row;
                [self.navigationController pushViewController:playingVC animated:YES];
            }];
            [alert addAction:confirm];
            [alert addAction:listen];
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case 3:{
            //下载到本地
//            PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
//            playingVC.musicPaths = self.bmobRecordArray;
//            playingVC.titles = self.bmobRecordTitlesArray;
//            playingVC.currentIndex = indexPath.row;
//            [self.navigationController pushViewController:playingVC animated:YES];
            //下载文件
            NSString *path = self.bmobRecordArray[indexPath.row];
            NSURL *url = [NSURL URLWithString:path];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSURL *newLocation = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/huyifan%@.caf",self.bmobRecordTitlesArray[indexPath.row]]]];
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm moveItemAtURL:location toURL:newLocation error:nil];
                
            }];
            [task resume];
        }
        default:
            break;
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1:
            if (indexPath.section == 1) {
                return 245;
            }
            if (indexPath.section == 2) {
                return 325;
            }
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    return 60;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:{
            SingSectionHeaderView *headerView = [SingSectionHeaderView instanceSingSectionHeaderView];
            headerView.titleLabel.text = self.titles[section];
            return headerView;
            break;
        }
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:
            return 20;
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    return 0;
}
#pragma mark - 手势方法 Methods

- (void)tap:(UITapGestureRecognizer *)sender{
    HopeViewController *hopeVC = [[HopeViewController alloc]init];
    [self.navigationController pushViewController:hopeVC animated:YES];
}

@end
