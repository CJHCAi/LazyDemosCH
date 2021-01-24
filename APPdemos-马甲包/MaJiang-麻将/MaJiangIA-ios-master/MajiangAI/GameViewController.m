//
//  GameViewController.m
//  MajiangAI
//
//  Created by papaya on 16/4/28.
//  Copyright (c) 2016年 Li Haomiao. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
    scene.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scene.scaleMode = SKSceneScaleModeAspectFill;
//    scene.backgroundColor = [SKColor colorWithRed:0 green:0.7 blue:0 alpha:1];
    // Present the scene.
    [skView presentScene:scene];
    
    
    UnPutMJHeap *mjHeap = [[UnPutMJHeap alloc] init];
    [mjHeap Shuffle];
    
    CGFloat x = 10.0;
    CGFloat y = 10.0;
    
    NSLog(@"------- %lf %lf",SCREEN_WIDTH,SCREEN_HEIGHT);
    for ( int i = 0; i < [mjHeap count]; ++i ){
        SingleMajiang *mj = [mjHeap objectAtIndex:i];
        if ( x + mjWidth > SCREEN_WIDTH ){
            x = 10.0;
            y = y + mjHeight + jiange;
        }else{
            x += mjWidth;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, mjWidth, mjHeight)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",(int)mj.type]]];
        [self.view addSubview:imageView];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
