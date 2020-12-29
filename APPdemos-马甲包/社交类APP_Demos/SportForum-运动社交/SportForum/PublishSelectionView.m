//
//  PublishSelectionView.m
//  SportForum
//
//  Created by zhengying on 7/10/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "PublishSelectionView.h"

@implementation PublishSelectionView {
    BOOL _visible;
    PUBLISH_MODE _ePuhMode;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)actionQuit {
    [self hide];
}


-(void)awakeFromNib {
    CGRect frame = [UIScreen mainScreen].bounds;
    //frame.origin.y = frame.size.height- _contentView.frame.size.height;
    [_contentView setFrame:frame];
    //_contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"the-lowest-bg"]];
    
    _btnQuit.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - CGRectGetHeight(_btnQuit.frame), CGRectGetWidth(_btnQuit.frame), CGRectGetHeight(_btnQuit.frame));
    _viewBarShadow.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - CGRectGetHeight(_btnQuit.frame) - CGRectGetHeight(_viewBarShadow.frame), CGRectGetWidth(_viewBarShadow.frame), CGRectGetHeight(_viewBarShadow.frame));

    //_viewBarShadow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bot-bar-shadow"]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)]];

    frame = _picTextView.frame;
    frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT);
    _picTextView.frame = frame;
    
    frame = _scoreView.frame;
    frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT);
    _scoreView.frame = frame;
    
    frame = _gameView.frame;
    frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT);
    _gameView.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
     
     
-(IBAction)actionClicked:(id)sender {
    if (sender == _btnPicText) {
        _ActionBlockPicText(sender);
    } else if(sender == _btnRecordScroe) {
        _ScroeActionBlockRecord(sender);
    }
    else if(sender == _btnRecordGame){
        _GameActionBlockRecord(sender);
    }
    
    [self hide];
}


#pragma mark - Presentation

-(void)animateScore
{
    [self moveShowPath:_scoreView];
}

-(void)animateGame
{
    [self moveShowPath:_gameView];
}

- (void) showInView:(UIView*)view PublishMode:(PUBLISH_MODE)ePubType
{
    _ePuhMode = ePubType;
    
    if (ePubType == PUBLISH_MODE_CUSTOM) {
        _contentView.layer.contents = nil;
        _contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        
        _viewBarShadow.layer.contents = nil;
        _viewBarShadow.backgroundColor = [UIColor clearColor];
        [_btnQuit setImage:[UIImage imageNamed:@"bot-bar-cancel"] forState:UIControlStateNormal];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"the-lowest-bg"];
        _contentView.layer.contents = (id) image.CGImage;
        
        image = [UIImage imageNamed:@"bot-bar-shadow"];
        _viewBarShadow.layer.contents = (id) image.CGImage;
        [_btnQuit setImage:[UIImage imageNamed:@"bot-barcancel-1"] forState:UIControlStateNormal];
    }
    
    [view  addSubview:self];
    
    [self setFrame:[view bounds]];
    
    //[_contentView setTransform:CGAffineTransformMakeTranslation(0, [_contentView frame].size.height)];
    //[_contentView setTransform:CGAffineTransformIdentity];
    
    [self moveShowPath:_picTextView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateScore) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animateGame) userInfo:nil repeats:NO];
    
    __typeof(self) __weak weakSelf = self;

    [UIView animateWithDuration:0.5 animations:^{
        __typeof(self) strongSelf = weakSelf;
        strongSelf->_btnQuit.alpha = 1;
    }];
    
    /*[UIView
     animateWithDuration:0
     animations:^{
         
     }
     completion:^(BOOL finished) {
         _visible = YES;
     }];*/
    
}

-(void)closeView
{
    self.closeActionBlock(self);
    [self removeFromSuperview];
    _visible = NO;
}

- (void)hide
{
    [[CommonUtility sharedInstance]playAudioFromName:@"XsinkdownBtn.mp3"];
    
    _btnQuit.alpha = 0;
    
    [self moveHidePath:_picTextView];
    [self moveHidePath:_scoreView];
    [self moveHidePath:_gameView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(closeView) userInfo:nil repeats:NO];
    
    /*[UIView
     animateWithDuration:1
     animations:^{
         
         //CGAffineTransform t = CGAffineTransformIdentity;
        // t = CGAffineTransformTranslate(t, 0, [_contentView frame].size.height);
         //[_contentView setTransform:t];
         
     }
     
     completion:^(BOOL finished) {
         self.closeActionBlock(self);
         [self removeFromSuperview];
         _visible = NO;
     }];*/
    
}

- (void)moveShowPath:(UIView *)view
{
    CGRect frame = view.frame;
    
    if (_ePuhMode == PUBLISH_MODE_NORMAL) {
        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        CGMutablePathRef shakePath = CGPathCreateMutable();
        CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT + frame.size.height / 2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT / 2 - frame.size.height / 2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT / 2);
        
        shakeAnimation.path = shakePath;
        shakeAnimation.duration = 0.5f;
        shakeAnimation.removedOnCompletion = NO;
        shakeAnimation.fillMode = kCAFillModeForwards;
        
        [shakeAnimation setCalculationMode:kCAAnimationLinear];
        [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.6],
                                     [NSNumber numberWithFloat:1.0], nil]];
        
        [view.layer addAnimation:shakeAnimation forKey:nil];
        CFRelease(shakePath);
        
        frame = view.frame;
        frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT / 2 - frame.size.height / 2);
        view.frame = frame;
    }
    else
    {
        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        CGMutablePathRef shakePath = CGPathCreateMutable();
        CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT + frame.size.height / 2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT - APP_SCREEN_HEIGHT / 4 - frame.size.height / 2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT - APP_SCREEN_HEIGHT / 4);
        
        shakeAnimation.path = shakePath;
        shakeAnimation.duration = 0.5f;
        shakeAnimation.removedOnCompletion = NO;
        shakeAnimation.fillMode = kCAFillModeForwards;
        
        [shakeAnimation setCalculationMode:kCAAnimationLinear];
        [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.6],
                                     [NSNumber numberWithFloat:1.0], nil]];
        
        [view.layer addAnimation:shakeAnimation forKey:nil];
        CFRelease(shakePath);
        
        frame = view.frame;
        frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT - APP_SCREEN_HEIGHT / 4 - frame.size.height / 2);
        view.frame = frame;
    }
}

- (void)moveHidePath:(UIView *)view
{
    CGRect frame = view.frame;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    
    if (_ePuhMode == PUBLISH_MODE_NORMAL) {
        CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT / 2 + frame.size.height / 2);
    }
    else
    {
        CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT - APP_SCREEN_HEIGHT / 4 + frame.size.height / 2);
    }
    
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT + frame.size.height);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 0.3f;
    shakeAnimation.removedOnCompletion = NO;
    shakeAnimation.fillMode = kCAFillModeForwards;
    
    [shakeAnimation setCalculationMode:kCAAnimationLinear];
    [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil]];
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    frame = view.frame;
    frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT);
    view.frame = frame;
}

@end
