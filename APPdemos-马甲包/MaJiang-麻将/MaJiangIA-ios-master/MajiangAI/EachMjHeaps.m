//
//  EachMjHeaps.m
//  MajiangAI
//
//  Created by papaya on 16/4/29.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "EachMjHeaps.h"

@interface EachMjHeaps()

@property (nonatomic) EachMjHeapsType type;

@property (nonatomic) CGFloat positionX;
@property (nonatomic) CGFloat positionY;

@property (nonatomic) NSMutableArray *mjHeaps;

@end

@implementation EachMjHeaps

- (void)settingWith:(EachMjHeapsType)type length:(CGFloat)length centerPoint:(CGPoint)point
{
    _type = type;
    [self setSelfSize];
    [self setColor:[UIColor whiteColor]];
    [self setPositions:length centerPoint:point];
}

- (void)settingMjHeaps:(NSMutableArray *)mjHeaps
{
    _mjHeaps = mjHeaps;
    [self putMj];
}

- (void)setSelfSize
{
    switch (_type) {
        case Down:
            [self setSize:CGSizeMake(SelfHeight, SelfWidth)];
            break;
        case Right:
            [self setSize:CGSizeMake(SelfWidth, SelfHeight)];
            break;
        case Up:
            [self setSize:CGSizeMake(SelfHeight, SelfWidth)];
            break;
        case Left:
            [self setSize:CGSizeMake(SelfWidth, SelfHeight)];
            break;
        default:
            break;
    }
}

- (void)setPositions:(CGFloat)length centerPoint:(CGPoint)point{
    switch (_type) {
        case Down:
            _positionX = 0;
            _positionY = -SelfWidth/2 - length;
            break;
        case Right:
            _positionX = SelfWidth/2 + length;
            _positionY = 0;
            break;
        case Up:
            _positionX = 0;
            _positionY = SelfWidth/2 + length;
            break;
        case Left:
            _positionX = -SelfWidth/2 - length;
            _positionY = 0;
            break;
        default:
            break;
    }
    _positionX += point.x;
    _positionY += point.y;
    [self setPosition:CGPointMake(_positionX, _positionY)];
}

- (void)putMj
{
    
    switch (_type) {
        case Down:
            [self putDownMjStatus:PileUpAndDown];
            break;
        case Right:
            [self putRightMjStatus:PileLeftAndRight];
            break;
        case Up:
            [self putUpMjStatus:PileUpAndDown];
            break;
        case Left:
            [self putLeftMjStatus:PileLeftAndRight];
            break;
        default:
            break;
    }

}

- (void)putRightMjStatus:(MajiangStatus)status
{
    CGFloat positionX = 0;
    CGFloat positionY =  -self.size.height/2+15;
    CGFloat varV = 3.6;  //叠加
    CGFloat varH = mjBackHeight_h - varV *2;  //平移
    
    for ( int i = 0; i < _mjHeaps.count; ++i ){
        singleMajiangNode *mjNode = [_mjHeaps objectAtIndex:i];
        [mjNode settingStatus:status];
            mjNode.position = CGPointMake(positionX, positionY);
        
        NSInteger leve = _mjHeaps.count-i;
        if ( i % 2 == 0 ){
            leve -= 1;
            positionY += varV;
        }else{
            leve += 1;
            positionY = positionY + varH;
        }
        
        mjNode.zPosition =  leve;
        [self addChild:mjNode];
    }
}

- (void)putDownMjStatus:(MajiangStatus)status
{
    CGFloat positionX =  -self.size.width/2 + 15;
    CGFloat positionY =  0;
    CGFloat varV = 5.5;  //叠加
    CGFloat varH = mjBackWidth_v ;  //平移
    
    for ( int i = 0; i < _mjHeaps.count; ++i ){
        singleMajiangNode *mjNode = [_mjHeaps objectAtIndex:i];
        [mjNode settingStatus:status];
        mjNode.position = CGPointMake(positionX, positionY);
        if ( i % 2 == 1 ){
            positionX += varH;
        }
        positionY += varV;
        varV = -varV;
        mjNode.zPosition = i;
        [self addChild:mjNode];
    }
}

- (void)putUpMjStatus:(MajiangStatus)status
{
    CGFloat positionX =  self.size.width/2 - 15;
    CGFloat positionY =  0;
    CGFloat varV = 5.5;  //叠加
    CGFloat varH = mjBackWidth_v ;  //平移
    
    for ( int i = 0; i < _mjHeaps.count; ++i ){
        singleMajiangNode *mjNode = [_mjHeaps objectAtIndex:i];
        [mjNode settingStatus:status];
        mjNode.position = CGPointMake(positionX, positionY);
        if ( i % 2 == 1 ){
            positionX -= varH;
        }
        positionY += varV;
        varV = -varV;
        mjNode.zPosition = i;
        [self addChild:mjNode];
    }
}

- (void)putLeftMjStatus:(MajiangStatus)status
{
    CGFloat positionX = 0;
    CGFloat positionY =  self.size.height/2-15;
    CGFloat varV = 3.6;  //叠加
    CGFloat varH = mjBackHeight_h ;  //平移
    
    for ( int i = 0; i < _mjHeaps.count; ++i ){
        singleMajiangNode *mjNode = [_mjHeaps objectAtIndex:i];
        [mjNode settingStatus:status];
        mjNode.position = CGPointMake(positionX, positionY);
        if ( i % 2 == 0 ){
            positionY += varV;
        }else{
            positionY = positionY - varH;
        }
        mjNode.zPosition =  i;
        [self addChild:mjNode];
    }
}
@end
