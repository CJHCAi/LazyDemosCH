//
//  MySidePanelViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-2.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "MySidePanelViewController.h"

@interface MySidePanelViewController ()

@end

@implementation MySidePanelViewController

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
    [self awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) awakeFromNib
{
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightVC"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"tabVC"]];
    [self setLeftPanel:nil];
}

@end
