//
//  ViewController.h
//  Music
//
//  Created by tarena on 16/8/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController
@property (nonatomic, strong)NSMutableArray *musicPaths;
@property (nonatomic)NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *artworkImages;
@property (nonatomic, strong) NSMutableArray *titles;

+ (PlayingViewController *)sharePlayingVC;
@end

