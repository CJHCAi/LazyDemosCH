//
//  PopUpViewController.m
//  NMPopUpView
//
//  Created by Nikos Maounis on 9/12/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@end

@implementation PopUpViewController

@synthesize messageLabel;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    //self =[[PopUpViewController alloc]init];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(16, ([UIScreen mainScreen].bounds.size.height - 300)/2 - 78, [UIScreen mainScreen].bounds.size.width - 32, 220)];
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.view.layer.cornerRadius = 7.0;
        
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showAnimate
{
    
    [self.view addSubview:messageLabel];
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        //self.view.backgroundColor = [UIColor colorWithRed:231.0/256.0 green:231.0/256.0 blue:231.0/256.0 alpha:1.0];
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [aView addSubview:self.view];
    //self.logoImg.image = image;
    //self.messageLabel.text = message;
    if (animated) {
        [self showAnimate];
    }
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
