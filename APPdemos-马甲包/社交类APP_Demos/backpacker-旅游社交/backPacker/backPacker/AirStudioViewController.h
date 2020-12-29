//
//  AirStudioViewController.h
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudioStateViewController.h"
#import "TMDemoQuiltViewController.h"
#import "StudioAttentionViewController.h"

@interface AirStudioViewController : UIViewController
{
    int lastSelectedIndex;
}
@property (strong, nonatomic) IBOutlet UIView *studioContentView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *studioSegment;

@property (strong, nonatomic) IBOutlet StudioStateViewController *studioStateVC;
@property (strong, nonatomic) IBOutlet TMDemoQuiltViewController *quiltPhotoVC;
@property (strong, nonatomic) IBOutlet StudioAttentionViewController *studioAttentionVC;
- (IBAction)studioSegmentSelected:(id)sender;

@end
