//
//  ViewController.m
//  Music
//
//  Created by tarena on 16/8/5.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "Utils.h"
#import "PlayingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VIMediaCache.h"
#import <MBProgressHUD.h>

@interface PlayingViewController ()<AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSDictionary *lrcDic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkIV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *playModeSC;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong) VIResourceLoaderManager *loaderManager;
@property (nonatomic, strong) MBProgressHUD *hud;

@end
static PlayingViewController *_playingVC;
@implementation PlayingViewController

+(PlayingViewController *)sharePlayingVC{
    
    if (!_playingVC) {
        _playingVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayingViewController"];
    }
    
    return _playingVC;
}
- (IBAction)sliderAction:(UISlider *)sender {
    
    if (sender.tag ==0) {
          self.player.currentTime = sender.value;
    }else{
        self.player.volume = sender.value;
    }
 
}
- (IBAction)clicked:(UIButton *)sender {
    NSString *musicPath = nil;
    switch (sender.tag) {
        case 0 :
            if (self.player.isPlaying) {
                [self.player pause];
                [sender setTitle:@"播放" forState:UIControlStateNormal];
            }else{
                [self.player play];
                [sender setTitle:@"暂停" forState:UIControlStateNormal];
                //停止会从内存中释放空间
                //        [self.player stop];
            }

            break;
            
        case 1://上一曲
            self.currentIndex--;
            if (self.currentIndex==-1) {
                self.currentIndex = self.musicPaths.count - 1;
            }
            
            if (self.currentIndex==self.musicPaths.count) {
                self.currentIndex = 0;
            }
//            [self.player pause];
            //下载到一半的界面再次进入的时候会重新有一个hud
            [self.hud hideAnimated:YES];
            if (self.playModeSC.selectedSegmentIndex==2) {
                self.currentIndex = arc4random()%self.musicPaths.count;
            }
//            [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
            //判断是不是自己的录音
            if ([self.musicPaths[self.currentIndex] containsString:@"caf"]) {
                musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.caf",self.titles[self.currentIndex]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
                    [self downloadMusic];
                }else{
                    [self playMusic];
                }
            }else{
                musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp3",self.titles[self.currentIndex]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
                    [self downloadMusic];
                }else{
                    [self playMusic];
                }
            }
            
            break;
        case 2:
            self.currentIndex++;

            if (self.currentIndex==-1) {
                self.currentIndex = self.musicPaths.count - 1;
            }
            
            if (self.currentIndex==self.musicPaths.count) {
                self.currentIndex = 0;
            }
//            [self.player pause];
            [self.hud hideAnimated:YES];
            if (self.playModeSC.selectedSegmentIndex==2) {
                self.currentIndex = arc4random()%self.musicPaths.count;
            }
//            [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
            //判断是不是自己的录音
            if ([self.musicPaths[self.currentIndex] containsString:@"caf"]) {
                musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.caf",self.titles[self.currentIndex]];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
                    [self downloadMusic];
                }else{
                    [self playMusic];
                }
            }else{
                musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp3",self.titles[self.currentIndex]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
                    [self downloadMusic];
                }else{
                    [self playMusic];
                }
            }
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.musicPaths[self.currentIndex]) {
        //判断是不是自己的录音
        if ([self.musicPaths[self.currentIndex] containsString:@"caf"]) {
            NSString *musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.caf",self.titles[self.currentIndex]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
                //切歌
                [self downloadMusic];
                [self.player pause];
                [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
            }else{
                [self playMusic];
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        }else{
            NSString *musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp3",self.titles[self.currentIndex]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
                //切歌
                [self downloadMusic];
                [self.player pause];
                [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
            }else{
                [self playMusic];
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        }
        
    }
}
- (void)downloadMusic{
    if (self.currentIndex==-1) {
        self.currentIndex = self.musicPaths.count - 1;
    }
    
    if (self.currentIndex==self.musicPaths.count) {
        self.currentIndex = 0;
    }
    //标题
    NSString *title = self.titles[self.currentIndex];
    if ([title containsString:@"huyifan"]) {
        [title stringByReplacingOccurrencesOfString:@"huyifan" withString:@""];
    }
    self.title = title;
    //背景图
    [self.artworkIV sd_setImageWithURL:[NSURL URLWithString:self.artworkImages[self.currentIndex]] placeholderImage:[UIImage imageNamed:@"cat"]];
    //歌曲
    NSString *path = self.musicPaths[self.currentIndex];
    
    self.loaderManager = [[VIResourceLoaderManager alloc]init];
    //创建播放项
    AVPlayerItem *item = [self.loaderManager playerItemWithURL:[NSURL URLWithString:path]];
    self.avPlayer = [AVPlayer playerWithPlayerItem:item];
    //    添加监听 试听
//    [self.avPlayer play];
    //想要判断是不是重复进入  其实每次进来都隐藏一下不就好了？每次也暂停掉
//    if (![self.avPlayer.currentItem isEqual:item]) {
        //下载到一半的界面再次进入的时候会重新有一个hud
    [self.hud hideAnimated:YES];
//    }
    //添加菊花转啊转
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.artworkIV animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = @"正在下载歌曲";
    self.hud = hud;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadAction:) name:VICacheManagerDidUpdateCacheNotification object:nil];

}
-(void)downloadAction:(NSNotification *)noti{
    
//    NSLog(@"%@",noti.userInfo);
    float total = [noti.userInfo[VICacheContentLengthKey] floatValue];
    NSArray *arr = noti.userInfo[VICacheFragmentsKey];
    if (arr.count>0) {
        float current = [arr[0] rangeValue].length;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.progress = current/total;
        });
        
        if (current==total) {//下载完了
            
            NSString *path = [VICacheManager cachedFilePathForURL:noti.userInfo[VICacheURLKey]];
            if ([path containsString:@"caf"]) {
                NSString *newPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.caf",self.titles[self.currentIndex]];
                [[NSFileManager defaultManager]moveItemAtPath:path toPath:newPath error:nil];
            }else{
                NSString *newPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp3",self.titles[self.currentIndex]];
                [[NSFileManager defaultManager]moveItemAtPath:path toPath:newPath error:nil];
            }
//            NSLog(@"下载%@歌曲完成",self.titles[self.currentIndex]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playMusic];
                [self.hud hideAnimated:YES];
            });
            
        }
        
    }
    
    
}


