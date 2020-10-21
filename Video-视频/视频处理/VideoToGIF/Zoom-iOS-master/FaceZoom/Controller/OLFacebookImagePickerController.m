//
//  FacebookImagePickerController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookImagePickerController.h"
#import "OLAlbumViewController.h"
#import <PECropViewController.h>
#import "UIImageView+FacebookFadeIn.h"

@interface OLFacebookImagePickerController () <OLAlbumViewControllerDelegate>
@property (nonatomic, strong) OLAlbumViewController *albumVC;
@end

@implementation OLFacebookImagePickerController

@dynamic delegate;
@synthesize delegate2;

- (id)init {
    OLAlbumViewController *albumController = [[OLAlbumViewController alloc] init];
    if (self = [super initWithRootViewController:albumController]) {
        self.albumVC = albumController;
        self.albumVC.delegate = self;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return self;
}

- (void)setSelected:(NSArray *)selected {
    self.albumVC.selected = selected;
}

- (NSArray *)selected {
    return self.albumVC.selected;
}

#pragma mark - OLAlbumViewControllerDelegate methods

- (void)albumViewControllerDoneClicked:(OLAlbumViewController *)albumController {
    [self.delegate facebookImagePicker:self didFinishPickingImages:albumController.selected];
    
    /*
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    
    [controller.view setAndFadeInFacebookImageWithURL:[media bestURLForSize:CGSizeMake(220, 220)]];
    
    //OLFacebookImagePickerCell *cell = (OLFacebookImagePickerCell *)thisTap.view;
    
    //controller.image = [albumController.selected objectAtIndex:0];
    
    //NSLog(@"THESE DIMS HAHA: %@", NSStringFromCGSize(((UIImage *)[albumController.selected objectAtIndex:0]).size));
    
    NSLog(@"THIS ARRAY SIZE HAHA: %li", albumController.selected.count);
    
    //controller.image = self.selectedImagesInFuturePages[0];
    //controller.image = self.selectedImagesInFuturePages[0];
    [self showViewController:controller sender:self];
    NSLog(@"nopedy nope lol");

    NSLog(@"this YO");
     */
}

- (void)albumViewController:(OLAlbumViewController *)albumController didFailWithError:(NSError *)error {
    [self.delegate facebookImagePicker:self didFailWithError:error];
}

@end
