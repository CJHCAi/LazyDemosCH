//
//  SettingsViewController.m
//  Zoom
//
//  Created by Ben Taylor on 6/12/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize myLabel;
@synthesize myLabel2;
@synthesize myLabel3;
@synthesize mySwitch;
@synthesize mySwitch2;
@synthesize mySwitch3;

float scaleFactor3 = 1.0;

-(void)viewDidLoad{
    
    if ([UIScreen mainScreen].nativeBounds.size.height == 960){
        scaleFactor3 = 960.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1136){
        scaleFactor3 = 1136.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1334){
        scaleFactor3 = 1.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 2208){
        scaleFactor3 = 401.0/326.0*333.5/368.0;
    }
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.title = @"Settings";

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/256.0 green:41.0/256.0 blue:41.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:87.0/256.0 green:87.0/256.0 blue:87.0/256.0 alpha:1.0];
    UIBlurEffect *thisEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *thisViews = [[UIVisualEffectView alloc]initWithEffect:thisEffect];
    thisViews.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:thisViews atIndex:1];


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(thisDone)];
    
    
    
    mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 200, 100, 200)];
    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:mySwitch];
    
    /*
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"BlockDepotLeaderboards"]){
        
        NSMutableDictionary *leadboardHolder = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Test", @"String", nil];
        [[NSUserDefaults standardUserDefaults] setObject:leadboardHolder forKey:@"BlockDepotLeaderboards"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }else{
        NSLog(@"Leaderboards Dict Exists %@", [NSUserDefaults standardUserDefaults]);
    }
     */
    
    myLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 320, 147, 200, 36)];

    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"CameraPosition"]){
        NSLog(@"GOT THIS HERE BRAH");
        NSString *camVal = @"Front";
        [[NSUserDefaults standardUserDefaults] setObject:camVal forKey:@"CameraPosition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [mySwitch setOn:YES animated:NO];
        myLabel.text = @"Default Camera: Front";
    } else {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"CameraPosition"]  isEqual: @"Front"]){
            [mySwitch setOn:YES animated:NO];
            NSLog(@"GOT THIS HERE NOPE");
            myLabel.text = @"Default Camera: Front";
        } else {
            myLabel.text = @"Default Camera: Back ";
            NSLog(@"GOT THIS HERE YERP");
            NSLog(@"THE VAL: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"CameraPosition"]);
        }

        //NSLog(@"Leaderboards Dict Exists %@", [NSUserDefaults standardUserDefaults]);
    }

    [myLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0f]];
    
    myLabel.textColor = [UIColor whiteColor];
    
    [myLabel sizeToFit];
    
    if (scaleFactor3  < 1){
        mySwitch.center = CGPointMake(268.5, 215.5);
        myLabel.center = CGPointMake(125, 215);
    } else {
        myLabel.center = CGPointMake(145, 215);
    }
    
    [self.view addSubview:myLabel];
    
    mySwitch2 = [[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 250, 100, 200)];
    [mySwitch2 addTarget:self action:@selector(changeSwitch2:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:mySwitch2];
    
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"SaveOnCopy"]){
        NSString *camVal = @"NO";
        [[NSUserDefaults standardUserDefaults] setObject:camVal forKey:@"SaveOnCopy"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveOnCopy"]  isEqual: @"YES"]){
            [mySwitch2 setOn:YES animated:NO];
        }
    }
    
    
    
    myLabel2 = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 320, 197, 200, 36)];
    
    myLabel2.text = @"Save GIF on copy";
    
    [myLabel2 setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0f]];
    
    myLabel2.textColor = [UIColor whiteColor];
    
    [myLabel2 sizeToFit];
    
    NSLog(@"THIS CENTER: %@", NSStringFromCGPoint(mySwitch.center));

    if (scaleFactor3  < 1){
        mySwitch2.center = CGPointMake(268.5, 265.5);
        myLabel2.center = CGPointMake(125, 265);
    } else {
        myLabel2.center = CGPointMake(145, 265);
    }
    
    [self.view addSubview:myLabel2];
    
    /*
    mySwitch3 = [[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 250, 100, 200)];
    [mySwitch3 addTarget:self action:@selector(changeSwitch3:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch3];
    
    myLabel3 = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 320, 247, 200, 36)];
    
    myLabel3.text = @"Save GIF on copy";
    
    [myLabel3 setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:19.0f]];
    
    myLabel3.textColor = [UIColor whiteColor];
    
    [myLabel3 sizeToFit];
    
    if (scaleFactor3  < 1){
        mySwitch3.center = CGPointMake(268.5, 265.5);
        myLabel3.center = CGPointMake(125, 265);
    } else {
        myLabel3.center = CGPointMake(145, 265);
    }
    
    [self.view addSubview:myLabel3];
    
     */
}




- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        myLabel.text = @"Default Camera: Front";
        NSString *camVal = @"Front";
        [[NSUserDefaults standardUserDefaults] setObject:camVal forKey:@"CameraPosition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else{
        myLabel.text = @"Default Camera: Back ";
        NSString *camVal = @"Back";
        [[NSUserDefaults standardUserDefaults] setObject:camVal forKey:@"CameraPosition"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



- (void)changeSwitch2:(id)sender{
    if([sender isOn]){
        NSString *camVal = @"YES";
        [[NSUserDefaults standardUserDefaults] setObject:camVal forKey:@"SaveOnCopy"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else{
        NSString *camVal = @"NO";
        [[NSUserDefaults standardUserDefaults] setObject:camVal forKey:@"SaveOnCopy"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}




- (void)changeSwitch3:(id)sender{
    if([sender isOn]){
      //  myLabel.text = @"Default Camera: Front";
    } else{
      //  myLabel.text = @"Default Camera: Back";
    }
}

-(void)thisDone{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
