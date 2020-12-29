//
//  CircumViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "CircumViewController.h"

@interface CircumViewController ()

@end

@implementation CircumViewController

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
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:5.0/255.0 green:111.0/255.0 blue:209.0/255.0 alpha:1.0]];
	// Do any additional setup after loading the view.
    //init
    lastSelectedIndex = 0;
    //set segmentTextColor
    UIFont *Boldfont = [UIFont systemFontOfSize:14.0f];
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont,UITextAttributeFont,[UIColor darkGrayColor],UITextAttributeTextColor,nil];
    
    [self.circumSegment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    UIFont *Boldfont2 = [UIFont systemFontOfSize:14.0f];
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont2,UITextAttributeFont,[UIColor colorWithRed:223.0/255.0 green:102.0/255.0 blue:5.0/255.0 alpha:1.0],UITextAttributeTextColor,nil];
    
    [self.circumSegment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    //set circum childController
    self.sceneryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sceneryVC"];
    self.foodVC = [self.storyboard instantiateViewControllerWithIdentifier:@"foodVC"];
    self.houseVC = [self.storyboard instantiateViewControllerWithIdentifier:@"houseVC"];

    [self addChildViewController:self.sceneryVC];
    [self addChildViewController:self.foodVC];
    [self addChildViewController:self.houseVC];

    
    [self.circumContentView addSubview:self.sceneryVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)circumSegmentSelected:(id)sender {
    int selectIndex = [self.circumSegment selectedSegmentIndex];
    
    switch (selectIndex) {
        case 0:
            if (lastSelectedIndex == 1) {
                [self.foodVC.view removeFromSuperview];
            }else if(lastSelectedIndex == 2){
                [self.houseVC.view removeFromSuperview];
            }
            [self.circumContentView addSubview:self.sceneryVC.view];
            break;
        case 1:
            if (lastSelectedIndex == 0) {
                [self.sceneryVC.view removeFromSuperview];
            }else if(lastSelectedIndex == 2){
                [self.houseVC.view removeFromSuperview];
            }
            [self.circumContentView addSubview:self.foodVC.view];
            break;
        case 2:
            if (lastSelectedIndex == 0) {
                [self.sceneryVC.view removeFromSuperview];
            }else if(lastSelectedIndex == 1){
                [self.foodVC.view removeFromSuperview];
            }
            [self.circumContentView addSubview:self.houseVC.view];
            break;
        case 3:
        
            break;

        default:
            break;
    }
    lastSelectedIndex = selectIndex;
}
@end
