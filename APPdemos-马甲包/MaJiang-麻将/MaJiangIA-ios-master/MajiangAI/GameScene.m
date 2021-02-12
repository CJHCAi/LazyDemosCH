//
//  GameScene.m
//  MajiangAI
//
//  Created by papaya on 16/4/28.
//  Copyright (c) 2016年 Li Haomiao. All rights reserved.
//

#import "GameScene.h"
#import "UnPutMJHeap.h"
#import "EachMjHeaps.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    NSLog(@"------- %lf %lf",SCREEN_WIDTH,SCREEN_HEIGHT);
    self.backgroundColor = [SKColor colorWithRed:12/255.0 green:73/255.0 blue:29/255.0 alpha:1];
    [self onCreatEveryting];
    
}

- (void)onCreatEveryting{
    [self onCreatTableCloth];
    UnPutMJHeap *mjHeap = [[UnPutMJHeap alloc] init];
    
    
    
    
    
}


- (void)onCreatTableCloth
{
    SKSpriteNode *centerCloths = [[SKSpriteNode alloc] initWithTexture:nil color:[UIColor redColor] size:CGSizeMake(SCREEN_HEIGHT*1/2, SCREEN_HEIGHT*1/2)];
    centerCloths.position = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    centerCloths.zPosition = 1;
    [self addChild:centerCloths];
    
    for( int i = 0; i < 4; ++i ){
        EachMjHeaps *mjHeaps = [[EachMjHeaps alloc] init];
        [mjHeaps settingWith:i length:SCREEN_HEIGHT/2/2 centerPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
        mjHeaps.zPosition = 2;
        [self addChild:mjHeaps];
        NSMutableArray *array = [NSMutableArray array];
        for ( int i =0; i < 17 * 2 - 1; ++i ){
            SingleMajiang *mj = [[SingleMajiang alloc] init];
            singleMajiangNode *mjNode = [[singleMajiangNode alloc] init];
            [mjNode settingWithMj:mj];
            [array addObject:mjNode];
        }
        [mjHeaps settingMjHeaps:array];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
  
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end


//CGFloat x = 10.0;
//CGFloat y = SCREEN_HEIGHT;
//NSLog(@"ww:  %lf %lf",self.frame.size.width,self.frame.size.height);
//SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithTexture:nil color:[UIColor redColor] size:CGSizeMake(SELF_WIDTH-100, SELF_HEIGHT-200)];
//mjNode.position = CGPointMake(SELF_WIDTH/2, SELF_HEIGHT/2);
//[self addChild:mjNode];
//for ( int i = 0; i < [mjHeap count]; ++i ){
//    SingleMajiang *mj = [mjHeap objectAtIndex:i];
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:[NSString stringWithFormat:@"%d",(int)mj.type]];
//    
//    [mjNode setSize:CGSizeMake(mjWidth, mjHeight)];
//    mjNode.position = CGPointMake(x+mjWidth/2, y-mjHeight/2);
//    [self addChild:mjNode];
//    x += mjWidth;
//    if ( x +mjWidth > self.frame.size.width ){
//        x = 10.0;
//        y -= mjHeight;
//    }
//}
//y -= 100;
//x = 100;
//
//CGFloat xxx = x;
//CGFloat yyy = y;
//for ( int i = 0; i < 17; ++i ){
//    SingleMajiang *mj = [mjHeap objectAtIndex:i];
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_v"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_v, mjBackHeight_v)];
//    mjNode.position = CGPointMake(x+mjBackWidth_v/2, y-mjBackHeight_v/2);
//    x += mjBackWidth_v;
//    [self addChild:mjNode];
//}
//
//y += 6.5;
//x = 100;
//for ( int i = 0; i < 17; ++i ){
//    SingleMajiang *mj = [mjHeap objectAtIndex:i];
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_v"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_v, mjBackHeight_v)];
//    mjNode.position = CGPointMake(x+mjBackWidth_v/2, y-mjBackHeight_v/2);
//    x += mjBackWidth_v;
//    [self addChild:mjNode];
//}
//
//
//x += 30;
//y += 170;
//CGFloat xx = x;
//CGFloat yy = y;
//for ( int i = 0; i < 17; ++i ){
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_h"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_h, mjBackHeight_h)];
//    mjNode.position = CGPointMake(x+mjBackWidth_h/2, y-mjBackHeight_h/2);
//    y = y - mjBackHeight_h + 4;
//    [self addChild:mjNode];
//    
//}
//
//x = xx;
//y = yy;
//y += 5;
//for ( int i = 0; i < 17; ++i ){
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_h"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_h, mjBackHeight_h)];
//    mjNode.position = CGPointMake(x+mjBackWidth_h/2, y-mjBackHeight_h/2);
//    mjNode.zPosition = 10;
//    y = y - mjBackHeight_h + 4;
//    [self addChild:mjNode];
//    
//}
//
//x = xxx;
//y = yyy;
//x -= 45;
//y += 175;
//xx = x;
//yy = y;
//
//for ( int i = 0; i < 17; ++i ){
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_h"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_h, mjBackHeight_h)];
//    mjNode.position = CGPointMake(x+mjBackWidth_h/2, y-mjBackHeight_h/2);
//    mjNode.zPosition = 10;
//    y = y - mjBackHeight_h + 4;
//    [self addChild:mjNode];
//    
//}
//
//x = xx;
//y = yy;
//y += 5;
//for ( int i = 0; i < 17; ++i ){
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_h"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_h, mjBackHeight_h)];
//    mjNode.position = CGPointMake(x+mjBackWidth_h/2, y-mjBackHeight_h/2);
//    mjNode.zPosition = 10;
//    y = y - mjBackHeight_h + 4;
//    [self addChild:mjNode];
//    
//}
//
//x = xx;
//y = yy;
//x += 45;
//
//for ( int i = 0; i < 17; ++i ){
//    SingleMajiang *mj = [mjHeap objectAtIndex:i];
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_v"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_v, mjBackHeight_v)];
//    mjNode.position = CGPointMake(x+mjBackWidth_v/2, y-mjBackHeight_v/2);
//    mjNode.zPosition = 100;
//    x += mjBackWidth_v;
//    [self addChild:mjNode];
//}
//
//y += 6.5;
//x = xx + 45;
//for ( int i = 0; i < 17; ++i ){
//    SingleMajiang *mj = [mjHeap objectAtIndex:i];
//    SKSpriteNode *mjNode = [[SKSpriteNode alloc] initWithImageNamed:@"mjBack_v"];
//    [mjNode setSize:CGSizeMake(mjBackWidth_v, mjBackHeight_v)];
//    mjNode.position = CGPointMake(x+mjBackWidth_v/2, y-mjBackHeight_v/2);
//    x += mjBackWidth_v;
//    mjNode.zPosition = 100;
//    [self addChild:mjNode];
//}