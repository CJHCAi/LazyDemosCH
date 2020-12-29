//
//  CircumViewController.h
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circum_SceneryViewController.h"
#import "Circum_HouseViewController.h"
#import "Circum_FoodViewController.h"

@interface CircumViewController : UIViewController
{
    int lastSelectedIndex;
}
@property (strong,nonatomic) IBOutlet UINavigationController *sceneryNavC;
@property (strong,nonatomic) IBOutlet UINavigationController *houseNavC;
@property (strong,nonatomic) IBOutlet UINavigationController *foodNavC;

@property (strong,nonatomic) IBOutlet Circum_SceneryViewController *sceneryVC;
@property (strong,nonatomic) IBOutlet Circum_FoodViewController *foodVC;
@property (strong,nonatomic) IBOutlet Circum_HouseViewController *houseVC;


@property (strong, nonatomic) IBOutlet UIView *circumContentView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *circumSegment;
- (IBAction)circumSegmentSelected:(id)sender;

@end
