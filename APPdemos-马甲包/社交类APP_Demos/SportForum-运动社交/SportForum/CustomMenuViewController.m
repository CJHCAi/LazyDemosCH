//
//  CustomMenuViewController.m
//  housefinder
//
//  Created by zhengying on 8/5/13.
//  Copyright (c) 2013 zhengying. All rights reserved.
//

#import "CustomMenuViewController.h"



@interface ButtonMenuItem : NSObject
@property(strong, nonatomic) NSString* titile;
@property(strong, nonatomic) ButtonAction action;
@property(assign, nonatomic) BOOL isHightlight;
@property(weak, nonatomic) UIButton *button; //button ref
@end

@implementation ButtonMenuItem
@end

@interface CustomMenuViewController ()

@end

@implementation CustomMenuViewController {
    NSMutableArray *_menuItems;
    CGFloat _buttionHeight;
    CGFloat _buttionWidth;
    CGFloat _bottomSpace;
    CGFloat _sideSpace;
    BOOL _visible;
    
    UIView* _buttonView;
    CGFloat _currentHeight;
}

-(id)init {
    self = [super init];
    
    _menuItems =  [[NSMutableArray alloc]initWithCapacity:3];
    _verticalSpacing =  10;
    _buttionHeight =  38;
    _bottomSpace = 10;
    _sideSpace =  10.5;
    
    _buttionWidth = self.view.bounds.size.width - _sideSpace * 2;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self view] setOpaque:NO];
    [[self view] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [[self view] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    _buttonView = [UIView new];
    [_buttonView setOpaque:YES];

    [_buttonView setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:_buttonView];
    
    CGRect frame = [[self view] bounds];
    frame.origin.y = frame.size.height-(frame.size.height/3.0);
    frame.size.height /= 3.0;
    [_buttonView setFrame:frame];
    [_buttonView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
    
    CGRect viewBound = _buttonView.bounds;
    
    _currentHeight = viewBound.size.height-_bottomSpace - _buttionHeight;

}

-(void)buttonAction:(id)sender {
    
    for (ButtonMenuItem *item in _menuItems) {
        if (item.button == sender) {
            item.action(sender);
            break;
        }
    }
    
    [self hide];
    
    return;
}

-(void)addButtonFromBackTitle:(NSString*)title ActionBlock:(ButtonAction)action {
    [self addButtonFromBackTitle:title Hightlight:NO ActionBlock:action];
}

-(void)addButtonFromBackTitle:(NSString*)title Hightlight:(BOOL)isHightlight ActionBlock:(ButtonAction)action  {
    ButtonMenuItem *buttonItem = [[ButtonMenuItem alloc]init];
    buttonItem.action = action;
    buttonItem.isHightlight = isHightlight;
    [_menuItems addObject:buttonItem];
    
    UIImage *btnImage = nil;
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(_sideSpace, _currentHeight, _buttionWidth, _buttionHeight)];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:141.0 / 255.0 green:78.0 / 255.0 blue:3.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(buttonItem.isHightlight) {
        btnImage = [UIImage imageNamed:@"btn-1-yellow"];
    } else {
        btnImage = [UIImage imageNamed:@"btn-1-grey"];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    [button setBackgroundImage:[btnImage resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6 , 6 ,6)] forState:UIControlStateNormal];
    
    buttonItem.button = button;
    
    [_buttonView addSubview:button];
    
    _currentHeight = _currentHeight - _buttionHeight - _verticalSpacing;
}

#pragma mark - Presentation

- (void) showInView:(UIView*)view
{

    [[view superview] addSubview:[self view]];
    
    [[self view] setFrame:[[[self view] superview] bounds]];

    [_buttonView setTransform:CGAffineTransformMakeTranslation(0, [_buttonView frame].size.height)];
   
    [UIView
     animateWithDuration:0.3
     animations:^{
         [_buttonView setTransform:CGAffineTransformIdentity];
     }
     completion:^(BOOL finished) {
         _visible = YES;
     }];
    
}


- (void) hide
{
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         CGAffineTransform t = CGAffineTransformIdentity;
         t = CGAffineTransformTranslate(t, 0, [_buttonView frame].size.height);
         [_buttonView setTransform:t];
         
     }
     
     completion:^(BOOL finished) {
         [[self view] removeFromSuperview];
         _visible = NO;
     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
