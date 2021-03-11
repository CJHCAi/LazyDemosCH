//
//  ZQViewController.m
//  PhotoAlbum
//
//  Created by ZhouQian on 07/18/2016.
//  Copyright (c) 2016 ZhouQian. All rights reserved.
//

#import "ZQViewController.h"
#import "PhotoAlbums.h"

@interface ZQViewController ()

@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (IBAction)singleSelectPhoto:(id)sender {
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    [PhotoAlbums photoSingleSelectWithCrop:NO delegate:self didFinishPhotoBlock:^(NSArray<UIImage *> *photos) {
        NSLog(@"%@", [photos firstObject]);
    }];
}
- (IBAction)multiSelectPhoto:(id)sender {
    [PhotoAlbums photoMultiSelectWithMaxImagesCount:9 delegate:self didFinishPhotoBlock:^(NSArray<UIImage *> *photos) {
        NSLog(@"%@", photos);
    }];
}

- (IBAction)video:(id)sender {
    [PhotoAlbums photoVideoWithMaxDurtion:3 Delegate:self updateUIFinishPickingBlock:nil didFinishPickingVideoHandle:^(NSURL *url, UIImage *cover, id avAsset) {
        NSLog(@"%@", url);
        NSLog(@"%@", cover);
        NSLog(@"%@", avAsset);
    }];
}


@end
