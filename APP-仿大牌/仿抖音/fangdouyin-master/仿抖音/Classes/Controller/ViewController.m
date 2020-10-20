//
//  ViewController.m
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"
#import "MusicModel.h"
#import "MusicCell.h"
#import "CommentActionSheet.h"
#import "MainViewNavigitionView.h"
@interface ViewController ()<CardViewDataSource, CardViewDelegate,MusicCellDeletegate>
@property(nonatomic,strong)CardView *cardView;
@property(nonatomic,strong)NSArray<MusicModel*> *colors;
@property(nonatomic,strong)MusicCell * currentMusicCell;
@property(nonatomic,strong)CommentActionSheet * commentActionView;
@property (nonatomic, strong)MainViewNavigitionView *mainViewNavigitionView;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self cardView];
    [self setupCommentView];
    [self loadData];
    
    __weak typeof(self) weakSelf = self;
    [self addJXRefreshWithTableView:self.view andNavView:self.mainViewNavigitionView andRefreshBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf endRefresh];
        });
    }];

}

-(MainViewNavigitionView *)mainViewNavigitionView
{
    if (!_mainViewNavigitionView) {
        _mainViewNavigitionView = [[MainViewNavigitionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kNavHeight)];
        _mainViewNavigitionView.backgroundColor = [UIColor clearColor];
    }
    return _mainViewNavigitionView;
}

-(void)setupCommentView{
    self.commentActionView = [[CommentActionSheet alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.commentActionView];
    [self.view bringSubviewToFront:self.commentActionView];

}
#pragma mark - CardViewDataSource
-(NSInteger)numberOfSectionsInCardView:(CardView *)cardView
{
    return self.colors.count;
}

-(CardModel *)cardView:(CardView *)cardView cellForRowAtIndexPath:(NSInteger)row
{
    MusicModel *model = self.colors[row];
    return model;
}

#pragma mark - CardViewDelegate
-(void)cardView:(CardView *)cardView willBeginScrollIndex:(NSInteger)index cell:(CardCell *)view
{
//    NSLog(@"begin %ld", (long)index);
    MusicCell *musicCell = (MusicCell*)view;
    self.currentMusicCell=musicCell;
     musicCell.deledate=nil;
    [musicCell.musicImageView.layer removeAllAnimations];
    [musicCell pause];
}

-(void)cardView:(CardView *)cardView didEndscrollIndex:(NSInteger)index cell:(CardCell *)view
{
//    NSLog(@"end %ld", (long)index);
    MusicCell *musicCell = (MusicCell*)view;
    self.currentMusicCell=musicCell;
    musicCell.deledate=self;
    [musicCell play];
}

#pragma mark - 📗event response
-(void)loadData
{
//    NSString *url = @"https://aweme.snssdk.com/aweme/v1/feed/?iid=28125894380&device_id=13386673439&os_api=18&app_name=aweme&channel=App%20Store&idfa=CD356173-552B-4548-AAD6-90AFC176DD33&device_platform=iphone&build_number=17603&vid=86F78464-B7F2-4BF3-A810-73DE6FAC4ED8&openudid=1d96a912ab49e6f4b349db43a8a895f39d3f175f&device_type=iPhone7,1&app_version=1.7.6&version_code=1.7.6&os_version=11.2.5&screen_width=1242&aid=1128&ac=WIFI&count=6&feed_style=0&min_cursor=0&pull_type=1&type=0&user_id=56708491821&volume=0.19&mas=00a84f6c764f693812ab7fd7ec9a888eb34472a1e6b3181f445eb1&as=a1c5badbd88e9a5df07009&ts=1521528296";
//    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *array = [MusicModel mj_objectArrayWithKeyValuesArray:responseObject[@"aweme_list"]];
//        self.colors = array;
//        [self.cardView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error");
//    }];
    self.colors = [MusicModel models];
    [self.cardView reloadData];
}

#pragma mark - 📙getter and setter
-(CardView *)cardView
{
    if (!_cardView) {
        _cardView = [[CardView alloc] initWithCellCls:MusicCell.class];
        _cardView.dataSource = self;
        _cardView.delegate = self;
        [self.view addSubview:_cardView];
        [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _cardView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.currentMusicCell.musicImageView.layer removeAllAnimations];
    [self.currentMusicCell pause];
    [self.currentMusicCell removeFromSuperview];
    [self.cardView removeFromSuperview];

}

#pragma mark-MusicCellDeletegate
-(void)MusicCellGoBack:(MusicCell *)musicCell{
    [self.currentMusicCell.musicImageView.layer removeAllAnimations];
    [self.currentMusicCell pause];
    [self.cardView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)MusicCellCommentBtnClicked{
    [self.commentActionView show];
}
@end
