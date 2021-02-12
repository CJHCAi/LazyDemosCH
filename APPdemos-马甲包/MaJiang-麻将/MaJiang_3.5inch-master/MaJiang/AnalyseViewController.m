//
//  AnalyseViewController.m
//  MaJiang
//
//  Created by yu_hao on 1/18/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "AnalyseViewController.h"

@interface AnalyseViewController ()
{
    UILabel *label;
    UIViewController *currentViewController;
}

@end

@implementation AnalyseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create label
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 300, 140);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"对家", @"下家", @"本家", @"上家", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(60, 80, 200, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    // add viewController so you can switch them later.
    UIViewController *vc = [self viewControllerForSegmentIndex:segmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    currentViewController = vc;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pickOne:(id)sender{
//    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
//    label.text = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
//    NSLog(@"%@", label.text);
    
    UIViewController *vc = [self viewControllerForSegmentIndex:[sender selectedSegmentIndex]];
    [self addChildViewController:vc];
    [self transitionFromViewController:currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [currentViewController.view removeFromSuperview];
        vc.view.frame = self.containerView.bounds;
        [self.containerView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [currentViewController removeFromParentViewController];
        currentViewController = vc;
    }];
    self.navigationItem.title = vc.title;
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"对家"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"下家"];
            break;
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"本家"];
            break;
        case 3:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"上家"];
            break;
    }
    return vc;
}

@end
