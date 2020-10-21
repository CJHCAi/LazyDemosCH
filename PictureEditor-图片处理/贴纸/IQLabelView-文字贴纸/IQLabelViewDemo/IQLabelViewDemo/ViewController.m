//
//  ViewController.m
//  IQLabelViewDemo
//
//  Created by kcandr on 20.12.14.

#import "ViewController.h"
#import "IQLabelView.h"

@interface ViewController () <IQLabelViewDelegate>
{
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:88/255.0 green:173/255.0 blue:227/255.0 alpha:1.0]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addLabel
{
    [currentlyEditingLabel hideEditingHandles];
    CGRect labelFrame = CGRectMake(CGRectGetMidX(self.view.frame) - arc4random() % 150,
                                   CGRectGetMidY(self.view.frame) - arc4random() % 200,
                                   60, 50);
    UITextField *aLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    aLabel.enabled=NO;
    [aLabel setClipsToBounds:YES];
    [aLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [aLabel setText:@"我是航天创造造价"];
    aLabel.textColor=[UIColor redColor];
    aLabel.textAlignment=NSTextAlignmentCenter;
    aLabel.backgroundColor=[UIColor yellowColor];
    [aLabel sizeToFit];
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    [labelView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    labelView.delegate = self;
    [labelView setShowContentShadow:NO];
    [labelView setTextView:aLabel];
//    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:12];
    labelView.frame=CGRectMake(50, 100, 200, 50);

    [labelView sizeToFit];
    [self.view addSubview:labelView];
    
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];
}

#pragma mark - Gesture 

- (void)touchOutside:(UITapGestureRecognizer *)touchGesture
{
    [currentlyEditingLabel hideEditingHandles];
}

#pragma mark - IQLabelDelegate

/**删除按钮*/
- (void)labelViewDidClose:(IQLabelView *)label
{
    // some actions after delete label
    [labels removeObject:label];
}

/**label移动缩放*/
- (void)labelViewDidBeginEditing:(IQLabelView *)label
{
    // move or rotate begin
}

/**label显示编辑框*/
- (void)labelViewDidShowEditingHandles:(IQLabelView *)label
{
    // showing border and control buttons
    currentlyEditingLabel = label;
}

/**隐藏编辑框*/
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label
{
    // hiding border and control buttons
    currentlyEditingLabel = nil;
}

/**label开始编辑*/
- (void)labelViewDidStartEditing:(IQLabelView *)label
{
    // tap in text field and keyboard showing
    currentlyEditingLabel = label;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
