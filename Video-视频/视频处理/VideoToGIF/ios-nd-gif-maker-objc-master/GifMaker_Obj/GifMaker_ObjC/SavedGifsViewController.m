//
//  SavedGifsViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "SavedGifsViewController.h"
#import "UIViewController+Record.h"
#import "UIViewController+Theme.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "DetailViewController.h"

#import "GifCell.h"

#import <QuartzCore/QuartzCore.h>

@interface SavedGifsViewController()

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSArray *savedGifs;

@end

@implementation SavedGifsViewController

#pragma mark View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.emptyView.hidden = self.savedGifs.count != 0;
    
    [self.collectionView reloadData];
    
    // Navigation Bar
    self.title = @"My Collection";
    [self applyTheme:Light];
    self.navigationController.navigationBar.hidden = self.savedGifs.count == 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showWelcome];
    
    // Bottom Blur
    CAGradientLayer *bottomBlur = [CAGradientLayer layer];
    bottomBlur.frame = CGRectMake(0.0f, self.view.frame.size.height - 100.0f, self.view.frame.size.width, 100.0f);
    bottomBlur.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor],
                          (id)[[UIColor whiteColor] CGColor]];
    [self.view.layer insertSublayer:bottomBlur above:self.collectionView.layer];
    
    // Load Stored Gifs
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.savedGifs = appDelegate.gifs;
}

-(void)showWelcome {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"WelcomeViewSeen"] != YES) {
        UIViewController *welcomeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        [self.navigationController pushViewController:welcomeViewController animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = FALSE;
    self.title = @"";
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width - 24.0f) / 2.0f;
    return CGSizeMake(width, width);
}

# pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Gif *gif = [self.savedGifs objectAtIndex:indexPath.item];
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailVC.gif = gif;
    
    detailVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:detailVC animated:YES completion:nil];
}


# pragma mark UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.savedGifs count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifCell" forIndexPath:indexPath];
    
    Gif *gif = [self.savedGifs objectAtIndex:indexPath.row];
    [cell configureForGif:gif];

    return cell;
}

@end