- (void)playMusic{
    
    if (self.currentIndex==-1) {
        self.currentIndex = self.musicPaths.count - 1;
    }
    
    if (self.currentIndex==self.musicPaths.count) {
        self.currentIndex = 0;
    }
    //标题
    NSString *title = self.titles[self.currentIndex];
    if ([title containsString:@"huyifan"]) {
        title = [title stringByReplacingOccurrencesOfString:@"huyifan" withString:@""];
    }
    self.title = title;
    //背景图
    [self.artworkIV sd_setImageWithURL:[NSURL URLWithString:self.artworkImages[self.currentIndex]] placeholderImage:[UIImage imageNamed:@"cat"]];
    NSString *path = nil;
    if ([self.titles[self.currentIndex] containsString:@"huyifan"]) {
        //判断当前播放的和即将播放的歌曲是否是同一首歌
        path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.caf",self.titles[self.currentIndex]];
    }else{
        //判断当前播放的和即将播放的歌曲是否是同一首歌
        path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp3",self.titles[self.currentIndex]];
    }

    if (![self.player.url.path isEqualToString:path]) {
        //strong的set方法中做了两件事 把原来的relase  把新的retain
        //    weak和assing set方法中直接赋值不涉及内存计数的改变
        //URL取不到不知道为什么   原来是方法用错了！！！！！！要用fileURLWithPath！！！！手机不要静音！！！！！
        
        //        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        //切歌后按钮的变化
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
        
    }

    self.player.delegate = self;
 
    //准备播放 把数据加载到内存中
    //    [self.player prepareToPlay];
    if ([self.playButton.currentTitle isEqualToString:@"暂停"]) {
        [self.player play];
    }

    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.player.duration/60,(int)self.player.duration%60];
    
    self.progressSlider.maximumValue = self.player.duration;
    
   
    
    
    //显示歌词
    NSString *lrcPath = [path stringByReplacingOccurrencesOfString:@"mp3" withString:@"lrc"];
    //判断文件是否存在
     if ([[NSFileManager defaultManager]fileExistsAtPath:lrcPath]) {
    
        self.lrcDic = [Utils parseLrcWithPath:lrcPath];
         [self.tableView reloadData];
         self.tableView.hidden = NO;
     }else{
         self.tableView.hidden = YES;
     }
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
}


- (void)dealloc
{
    NSLog(@"页面销毁了");
}

-(void)updateUI{
    self.progressSlider.value = self.player.currentTime;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.player.currentTime/60,(int)self.player.currentTime%60];
    
    
    
    //同步歌词
    
    NSArray *keys = [self.lrcDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (int i=1; i<keys.count; i++) {
        float time = [keys[i] floatValue];
        //找到当前正在播放的歌词行数
        if (time>self.player.currentTime) {
            
            int row = i-1;
            //让tableView 选中并且滚动到指定的某行
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            
            break;
        }
        
        
    }
    
    
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    
    switch (self.playModeSC.selectedSegmentIndex) {
        case 0://顺序播放
            self.currentIndex++;
            if (self.currentIndex==self.musicPaths.count) {
                self.currentIndex = 0;
            }

            break;
            
        case 1://单曲循环
            
            
            break;
        case 2://随机
            self.currentIndex = arc4random()%self.musicPaths.count;
            
            break;
    }
    //判断是不是自己的录音
    if ([self.musicPaths[self.currentIndex] containsString:@"caf"]) {
        NSString *musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.caf",self.titles[self.currentIndex]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
            [self downloadMusic];
        }else{
            [self playMusic];
        }
    }else{
        NSString *musicPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp3",self.titles[self.currentIndex]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
            [self downloadMusic];
        }else{
            [self playMusic];
        }
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.lrcDic.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //数组排序 因为字典无序 歌词有序
    NSArray *keys = [self.lrcDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    //得到每行对应的时间key
    NSNumber *timeKey = keys[indexPath.row];
    
    //通过key得到歌词内容
    cell.textLabel.text = self.lrcDic[timeKey];
    
 
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //设置cell选中样式
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    //设置高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}


@end
