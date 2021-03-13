#import "DDYVideoPlayController.h"
#import <MediaPlayer/MediaPlayer.h>

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

@interface DDYVideoPlayController ()

@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;

@end

@implementation DDYVideoPlayController

- (MPMoviePlayerController *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[MPMoviePlayerController alloc] init];
        [_videoPlayer.view setFrame:self.view.bounds];
        [_videoPlayer prepareToPlay];
        [_videoPlayer setControlStyle:MPMovieControlStyleNone];
        [_videoPlayer setShouldAutoplay:YES];
        [_videoPlayer setRepeatMode:MPMovieRepeatModeOne];
        [self.view insertSubview:_videoPlayer.view atIndex:0];
    }
    return _videoPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *takeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Back" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(12, 25, 60, 25)];
        button;
    });
    [self.view addSubview:takeButton];
}

- (void)dismissAction {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videoPlayer stop];
    self.videoPlayer = nil;
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    self.videoPlayer.contentURL = _videoURL;
    [self.videoPlayer play];
}

@end
