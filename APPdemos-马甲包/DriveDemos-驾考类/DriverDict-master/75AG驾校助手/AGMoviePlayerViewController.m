//
//  AGMoviePlayerViewController.m
//  75AG驾校助手
//
//  Created by again on 16/5/12.
//  Copyright © 2016年 again. All rights reserved.
//

#import "AGMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AGMoviePlayerViewController ()
@property (strong,nonatomic) MPMoviePlayerViewController *moviePlayer;
@end

@implementation AGMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
}

- (void)captureImageAtTime:(float)time
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MPMoviePlayerViewController *)moviePlayer
{
    if (self.moviePlayer == nil) {
        self.moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:self.movieUrl];
//        self.moviePlayer.view.frame = self.view.bounds;
        self.moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.moviePlayer.view];
    }
    return self.moviePlayer;
}

#pragma mark - 添加通知
- (void)addNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(finished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    [nc addObserver:self selector:@selector(<#selector#>) name:<#(nullable NSString *)#> object:<#(nullable id)#>]
}

- (void)finished{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.delegate moviePlayerDidFinished];
}



@end
