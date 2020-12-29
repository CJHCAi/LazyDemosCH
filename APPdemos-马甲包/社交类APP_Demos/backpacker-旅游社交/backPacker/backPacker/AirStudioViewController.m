//
//  AirStudioViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "AirStudioViewController.h"

@interface AirStudioViewController ()

@end

@implementation AirStudioViewController

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
    //init segment LastSelectedIndex
    lastSelectedIndex =0;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:5.0/255.0 green:111.0/255.0 blue:209.0/255.0 alpha:1.0]];
    UIFont *Boldfont = [UIFont systemFontOfSize:14.0f];
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont,UITextAttributeFont,[UIColor darkGrayColor],UITextAttributeTextColor,nil];
    
    [self.studioSegment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];

    UIFont *Boldfont2 = [UIFont systemFontOfSize:14.0f];
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont2,UITextAttributeFont,[UIColor colorWithRed:223.0/255.0 green:102.0/255.0 blue:5.0/255.0 alpha:1.0],UITextAttributeTextColor,nil];

    [self.studioSegment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    //set circum childController
    self.quiltPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"quiltvc"];
    [self.quiltPhotoVC.view setFrame:CGRectMake(0, 0, 320, 426)];
    self.studioStateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"studioState"];
    [self.studioStateVC.view setFrame:CGRectMake(0, 0, 320, 426)];
    self.studioAttentionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"studioAttention"];
    [self.studioAttentionVC.view setFrame:CGRectMake(0, 0, 320, 426)];
    [self addChildViewController:self.quiltPhotoVC];
    [self addChildViewController:self.studioStateVC];
    [self addChildViewController:self.studioAttentionVC];
    
    
    [self.studioContentView addSubview:self.quiltPhotoVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)studioSegmentSelected:(id)sender {
    int selectedIndex = [self.studioSegment selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            if (lastSelectedIndex == 1) {
                [self.studioStateVC.view removeFromSuperview];
            }else{
                [self.studioAttentionVC.view removeFromSuperview];
            }
            [self.studioContentView addSubview:self.quiltPhotoVC.view];
            break;
        case 1:
            if (lastSelectedIndex == 0) {
                [self.quiltPhotoVC.view removeFromSuperview];
            }else{
                [self.studioAttentionVC.view removeFromSuperview];
            }
            [self.studioContentView addSubview:self.studioStateVC.view];
            break;
        case 2:
            if (lastSelectedIndex == 0) {
                [self.quiltPhotoVC.view removeFromSuperview];
            }else{
                [self.studioStateVC.view removeFromSuperview];
            }
            [self.studioContentView addSubview:self.studioAttentionVC.view];
            break;

        default:
            break;
    }
}
@end
