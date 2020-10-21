//
//  ViewControllerLightWeightPlayer.m
//  SJVideoPlayer
//
//  Created by 畅三江 on 2018/9/30.
//  Copyright © 2018 畅三江. All rights reserved.
//

#import "ViewControllerLightWeightPlayer.h"
#import "SJVideoPlayer.h"
#import <SJRouter/SJRouter.h>
#import <Masonry/Masonry.h>
@interface ViewControllerLightWeightPlayer ()<SJRouteHandler>
@property (nonatomic, strong) SJVideoPlayer *player;
@end

@implementation ViewControllerLightWeightPlayer

+ (NSString *)routePath {
    return @"player/lightweightPlayer";
}

+ (void)handleRequestWithParameters:(SJParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
    [topViewController.navigationController pushViewController:[self new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _player = [SJVideoPlayer lightweightPlayer];
    
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        else make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_player.view.mas_width).multipliedBy(9 / 16.0f);
    }];
    
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSBundle.mainBundle URLForResource:@"play" withExtension:@"mp4"]];
    _player.URLAsset.title = @"Test Title";
    _player.URLAsset.alwaysShowTitle = YES;
    _player.hideBackButtonWhenOrientationIsPortrait = YES;
    _player.enableFilmEditing = YES;
    
   
    
#pragma mark
    UILabel *noteLabel = [UILabel new];
    noteLabel.numberOfLines = 0;
    noteLabel.text = @"This is a simple demo, please use other demos to understand how to use.\n此为简单Demo, 请通过其他Demo来了解如何使用.";
    noteLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(8);
        make.trailing.offset(-8);
        make.centerY.offset(0);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end
