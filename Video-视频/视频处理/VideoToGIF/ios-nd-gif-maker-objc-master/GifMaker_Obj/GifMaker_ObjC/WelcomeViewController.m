//
//  WelcomeViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/19/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIViewController+Record.h"

@interface WelcomeViewController()

@property (nonatomic) NSURL *squareURL;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Gif *firstLaunchGif = [[Gif alloc] initWithName:@"tinaFeyHiFive"];
    self.defaultGifImageView.image = firstLaunchGif.gifImage;

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WelcomeViewSeen"];
}

@end
