//
//  HomeViewController.m
//  DYVideoListPlay
//
//  Created by 七啸网络 on 2018/3/27.
//  Copyright © 2018年 huyangyang. All rights reserved.
//

#import "HomeViewController.h"
#import "MainViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden=YES;
    UIButton * pushButton=[UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame=CGRectMake(50, 100, 100,50);
    [pushButton setTitle:@"push" forState:UIControlStateNormal];
    [pushButton setBackgroundColor:[UIColor redColor]];
    [pushButton addTarget:self action:@selector(pushToDouyinView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];

}
-(void)pushToDouyinView{
    
    MainViewController *mainCor = [[MainViewController alloc]init];
    
    NSMutableArray* mutableAry = [NSMutableArray array];
    NSArray* videoAry = [NSArray arrayWithObjects:
                         @"http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.mp4",
                         @"http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.mp4",
                         @"http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.mp4",
                         @"http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.mp4",
                         @"http://ksy.fffffive.com/mda-hihvysind8etz7ga/mda-hihvysind8etz7ga.mp4",
                         @"http://ksy.fffffive.com/mda-hiw60i3kczgum0av/mda-hiw60i3kczgum0av.mp4",
                         @"http://ksy.fffffive.com/mda-hidnzn5r61qwhxp4/mda-hidnzn5r61qwhxp4.mp4",
                         @"http://ksy.fffffive.com/mda-he1zy3rky0rwrf60/mda-he1zy3rky0rwrf60.mp4",
                         @"http://ksy.fffffive.com/mda-hh6cxd0dqjqcszcj/mda-hh6cxd0dqjqcszcj.mp4",
                         @"http://ksy.fffffive.com/mda-hifsrhtqjn8jxeha/mda-hifsrhtqjn8jxeha.mp4",
                         @"http://ksy.fffffive.com/mda-hics799vjrg0w5az/mda-hics799vjrg0w5az.mp4",
                         @"http://ksy.fffffive.com/mda-hfshah045smezhtf/mda-hfshah045smezhtf.mp4",
                         @"http://ksy.fffffive.com/mda-hh4mbturm902j7wi/mda-hh4mbturm902j7wi.mp4",
                         @"http://ksy.fffffive.com/mda-hiwxzficjivwmsch/mda-hiwxzficjivwmsch.mp4",
                         @"http://ksy.fffffive.com/mda-hhug2p7hfbhnv40r/mda-hhug2p7hfbhnv40r.mp4",
                         @"http://ksy.fffffive.com/mda-hieuuaei6cufye2c/mda-hieuuaei6cufye2c.mp4",
                         @"http://ksy.fffffive.com/mda-hibhufepe5m1tfw1/mda-hibhufepe5m1tfw1.mp4",
                         @"http://ksy.fffffive.com/mda-hhzeh4c05ivmtiv7/mda-hhzeh4c05ivmtiv7.mp4",
                         @"http://ksy.fffffive.com/mda-hfrigfn2y9jvzm72/mda-hfrigfn2y9jvzm72.mp4",
                         @"http://ksy.fffffive.com/mda-himek207gvvqg3wq/mda-himek207gvvqg3wq.mp4",
                         nil];
    
    
    NSArray* imageAry = [NSArray arrayWithObjects:
                         @"http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.jpg",
                         @"http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.jpg",
                         @"http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.jpg",
                         @"http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.jpg",
                         @"http://ksy.fffffive.com/mda-hihvysind8etz7ga/mda-hihvysind8etz7ga.jpg",
                         @"http://ksy.fffffive.com/mda-hiw60i3kczgum0av/mda-hiw60i3kczgum0av.jpg",
                         @"http://ksy.fffffive.com/mda-hidnzn5r61qwhxp4/mda-hidnzn5r61qwhxp4.jpg",
                         @"http://ksy.fffffive.com/mda-he1zy3rky0rwrf60/mda-he1zy3rky0rwrf60.jpg",
                         @"http://ksy.fffffive.com/mda-hh6cxd0dqjqcszcj/mda-hh6cxd0dqjqcszcj.jpg",
                         @"http://ksy.fffffive.com/mda-hifsrhtqjn8jxeha/mda-hifsrhtqjn8jxeha.jpg",
                         @"http://ksy.fffffive.com/mda-hics799vjrg0w5az/mda-hics799vjrg0w5az.jpg",
                         @"http://ksy.fffffive.com/mda-hfshah045smezhtf/mda-hfshah045smezhtf.jpg",
                         @"http://ksy.fffffive.com/mda-hh4mbturm902j7wi/mda-hh4mbturm902j7wi.jpg",
                         @"http://ksy.fffffive.com/mda-hiwxzficjivwmsch/mda-hiwxzficjivwmsch.jpg",
                         @"http://ksy.fffffive.com/mda-hhug2p7hfbhnv40r/mda-hhug2p7hfbhnv40r.jpg",
                         @"http://ksy.fffffive.com/mda-hieuuaei6cufye2c/mda-hieuuaei6cufye2c.jpg",
                         @"http://ksy.fffffive.com/mda-hibhufepe5m1tfw1/mda-hibhufepe5m1tfw1.jpg",
                         @"http://ksy.fffffive.com/mda-hhzeh4c05ivmtiv7/mda-hhzeh4c05ivmtiv7.jpg",
                         @"http://ksy.fffffive.com/mda-hfrigfn2y9jvzm72/mda-hfrigfn2y9jvzm72.jpg",
                         @"http://ksy.fffffive.com/mda-himek207gvvqg3wq/mda-himek207gvvqg3wq.jpg",
                         nil];
    for (int i = 0; i < 20 ; i ++) {
        VideoInfoModel * item = [[VideoInfoModel alloc] init];
        //    item = live;
        item.VideoAddress = videoAry[i];
        item.coverImageAddress = imageAry[i];
        [mutableAry addObject:item];
        
    }
    
    mainCor.dataList = mutableAry;
    mainCor.live = mutableAry[0];
    mainCor.index = 0;

    [self.navigationController pushViewController:mainCor animated:YES];
}


@end
