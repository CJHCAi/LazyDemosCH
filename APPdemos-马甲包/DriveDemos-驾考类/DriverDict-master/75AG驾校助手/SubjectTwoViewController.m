//
//  SubjectTwoViewController.m
//  75AG驾校助手
//
//  Created by again on 16/4/29.
//  Copyright © 2016年 again. All rights reserved.
//

#import "SubjectTwoViewController.h"
#import "SubjectTwoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SubjectTwoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) MPMoviePlayerViewController *moviePlayer;
@end

@implementation SubjectTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

//- (AGMoviePlayerViewController *)moviePlayer
//{
//        self.moviePlayer = [[AGMoviePlayerViewController alloc] init];
//        self.moviePlayer.delegate = self;
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"shipin" ofType:@"mp4"];
////    self.movieUrl =[NSURL fileURLWithPath:path];
//self.moviePlayer = [AGMoviePlayerViewController alloc] initw
//self.moviePlayer.movieUrl = [NSURL fileURLWithPath:path];
//    return self.moviePlayer;
//}
- (void)moviePlayerDidFinished
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.moviePlayer = nil;
}

- (void)moviePlayerDidCapturedWithImage:(UIImage *)image;
{
    
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"SubjectTwoTableViewCell";
    SubjectTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
    }
    cell.titleImage.image = [UIImage imageNamed:@"subject.png"];
    cell.titleLabel.text = [NSString stringWithFormat:@"视频:%ld", indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shipin" ofType:@"mp4"];
    
    self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
//    self.moviePlayer.movieUrl =[NSURL fileURLWithPath:path];
    [self.navigationController showDetailViewController:self.moviePlayer sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)addNotification
//{
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self selector:@selector(playerDidFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//}
//
//- (void)playerDidFinished
//{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
@end
