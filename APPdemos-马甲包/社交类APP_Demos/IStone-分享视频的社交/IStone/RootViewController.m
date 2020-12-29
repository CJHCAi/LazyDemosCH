//
//  RootViewController.m
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

-(void) awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    NSLog(@"[familyNames count]===%lu",(unsigned long)[familyNames count]);
//    for(indFamily=0;indFamily<[familyNames count];++indFamily)
//        
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        
//        for(indFont=0; indFont<[fontNames count]; ++indFont)
//            
//        {
//            NSLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
//            
//        }
//        
//
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
