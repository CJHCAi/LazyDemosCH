//
//  DetailViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/22/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+Theme.h"

#import <QuartzCore/QuartzCore.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.shareButton.layer setCornerRadius:4.0];
    
    self.gifImageView.image = self.gif.gifImage;
    [self applyTheme:DarkTranslucent];
}

- (IBAction)shareGif:(id)sender {
    NSArray *itemsToShare;
    itemsToShare = [NSArray arrayWithObjects: self.gif.gifData, nil];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    [shareController setCompletionWithItemsHandler: ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self presentViewController:shareController animated:YES completion: nil];
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
