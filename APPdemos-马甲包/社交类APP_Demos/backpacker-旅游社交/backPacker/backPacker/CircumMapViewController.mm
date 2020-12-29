//
//  CircumMapViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-11.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "CircumMapViewController.h"
#import "BMapKit.h"
@interface CircumMapViewController ()

@end

@implementation CircumMapViewController

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
//    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    self.view = mapView;
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = mapView;
    [mapView setShowsUserLocation:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
